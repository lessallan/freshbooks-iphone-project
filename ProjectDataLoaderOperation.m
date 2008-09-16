//
//  ProjectDataLoaderOperation.m
//  FreshbooksTimer
//
//  Created by Dave Grijalva on 8/19/08.
//  Copyright 2008 Dave Grijalva. All rights reserved.
//

#import "ProjectDataLoaderOperation.h"
#import "FreshbooksAPI.h"
#import "Reachability.h"


@implementation ProjectDataLoaderOperation

@synthesize delegate;

-(void)main {
	if([self networkIsAvailable]){
		NSString *errorString;
		if([[FreshbooksAPI sharedInstance] loadProjectDataWithError:&errorString]){
			if(self.delegate){
				[self.delegate projectDataLoaderDidComplete];
			}
		}
		else{
			if(self.delegate){
				[self.delegate projectDataLoaderDidError:errorString];
			}
		}
	}
	else {
		[self.delegate projectDataLoaderDidError:@"Network is unavailable."];
	}
}

-(BOOL) networkIsAvailable {
	if([[Reachability sharedReachability] internetConnectionStatus] != NotReachable){
//		NSLog(@"network available");
		return YES;
	}
	else{
//		NSLog(@"network unavailable");
		return NO;
	}
}

@end