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

#import <UIKit/UIKit.h>
#import "Timer.h"
#import "ProjectSelector.h"
#import "TaskSelector.h"
#import "QueueViewController.h"
#import "EditNoteController.h"

@class TimePickerController;
@class RootViewController;

@interface MainViewController : UIViewController <TimerDelgate,UIActionSheetDelegate> {
	IBOutlet UIButton *timeButton;
	IBOutlet UIButton *startButton;
	IBOutlet UIButton *resetButton;
	IBOutlet UIButton *submitButton;
	IBOutlet UIView *modalBackdrop;
	IBOutlet UILabel *savedText;
	IBOutlet UIImageView *editTimeIcon;

	IBOutlet UIButton *projectButton;
	IBOutlet UIButton *taskButton;
	IBOutlet UIButton *noteButton;
	IBOutlet UILabel *projectLabel;
	IBOutlet UILabel *taskLabel;
	IBOutlet UILabel *notesLabel;
	IBOutlet UILabel *projectTextLabel;
	IBOutlet UILabel *taskTextLabel;
	IBOutlet UILabel *notesTextLabel;
	
	
	RootViewController *rootViewController;
	Timer *timer;
	TimePickerController *timePickerController;
	NSMutableDictionary *configData;
	UIActionSheet *resetSheet;
	ProjectSelector *projectSelector;
	TaskSelector *taskSelector;
	QueueViewController *queueViewController;
	EditNoteController *noteController;
}
@property (nonatomic, retain) Timer *timer;
@property (nonatomic, retain) RootViewController *rootViewController;
@property (nonatomic, retain) NSMutableDictionary *configData;
@property (nonatomic, retain) ProjectSelector *projectSelector;
@property (nonatomic, retain) TaskSelector *taskSelector;
@property (nonatomic, retain) QueueViewController *queueViewController;
@property (nonatomic, retain) EditNoteController *noteController;

- (IBAction)startButtonClicked:(UIButton *)sender; 
- (IBAction)timeButtonClicked:(UIButton *)sender;
- (IBAction)timeDoneButtonClicked:(id)sender;
- (IBAction)showSettings:(id)sender;
- (IBAction)resetButtonClicked:(id)sender;
- (IBAction)submitButtonClicked:(id)sender;
- (IBAction)addNoteButtonClicked:(id)sender;
- (IBAction)projectButtonClicked:(id)sender;
- (IBAction)taskButtonClicked:(id)sender;

- (IBAction)projectButtonTouchDown:(UIButton *)sender;
- (IBAction)projectButtonTouchCancel:(UIButton *)sender;
- (void) highlightTextForButton:(UIButton *)button;
- (void) restoreTextForButton:(UIButton *)button;

- (void)startTimer;
- (void)stopTimer;

- (void) loadConfigData;
- (BOOL) validateDataExists;
- (void) selectedProjectDidUpdate:(NSMutableDictionary *)selectedProject;
- (void) selectedTaskDidUpdate:(NSMutableDictionary *)selectedTask;

@end

@interface UIButton (simple)

- (void) setTitle:(NSString *)new_title;
- (void) setImage:(UIImage *)new_image;

@end
