//
//  TaskSelector.h
//  FreshbooksTimer
//
//  Created by Dave Grijalva on 7/28/08.
//  Copyright 2008 Dave Grijalva. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProjectSelector;
@class MainViewController;

@interface TaskSelector : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate> {
	MainViewController *mainViewController;
	UIView *modalBackdrop;
	UILabel *taskTextLabel;
	IBOutlet UIPickerView *taskPicker;
	NSMutableDictionary *selectedProject;
	NSMutableDictionary *selectedTask;
}
@property (nonatomic, retain) MainViewController *mainViewController;
@property (nonatomic, retain) UILabel *taskTextLabel;
@property (nonatomic, retain) UIView *modalBackdrop;
@property (nonatomic, retain) NSMutableDictionary *selectedProject;
@property (nonatomic, retain) NSMutableDictionary *selectedTask;

- (IBAction) doneButtonClicked:(id)sender;
- (void) show;
- (void) hide;

- (void)projectDataChanged:(NSNotification *) notification;
- (void)selectedProjectChanged:(NSNotification *) notification;
- (void)setSelectedTaskByIndex:(NSInteger)row;
- (void)setSelectedTaskById:(NSString *)tid;
- (void)clearSelectedTask;
- (void) verifySelectedTask;

@end
