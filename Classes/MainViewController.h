//
//  MainViewController.h
//  FreshbooksTimer
//
//  Created by Dave Grijalva on 7/17/08.
//  Copyright Dave Grijalva 2008. All rights reserved.
//

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
