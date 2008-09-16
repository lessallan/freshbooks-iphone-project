//
//  RootViewController.h
//  FreshbooksTimer
//
//  Created by Dave Grijalva on 7/17/08.
//  Copyright Dave Grijalva 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;
@class FlipsideViewController;
@class QueueViewController;

@interface RootViewController : UIViewController <UITabBarDelegate> {

	IBOutlet UIButton *infoButton;
	IBOutlet UITabBar *tabBar;
	IBOutlet UITabBarItem *queueViewButton;

	MainViewController *mainViewController;
	FlipsideViewController *flipsideViewController;
	QueueViewController *queueViewController;
	
	UINavigationBar *flipsideNavigationBar;
	NSMutableDictionary *configData;
}

@property (nonatomic, retain) UIButton *infoButton;
@property (nonatomic, retain) MainViewController *mainViewController;
@property (nonatomic, retain) UINavigationBar *flipsideNavigationBar;
@property (nonatomic, retain) FlipsideViewController *flipsideViewController;
@property (nonatomic, retain) QueueViewController *queueViewController;
@property (nonatomic, retain) NSMutableDictionary *configData;

- (IBAction)toggleView;
- (void)hideInfoButton;
- (void)showInfoButton;
- (void)selectTabByTag:(NSInteger) tag;

- (void)hideTabBar;
- (void)showTabBar;

- (void)showMainView;
- (void)showSettingsView;
- (void)showQueueView;

- (void)loadConfigData;

@end
