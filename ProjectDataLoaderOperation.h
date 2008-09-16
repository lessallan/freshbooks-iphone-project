//
//  ProjectDataLoaderOperation.h
//  FreshbooksTimer
//
//  Created by Dave Grijalva on 8/19/08.
//  Copyright 2008 Dave Grijalva. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProjectDataLoaderOperation : NSOperation {
	id delegate;
}
@property (nonatomic, retain) id delegate;

-(BOOL) networkIsAvailable;

@end

@protocol ProjectDataLoaderOperationDelegate

-(void) projectDataLoaderDidComplete;
-(void) projectDataLoaderDidError:(NSString *) error;

@end

