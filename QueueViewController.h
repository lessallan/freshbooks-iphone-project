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
