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

#import "RootViewController.h"
#import "MainViewController.h"
#import "FlipsideViewController.h"
#import "FreshbooksAPI.h"

@implementation RootViewController

@synthesize infoButton;
@synthesize flipsideNavigationBar;
@synthesize mainViewController;
@synthesize flipsideViewController;
@synthesize queueViewController;
@synthesize configData;


- (void)viewDidLoad {
	
	[self showMainView];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleQueueLengthChanged:) name:@"Queue Length Changed" object:nil];
	
	[self hideInfoButton];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
	if(item.tag == 0){
		[self showSettingsView];
	}
	else if(item.tag == 1){
		[self showMainView];
	}
	else if(item.tag == 2){
		[self showQueueView];
	}
		
}

- (void)selectTabByTag:(NSInteger) tag {
	NSArray *items = [tabBar items];
	for (NSInteger i = 0; i < [items count]; ++i) {
		if([[items objectAtIndex:i] tag] == tag){
			tabBar.selectedItem = [items objectAtIndex:i];
			break;
		}
	}
}

- (void)hideTabBar {
	[UIView beginAnimations:nil context:NULL];
	tabBar.frame = CGRectMake(0.0, 460.0, tabBar.frame.size.width, tabBar.frame.size.height);
	[UIView commitAnimations];
}

- (void)showTabBar {
	[UIView beginAnimations:nil context:NULL];
	tabBar.frame = CGRectMake(0.0, 411.0, tabBar.frame.size.width, tabBar.frame.size.height);
	[UIView commitAnimations];
}

- (void)loadConfigData {
	mainViewController.configData = configData;
	[mainViewController loadConfigData];
}

- (void)loadMainViewController {
	MainViewController *viewController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	self.mainViewController = viewController;
	mainViewController.rootViewController = self;
	
	[viewController release];
}

- (void)loadFlipsideViewController {
	FlipsideViewController *viewController = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	self.flipsideViewController = viewController;
	flipsideViewController.configData = configData;
	[viewController release];
	
}

- (void)loadQueueViewController {
	QueueViewController *qvc = [[QueueViewController alloc] initWithNibName:@"QueueView" bundle:nil];
	self.queueViewController = qvc;
	qvc.rootViewController = self;
	[qvc release];
}

- (void)hideMainView {
	if(mainViewController != nil){
		[mainViewController viewWillDisappear:YES];
		[mainViewController.view removeFromSuperview];
		[mainViewController viewDidDisappear:YES];
	}
}

- (void)hideSettingsView {
	if(flipsideViewController != nil){
		[flipsideViewController viewWillDisappear:YES];
		[flipsideViewController.view removeFromSuperview];
		[flipsideViewController viewDidDisappear:YES];
	}
}

- (void)hideQueueView {
}

- (void)showMainView {
	if(mainViewController == nil){
		[self loadMainViewController];
	}

	[self hideSettingsView];
	[self hideQueueView];
	[mainViewController viewWillAppear:YES];
	[self.view insertSubview:mainViewController.view belowSubview:tabBar];
	[mainViewController viewDidAppear:YES];
	[self selectTabByTag:1];
}

- (void)showSettingsView {
	if (flipsideViewController == nil) {
		[self loadFlipsideViewController];
	}

	[self hideMainView];
	[self hideQueueView];
	[flipsideViewController viewWillAppear:YES];
	[self.view insertSubview:flipsideViewController.view belowSubview:tabBar];
	[flipsideViewController viewDidAppear:YES];
	[self selectTabByTag:0];
}

- (void)showQueueView {
	if(queueViewController == nil){
		[self loadQueueViewController];
	}
	
	[self hideMainView];
	[self hideSettingsView];
	[queueViewController viewWillAppear:YES];
	[self.view insertSubview:queueViewController.view belowSubview:tabBar];	
	[queueViewController viewDidAppear:YES];
	[self selectTabByTag:2];
}

- (void)updateQueueDisplay {
	NSInteger queue_size = [[[FreshbooksAPI sharedInstance] timeEntryQueue] size];
	if(queue_size > 0){
		queueViewButton.badgeValue = [NSString stringWithFormat:@"%i", queue_size];
	}
	else {	 
		queueViewButton.badgeValue = nil;
	}
}

- (void)handleQueueLengthChanged:(NSNotification *) notification {
	[self updateQueueDisplay];
}


- (IBAction)toggleView {	
	/*
	 This method is called when the info or Done button is pressed.
	 It flips the displayed view from the main view to the flipside view and vice-versa.
	 */
	if (flipsideViewController == nil) {
		[self loadFlipsideViewController];
	}
	
	UIView *mainView = mainViewController.view;
	UIView *flipsideView = flipsideViewController.view;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	[UIView setAnimationTransition:([mainView superview] ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft) forView:self.view cache:YES];
	
	if ([mainView superview] != nil) {
		[flipsideViewController viewWillAppear:YES];
		[mainViewController viewWillDisappear:YES];
		[mainView removeFromSuperview];
        [infoButton removeFromSuperview];
		[self.view addSubview:flipsideView];
		[self.view insertSubview:flipsideNavigationBar aboveSubview:flipsideView];
		[mainViewController viewDidDisappear:YES];
		[flipsideViewController viewDidAppear:YES];

	} else {
		[mainViewController viewWillAppear:YES];
		[flipsideViewController viewWillDisappear:YES];
		[flipsideView removeFromSuperview];
		[flipsideNavigationBar removeFromSuperview];
		[self.view addSubview:mainView];
//		[self.view insertSubview:infoButton aboveSubview:mainViewController.view];
		[flipsideViewController viewDidDisappear:YES];
		[mainViewController viewDidAppear:YES];
	}
	[UIView commitAnimations];
}

- (void)hideInfoButton {
	infoButton.hidden = YES;
}

- (void)showInfoButton {
	infoButton.hidden = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[infoButton release];
	[flipsideNavigationBar release];
	[mainViewController release];
	[flipsideViewController release];
	[super dealloc];
}


@end
