//
//  FreshbooksAPI.h
//  FreshbooksTimer
//
//  Created by Dave Grijalva on 7/21/08.
//  Copyright 2008 Dave Grijalva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubmissionQueue.h"


@interface FreshbooksAPI : NSObject {
	NSString *domain;
	NSString *apiKey;
	NSURL *apiURL;
	NSMutableArray *projectData;
	SubmissionQueue *timeEntryQueue;
	NSOperationQueue *operationQueue;
}
@property (nonatomic,retain) NSMutableArray *projectData;
@property (nonatomic,retain) SubmissionQueue *timeEntryQueue;


+ (FreshbooksAPI*)sharedInstance;

- (void)setDomain:(NSString *)newDomain andKey:(NSString *)key;
- (void) loadProjectData;
- (BOOL) loadProjectDataWithError: (NSString **)error;
- (void) loadProjectDataWithDelegate: (id) delegate;
- (NSMutableArray *) getTasksForProject:(NSString *)projectId;
- (NSString *) xmlEscape:(NSString *) inputString;

- (NSData *) performCall:(NSString *)requestBody;
- (NSURLConnection *)performCall:(NSString *)requestBody withDelegate:(id) delegate;


@end
