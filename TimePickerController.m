//
//  TimePickerController.m
//  FreshbooksTimer
//
//  Created by Dave Grijalva on 8/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TimePickerController.h"
#import "MainViewController.h"

@implementation TimePickerController

@synthesize timer;
@synthesize mainViewController;
@synthesize modalBackdrop;

- (IBAction) cancelButtonClicked:(id)sender{
	[self close];
}

- (IBAction) doneButtonClicked:(id)sender{
	[timer setByTimeInterval: timePicker.countDownDuration];
	[timer setSeconds:0];
	[self close];
}

- (void) open {
	[mainViewController stopTimer];
	
	//Update View
	timePicker.countDownDuration = [[NSNumber numberWithInteger: timer.seconds_elapsed] doubleValue];
	
	[mainViewController.rootViewController hideTabBar];
	
	modalBackdrop.hidden = NO;
	[UIButton beginAnimations:nil context:nil];
	self.view.frame = CGRectMake(0.0, 200.0, self.view.frame.size.width, self.view.frame.size.height);
	modalBackdrop.alpha = 0.5;
	[UIButton commitAnimations];
}

- (void) close {
	[UIButton beginAnimations:nil context:nil];
	self.view.frame = CGRectMake(0.0, 460.0, self.view.frame.size.width, self.view.frame.size.height);
	modalBackdrop.alpha = 0.0;
	[UIButton commitAnimations];
	[mainViewController.rootViewController showTabBar];
}

#pragma mark UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
	}
	return self;
}

/*
 Implement loadView if you want to create a view hierarchy programmatically
- (void)loadView {
}
 */

/*
 If you need to do additional setup after loading the view, override viewDidLoad.
- (void)viewDidLoad {
}
 */

@end
