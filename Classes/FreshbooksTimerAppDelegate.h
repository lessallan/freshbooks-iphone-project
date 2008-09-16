//
//  FreshbooksTimerAppDelegate.h
//  FreshbooksTimer
//
//  Created by Dave Grijalva on 7/17/08.
//  Copyright Dave Grijalva 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface FreshbooksTimerAppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow *window;
	IBOutlet RootViewController *rootViewController;
	NSMutableDictionary *configData;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) RootViewController *rootViewController;
@property (nonatomic, retain) NSMutableDictionary *configData;

- (void)readApplicationPList;
- (BOOL)writeApplicationPList;
- (NSData *)applicationDataFromFile:(NSString *)fileName;
- (BOOL)writeApplicationData:(NSData *)data toFile:(NSString *)fileName;

@end

