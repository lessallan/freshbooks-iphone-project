//
//  SubmissionQueue.h
//  FreshbooksTimer
//
//  Created by Dave Grijalva on 8/12/08.
//  Copyright 2008 Dave Grijalva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubmissionQueue : NSObject {
	NSMutableArray *queue;
	NSMutableDictionary *currentSubmission;
	NSMutableData *partialResponse;
}
@property (nonatomic,retain) NSMutableArray *queue;
@property (nonatomic,retain) NSMutableDictionary *currentSubmission;

- (id) initWithQueue:(NSMutableArray *)q;

- (BOOL) submitTime:(NSInteger)seconds project:(NSMutableDictionary *)project task:(NSMutableDictionary *)task note:(NSString *)note error:(NSString **)error;

- (NSInteger)size;
- (NSInteger)invalidCount;

- (void) submitNextEntry;
- (NSMutableDictionary *) nextValidEntry;

@end
