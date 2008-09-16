//
//  QueueViewTableCell.h
//  FreshbooksTimer
//
//  Created by Dave Grijalva on 8/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueueViewController.h"

@interface QueueViewTableCell : UITableViewCell {
	IBOutlet UILabel *timeLabel;
	
	IBOutlet UILabel *projectLabel;
	IBOutlet UILabel *taskLabel;
	IBOutlet UILabel *notesLabel;
	
	IBOutlet UIImageView *invalidIcon;
	IBOutlet UIButton *deleteButton;
	
	NSMutableDictionary *entry;
	QueueViewController *tableController;
}

@property (nonatomic, retain) NSMutableDictionary *entry;
@property (nonatomic, retain) QueueViewController *tableController;

- (IBAction) deleteButtonPressed: (id)sender;
	
- (void) update;

@end
