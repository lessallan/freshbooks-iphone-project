//
//  FreshbooksTimerAppDelegate.m
//  FreshbooksTimer
//
//  Created by Dave Grijalva on 7/17/08.
//  Copyright Dave Grijalva 2008. All rights reserved.
//

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
