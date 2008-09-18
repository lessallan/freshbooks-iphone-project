//
//  FlipsideViewController.m
//  FreshbooksTimer
//
//  Created by Dave Grijalva on 7/17/08.
//  Copyright Dave Grijalva 2008. All rights reserved.
//

#import "FlipsideViewController.h"
#import "CloseOnReturn.h"
#import "FreshbooksAPI.h"


@implementation FlipsideViewController

@synthesize configData;

- (void)viewDidLoad {
	domainInput.clearButtonMode = UITextFieldViewModeWhileEditing;
	domainInput.delegate = [[CloseOnReturn alloc] init];
	keyInput.clearButtonMode = UITextFieldViewModeWhileEditing;
	keyInput.delegate = [[CloseOnReturn alloc] init];
	
	loadingView.alpha = 0.0;

	refreshButton.titleShadowOffset = CGSizeMake(0.0, -1.0);
	signupButton.titleShadowOffset = CGSizeMake(0.0, -1.0);

	
	NSMutableDictionary *auth = [configData valueForKey:@"authentication"];
	domainInput.text = [auth valueForKey:@"domain"];
	keyInput.text = [auth valueForKey:@"apikey"];
	keyInput.isSecureTextEntry = !![auth valueForKey:@"isValid"];
}

// Make sure fields are visible for editing
- (void) slideUp {
	[UIView beginAnimations:nil context:nil];
	self.view.frame = CGRectMake(0.0, -167.0, self.view.frame.size.width, self.view.frame.size.height);
	[UIView commitAnimations];
}

// Return view to normal after editing
- (void) slideDown {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelay: 0.01];  // Make sure there's no jumpyness if we move from one field to another.
	self.view.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
	[UIView commitAnimations];
}

- (IBAction)fieldEditingBegan:(UITextField *)sender {
	[self slideUp];
}

//- (void)viewWillAppear:(BOOL)animated {
//	NSMutableDictionary *auth = [configData valueForKey:@"authentication"];
//	domainInput.text = [auth valueForKey:@"domain"];
//	keyInput.text = [auth valueForKey:@"apikey"];
//
//	[super viewWillAppear:animated];
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)keyInputChanged:(UITextField *)sender{
	NSMutableDictionary *auth = [configData valueForKey:@"authentication"];
	[auth setValue:sender.text forKey:@"apikey"];
	[self validateAuthData];
	[self slideDown];
	
	if([sender.text length] == 0){
		keyInput.isSecureTextEntry = NO;
	}
}

- (IBAction)domainInputChanged:(UITextField *)sender{
	NSMutableDictionary *auth = [configData valueForKey:@"authentication"];
	
	//clean domain string
	NSString *domain = [sender.text stringByReplacingOccurrencesOfString:@"http://" withString:@""];
	domain = [domain stringByReplacingOccurrencesOfString:@"https://" withString:@""];
	domain = [[domain componentsSeparatedByString:@"."] objectAtIndex:0];

	[auth setValue:domain forKey:@"domain"];
	[self validateAuthData];
	[self slideDown];
}

- (void) validateAuthData {
	NSString *domain = [configData valueForKeyPath:@"authentication.domain"];
	NSString *key = [configData valueForKeyPath:@"authentication.apikey"];
	
	if(domain && key && domain.length && key.length){
		refreshButton.enabled = true;
		[[FreshbooksAPI sharedInstance] setDomain:domain andKey:key];
		[self refreshProjectData:nil];
	} else {
		refreshButton.enabled = false;
		[configData setValue:nil forKeyPath:@"authentication.isValid"];
	}
}

-  (IBAction)refreshProjectData:(UIButton *)sender{
	[UIView beginAnimations:nil context:nil];
	loadingView.alpha = 1.0;
	[UIView commitAnimations];
	[[FreshbooksAPI sharedInstance] loadProjectDataWithDelegate: self];
}

- (void) projectDataLoaderDidComplete {
	[UIView beginAnimations:nil context:nil];
	loadingView.alpha = 0.0;
	[UIView commitAnimations];

	keyInput.isSecureTextEntry = YES;
	[configData setValue:@"YES" forKeyPath:@"authentication.isValid"];
}

-(void) projectDataLoaderDidError:(NSString *) error {
	[UIView beginAnimations:nil context:nil];
	loadingView.alpha = 0.0;
	[UIView commitAnimations];
	[[[[UIAlertView alloc] initWithTitle:@"Error Loading Project Data" message:error delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] autorelease] show];
	keyInput.isSecureTextEntry = NO;
	[configData setValue:nil forKeyPath:@"authentication.isValid"];
}

-  (IBAction)signupButtonPressed:(UIButton *)sender{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.freshbooks.com/subscribe.php"]];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[super dealloc];
}


@end
