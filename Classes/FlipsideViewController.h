//
//  FlipsideViewController.h
//  FreshbooksTimer
//
//  Created by Dave Grijalva on 7/17/08.
//  Copyright Dave Grijalva 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectDataLoaderOperation.h"

@interface FlipsideViewController : UIViewController <ProjectDataLoaderOperationDelegate,UITextFieldDelegate> {
	IBOutlet UITextField *domainInput;
	IBOutlet UITextField *keyInput;
	IBOutlet UIView *loadingView;
	IBOutlet UIButton *refreshButton;
	IBOutlet UIButton *signupButton;
	NSMutableDictionary *configData;
}

@property (nonatomic, retain) NSMutableDictionary *configData;

-  (IBAction)fieldEditingBegan:(UITextField *)sender;
-  (IBAction)domainInputChanged:(UITextField *)sender;
-  (IBAction)keyInputChanged:(UITextField *)sender;
-  (IBAction)signupButtonPressed:(UIButton *)sender;
-  (IBAction)refreshProjectData:(UIButton *)sender;

- (void) validateAuthData;

@end
