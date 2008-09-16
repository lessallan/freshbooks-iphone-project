//
//  EditNoteController.h
//  FreshbooksTimer
//
//  Created by Dave Grijalva on 8/14/08.
//  Copyright 2008 Dave Grijalva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FullPagePopupViewController.h"

@interface EditNoteController : FullPagePopupViewController <UIActionSheetDelegate> {
	IBOutlet UITextView *textView;
	NSMutableDictionary *appState;
}

@property (nonatomic, retain) NSMutableDictionary *appState;

- (NSString *)note;
- (void) restoreNoteContentFromSavedState;

- (IBAction) clearNoteButtonPressed:(id) sender;

@end
