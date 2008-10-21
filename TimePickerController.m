/*
 Copyright (c) 2008, 2ndSite Inc.
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice,
 this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * Neither the name of the <ORGANIZATION> nor the names of its
 contributors may be used to endorse or promote products derived from this
 software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

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

- (void)viewDidLoad {
	// There's something wrong with the latest interface builder and this component.  
	// Creating it dynamically.
	timePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 320.0, 216.0)];
	timePicker.datePickerMode = UIDatePickerModeCountDownTimer;
	timePicker.countDownDuration = 0;
	[self.view addSubview:timePicker];
}

@end
