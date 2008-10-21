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

#import "FreshbooksTimerAppDelegate.h"
#import "RootViewController.h"
#import "FreshbooksAPI.h"

@implementation FreshbooksTimerAppDelegate


@synthesize window;
@synthesize rootViewController;
@synthesize configData;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[self readApplicationPList];
	rootViewController.configData = configData;
	[rootViewController loadConfigData];
	[window addSubview:[rootViewController view]];
	[window makeKeyAndVisible];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleQueueLengthChanged:) name:@"Queue Length Changed" object:nil];
	
	// Queue information is loaded.  Make sure state gets restored.
	[[NSNotificationCenter defaultCenter] postNotificationName:@"Queue Length Changed" object:nil];

}

- (void)applicationWillTerminate:(UIApplication *)application {
	[self writeApplicationPList];
}

- (void)dealloc {
	[rootViewController release];
	[window release];
	[super dealloc];
}

- (void)readApplicationPList{
	NSString *error;
	NSPropertyListFormat format;
	NSData *retData;
	
	retData = [self applicationDataFromFile:@"settings.plist"];
	if(!retData){
		configData = [NSMutableDictionary dictionary];
		[configData setValue:[NSMutableDictionary dictionary] forKey:@"authentication"];
		[configData setValue:[NSMutableDictionary dictionary] forKey:@"state"];
		[configData setValue:[NSMutableArray array] forKey:@"projectData"];
		[configData setValue:[NSMutableArray array] forKey:@"queue"];
	}
	else{
		configData = [NSPropertyListSerialization propertyListFromData:retData mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&error];
	}
//	NSLog(@"Config data loaded: %@", configData);
}

- (NSData *)applicationDataFromFile:(NSString *)fileName {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
	NSData *myData = [[[NSData alloc] initWithContentsOfFile:appFile] autorelease];
	return myData;
}

- (void)handleQueueLengthChanged:(NSNotification *) notification {
	NSInteger queue_size = [[[FreshbooksAPI sharedInstance] timeEntryQueue] size];
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber: queue_size];
	[self writeApplicationPList];
}

- (BOOL)writeApplicationData:(NSData *)data toFile:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (!documentsDirectory) {
        NSLog(@"Documents directory not found!");
        return NO;
    }
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    return ([data writeToFile:appFile atomically:YES]);
}
	
- (BOOL)writeApplicationPList{
//	NSLog(@"start_date, %@ ", [configData valueForKeyPath:@"state.start_date"]);
	NSString *error;
    NSData *pData = [NSPropertyListSerialization dataFromPropertyList:configData format:NSPropertyListBinaryFormat_v1_0 errorDescription:&error];
    if (!pData) {
        NSLog(@"%@", error);
        return NO;
    }
    return ([self writeApplicationData:pData toFile:@"settings.plist"]);
}

@end
