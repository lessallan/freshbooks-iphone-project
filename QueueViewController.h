//
//  QueueViewController.h
//  FreshbooksTimer
//
//  Created by Dave Grijalva on 8/12/08.
//  Copyright 2008 Dave Grijalva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FullPagePopupViewController.h"
#import "RootViewController.h"

@interface QueueViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate> {
	IBOutlet UIButton *syncButton;
	
	IBOutlet UITableView *tableView;
	IBOutlet UILabel *selectPromptLabel;
	IBOutlet UIView *detailsView;
	IBOutlet UILabel *hoursLabel;
	IBOutlet UILabel *projectLabel;
	IBOutlet UILabel *taskLabel;
	IBOutlet UILabel *errorPromptLabel;
	IBOutlet UILabel *errorLabel;

	UIActionSheet *deleteSheet;
	RootViewController *rootViewController;

	NSMutableDictionary *selectedEntry;
}

@property (nonatomic, retain) NSMutableDictionary *selectedEntry;
@property (nonatomic, retain) RootViewController *rootViewController;

- (void) deleteButtonClickedFor:(NSMutableDictionary *) entry;
- (IBAction) retryButtonClicked:(id) sender;

@end
