/*
 Copyright (c) 2008, 2ndSite Inc.
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice,
 this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * Neither the name of the <ORGANIZATION> nor the names of its
 contributors may be used to endorse or promote products derived from this
 software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "SubmissionQueue.h"
#import "FreshbooksAPI.h"
#import "TouchXML.h"


@implementation SubmissionQueue

@synthesize queue;
@synthesize currentSubmission;

- (id) initWithQueue:(NSMutableArray *)q {
	if (self = [super init]) {
		self.queue = q;
		if(self.queue.count > 0){
			[self submitNextEntry];
		}
	}
	return self;
}

- (BOOL) submitTime:(NSInteger)seconds project:(NSMutableDictionary *)project task:(NSMutableDictionary *)task note:(NSString *)note error:(NSString **)error{
	
	if(seconds > 0 && project && task){
		NSMutableDictionary *entry = [NSMutableDictionary dictionary];
		[entry setObject:[NSNumber numberWithInteger:seconds] forKey:@"seconds"];
		[entry setObject:project forKey:@"project"];
		[entry setObject:task forKey:@"task"];
		// make sure there is a value for the note
		if(note){
			[entry setObject:note forKey:@"note"];
		}
		else{
			[entry setObject:@"" forKey:@"note"];
		}
		// Make sure each object is unique.
		[entry setObject:[NSDate date] forKey:@"submissionKey"];
		[entry setObject:[NSDate date] forKey:@"submission_time"];
		[self.queue addObject:entry];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"Queue Length Changed" object:nil];
		if(self.currentSubmission == nil){
			[self submitNextEntry];
		}
		return YES;
	}
	else if (seconds == 0){
		*error = @"You cannot submit a time entry for 0 seconds";
	}
	else if (!project){
		*error = @"You must select a project";
	}
	else{
		*error = @"You must select a task";
	}
	
	return NO;
}	
	
- (NSInteger)size {
	return self.queue.count;
}

- (NSInteger)invalidCount {
	NSInteger ic = 0;
	for (NSInteger i = 0; i < self.queue.count; ++i) {
		if([[self.queue objectAtIndex:i] valueForKey:@"isInvalid"]){
			++ic;
		}
	}
	return ic;
}

- (void) submitNextEntry {

	if(self.currentSubmission = [self nextValidEntry]){
		
		NSString *formattedDate = [[[self.currentSubmission valueForKeyPath:@"submissionKey"] description] substringToIndex:10 ];

		NSString *call = [NSString stringWithFormat: 
						  @"<?xml version=\"1.0\" encoding=\"utf-8\"?><request method=\"time_entry.create\"><time_entry><project_id>%@</project_id><task_id>%@</task_id><hours>%f</hours><notes><![CDATA[%@]]></notes><date>%@</date></time_entry></request>", 
						  [self.currentSubmission valueForKeyPath:@"project.id"], 
						  [self.currentSubmission valueForKeyPath:@"task.id"], 
						  ([[self.currentSubmission valueForKeyPath:@"seconds"] doubleValue] / 3600.0), 
						  [[FreshbooksAPI sharedInstance] xmlEscape:[self.currentSubmission valueForKeyPath:@"note"]],
						  formattedDate
						  ];
		NSLog(call);

		[[FreshbooksAPI sharedInstance] performCall:call withDelegate: self];
	}
}

- (NSMutableDictionary *) nextValidEntry {
	for (NSInteger i = 0; i < self.queue.count; ++i) {
		if(![[self.queue objectAtIndex:i] valueForKey:@"isInvalid"]){
			return [self.queue objectAtIndex:i];
		}
	}
	return nil;
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	if(!partialResponse){
		partialResponse = [[NSMutableData dataWithLength:0] retain];
	}
	[partialResponse appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSError *err;
	CXMLDocument *xmlDoc = [[CXMLDocument alloc] initWithData:partialResponse options:0 error:&err];
	if([@"ok" caseInsensitiveCompare:[[[xmlDoc rootElement] attributeForName:@"status"] stringValue]] == NSOrderedSame){
		[self.queue removeObject:self.currentSubmission];
		self.currentSubmission = nil;
	}
	else{
		NSString *error = [[[[xmlDoc rootElement] elementsForName:@"error"] objectAtIndex:0] stringValue];
		NSLog(@"API ERROR: %@", error);
		[self.currentSubmission setValue:@"YES" forKey:@"isInvalid"];
		[self.currentSubmission setValue:error forKey:@"errorMessage"];
	}

	[[NSNotificationCenter defaultCenter] postNotificationName:@"Queue Length Changed" object:nil];
	if(self.queue.count > 0){
		[self submitNextEntry];
	}
	
	[partialResponse release];
	partialResponse = nil;
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	// Retry in 5 minutes
	[NSTimer scheduledTimerWithTimeInterval:300.0 target:self selector:@selector(retryByTimer:) userInfo:nil repeats:NO];
	NSLog(@"Connection error.");
}

- (void)retryByTimer:(NSTimer *)timer {
	[self submitNextEntry];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
	// Do not cache responses
	return nil;
}





@end
