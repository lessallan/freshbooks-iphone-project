//
//  ProjectSelector.h
//  FreshbooksTimer
//
//  Created by Dave Grijalva on 7/24/08.
//  Copyright 2008 Dave Grijalva. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface ProjectSelector : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate> {
	MainViewController *mainViewController;
	UIView *modalBackdrop;
	UILabel *projectTextLabel;
	IBOutlet UIPickerView *projectPicker;
	NSMutableDictionary *selectedProject;
}
@property (nonatomic, retain) MainViewController *mainViewController;
@property (nonatomic, retain) UILabel *projectTextLabel;
@property (nonatomic, retain) UIView *modalBackdrop;
@property (nonatomic, retain) NSMutableDictionary *selectedProject;

- (IBAction) doneButtonClicked:(id)sender;
- (void) show;
- (void) hide;
- (void)projectDataChanged:(NSNotification *)notification;
- (void)setSelectedProjectByIndex:(NSInteger)row;
- (void)setSelectedProjectById: (NSString *)id;
- (void) clearSelectedProject;
- (void)validateSelectedProject;

@end
