//
//  TimePickerController.h
//  FreshbooksTimer
//
//  Created by Dave Grijalva on 8/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Timer.h"

@class MainViewController;

@interface TimePickerController : UIViewController {
	IBOutlet UIDatePicker *timePicker;
	
	MainViewController *mainViewController;
	UIView *modalBackdrop;
	Timer *timer;
}

@property (nonatomic, retain) Timer *timer;
@property (nonatomic, retain) MainViewController *mainViewController;
@property (nonatomic, retain) UIView *modalBackdrop;

- (IBAction) cancelButtonClicked:(id)sender;
- (IBAction) doneButtonClicked:(id)sender;

- (void)open;
- (void)close;

@end
