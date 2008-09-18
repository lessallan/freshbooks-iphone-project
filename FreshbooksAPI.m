//
//  FreshbooksAPI.m
//  FreshbooksTimer
//
//  Created by Dave Grijalva on 7/21/08.
//  Copyright 2008 Dave Grijalva. All rights reserved.
//

#import "FreshbooksAPI.h"
#import "TouchXML.h"
#import "FreshbooksTimerAppDelegate.h"
#import "ProjectDataLoaderOperation.h"


@implementation FreshbooksAPI

static FreshbooksAPI *sharedInstance = nil;

@synthesize projectData;
@synthesize timeEntryQueue;

- (void)setDomain:(NSString *)newDomain andKey:(NSString *)key {
	if(domain){
		[domain release];
	}
	domain = [newDomain retain];
	
	if(apiKey){
		[apiKey release];
	}
	apiKey = [key retain];

	if(apiURL){
		[apiURL release];
	}
	apiURL = [[NSURL URLWithString:[NSString stringWithFormat:@"https://%@:X@%@.freshbooks.com/api/2.1/xml-in", apiKey, domain]] retain];
	NSLog(@"setting url: %@ \n user: %@", apiURL, [apiURL user]);
}

- (void) loadProjectDataWithDelegate: (id) delegate {
	if(!operationQueue){
		operationQueue = [[NSOperationQueue alloc] init];
	}
	ProjectDataLoaderOperation *op = [[ProjectDataLoaderOperation alloc] init];
	op.delegate = delegate;
	[operationQueue addOperation:op];
	[op autorelease];
}

- (void) loadProjectData {
	NSString *err;
	[self loadProjectDataWithError: &err];
}

- (BOOL) loadProjectDataWithError: (NSString **)error {
	
	@try{
		NSMutableDictionary *project;
		NSError *err;

		NSData *responseData = [self performCall:@"<?xml version=\"1.0\" encoding=\"utf-8\" ?><request method=\"project.list\"></request>"];
		
		CXMLDocument *xmlDoc = [[CXMLDocument alloc] initWithData:responseData options:0 error:&err];
		if([@"ok" caseInsensitiveCompare:[[[xmlDoc rootElement] attributeForName:@"status"] stringValue]] == NSOrderedSame){
			self.projectData = [NSMutableArray array];
			NSArray *projects = [[[[xmlDoc rootElement] elementsForName:@"projects"] objectAtIndex:0] elementsForName:@"project"];
			
			for (int i = 0; i < [projects count]; ++i) {
				project = [NSMutableDictionary dictionary];
				[project setValue:[[[[projects objectAtIndex:i] elementsForName:@"project_id"] objectAtIndex:0] stringValue] forKey:@"id"];
				[project setValue:[[[[projects objectAtIndex:i] elementsForName:@"name"] objectAtIndex:0] stringValue] forKey:@"name"];
				[project setValue:[self getTasksForProject:[project valueForKey:@"id"]] forKey:@"tasks"];
				[projectData addObject:project];
			}
			
			FreshbooksTimerAppDelegate *appdel = [[UIApplication sharedApplication] delegate];
			NSMutableDictionary *configData = [appdel configData];
			[configData setValue:projectData forKey:@"projectData"];
			[configData setValue:[NSDate date] forKey:@"projectDataDate"];
			
			[[NSNotificationCenter defaultCenter] postNotificationName:@"ProjectDataChanged" object:self];
			return YES;
		} else {
			*error = [[[[xmlDoc rootElement] elementsForName:@"error"] objectAtIndex:0] stringValue];
			NSLog(@"Failure loading project data");
		}
		
	} @catch (id localException) {
		NSLog(@"barf! %@", [localException name]);
	}
	return NO;
}

- (NSMutableArray *) getTasksForProject:(NSString *)projectId {
	NSError *err;
	NSMutableDictionary *task;
	NSMutableArray *tasks = [NSMutableArray array];
	NSData *taskResponseData = [self performCall: [NSString stringWithFormat:
										   @"<?xml version=\"1.0\" encoding=\"utf-8\" ?><request method=\"task.list\"><project_id>%@</project_id></request>", 
										   projectId
										   ]];
	
	CXMLDocument *xmlDoc = [[CXMLDocument alloc] initWithData:taskResponseData options:0 error:&err];
	NSArray *xmlTasks = [[[[xmlDoc rootElement] elementsForName:@"tasks"] objectAtIndex:0] elementsForName:@"task"];
	for (int i = 0; i < [xmlTasks count]; ++i) {
		task = [NSMutableDictionary dictionary];
		[task setValue:[[[[xmlTasks objectAtIndex:i] elementsForName:@"task_id"] objectAtIndex:0] stringValue] forKey:@"id"];
		[task setValue:[[[[xmlTasks objectAtIndex:i] elementsForName:@"name"] objectAtIndex:0] stringValue] forKey:@"name"];
		[tasks addObject:task];
	}
	return tasks;
}

- (NSString *) xmlEscape:(NSString *) inputString {
	inputString = [inputString stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
	inputString = [inputString stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
	inputString = [inputString stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
	return inputString;
}

// Perform syncronous call
- (NSData *) performCall:(NSString *)requestBody {

	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:apiURL];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"Freshbooks iPhone Client 1.0" forHTTPHeaderField:@"X-User-Agent"];
	[request setHTTPBody:[requestBody dataUsingEncoding: NSUTF8StringEncoding]];
	
	NSURLResponse *response;
	NSError *err;
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];

	return responseData;
}

// Perform asyncronous call
- (NSURLConnection *)performCall:(NSString *)requestBody withDelegate:(id) delegate {

	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:apiURL];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"Freshbooks iPhone Client 1.0" forHTTPHeaderField:@"X-User-Agent"];
	[request setHTTPBody:[requestBody dataUsingEncoding: NSUTF8StringEncoding]];
	
	NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate: delegate];
	return connection;
}



/* SINGLETON STUFF */
#pragma mark SINGLETON

+ (FreshbooksAPI*)sharedInstance
{
    @synchronized(self) {
        if (sharedInstance == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id)init {
	if(self = [super init]){
		FreshbooksTimerAppDelegate *appdel = [[UIApplication sharedApplication] delegate];
		NSMutableDictionary *configData = [appdel configData];
		NSString *ldomain = [configData valueForKeyPath:@"authentication.domain"];
		NSString *lkey = [configData valueForKeyPath:@"authentication.apikey"];
		if(ldomain && lkey){
			[self setDomain:ldomain andKey:lkey];
		}
		
		self.projectData = [configData valueForKey:@"projectData"];
//		NSLog(@"loaded project data: %i projects", self.projectData.count);
//		NSLog(@"Project data is %f seconds old: %@", [[configData valueForKey:@"projectDataDate"] timeIntervalSinceNow], [configData valueForKey:@"projectDataDate"]);
		self.timeEntryQueue = [[SubmissionQueue alloc] initWithQueue:[configData valueForKey:@"queue"]];
		
		// reload data if it is older than one hour
		if([[configData valueForKey:@"projectDataDate"] timeIntervalSinceNow] < -3600.0){
			NSLog(@"project date is older than an hour.  refreshing");
			[self loadProjectDataWithDelegate:nil];
		}
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

@end