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

#import "MainViewController.h"
#import "MainView.h"
#import "TimePickerController.h"
#import "RootViewController.h"
#import "FreshbooksAPI.h"
#import "Timer.h"

@implementation MainViewController

@synthesize timer;
@synthesize rootViewController;
@synthesize configData;
@synthesize projectSelector;
@synthesize taskSelector;
@synthesize queueViewController;
@synthesize noteController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Custom initialization
		timer = [[Timer alloc] init];
		timer.delegate = self;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNoteChanged:) name:@"NoteHasChanged" object:nil];
	}
	return self;
}


// If you need to do additional setup after loading the view, override viewDidLoad.
 - (void)viewDidLoad {
	 // Style Button Shadows
	 timeButton.titleShadowOffset = CGSizeMake(0.0, -1.0);
	 startButton.titleShadowOffset = CGSizeMake(0.0, -1.0);
	 resetButton.titleShadowOffset = CGSizeMake(0.0, -1.0);
	 submitButton.titleShadowOffset = CGSizeMake(0.0, -1.0);
	 	 
	 // Setup Time Picker
	 timePickerController = [[TimePickerController alloc] initWithNibName:@"TimePicker" bundle:nil];
	 timePickerController.mainViewController = self;
	 timePickerController.timer = timer;
	 timePickerController.modalBackdrop = modalBackdrop;
	 [self.view insertSubview:timePickerController.view aboveSubview:modalBackdrop];
	 timePickerController.view.frame = CGRectMake(0.0, 460.0, timePickerController.view.frame.size.width, timePickerController.view.frame.size.height);
	 
	 // Setup Modal Backdrop
//	 modalBackdrop.hidden = YES;
	 modalBackdrop.alpha = 0.0;
	 modalBackdrop.frame = CGRectMake(0.0, 0.0, 320.0, 460.0);
	 
	 // Setup Project Selector
	 ProjectSelector *ps = [[ProjectSelector alloc] initWithNibName:@"ProjectSelector" bundle:nil];
	 self.projectSelector = ps;
	 projectSelector.mainViewController = self;
	 [ps release];
	 [self.view insertSubview:projectSelector.view aboveSubview:modalBackdrop];
	 projectSelector.projectTextLabel = projectTextLabel;
	 projectSelector.modalBackdrop = modalBackdrop;
	 
	 // Setup Task Selector
	 TaskSelector *ts = [[TaskSelector alloc] initWithNibName:@"TaskSelector" bundle:nil];
	 self.taskSelector = ts;
	 taskSelector.mainViewController = self;
	 [ts release];
	 [self.view insertSubview:taskSelector.view aboveSubview:modalBackdrop];
	 taskSelector.taskTextLabel = taskTextLabel;
	 taskSelector.modalBackdrop = modalBackdrop;
	 
//	 if([[[FreshbooksAPI sharedInstance] timeEntryQueue] size] > 0){
//		 [self updateQueueDisplay];
//	 }
 }

- (void) loadConfigData {
	// restore timer
	NSMutableDictionary *state = [configData valueForKey:@"state"];
	NSNumber *sec = [state valueForKey:@"seconds_elapsed"];
	NSDate *date = [[state valueForKey:@"start_date"] retain];

//	NSLog(@"date: %@", date);
	
	if(sec){
		timer.seconds_elapsed = [sec integerValue];
		[self timerDidUpdate:timer];
	}
	if(date){
		[timer startAt: date];
		[date release];
		[startButton setTitle:@"Pause"];
	}
	
	// restore project 
	NSString *pid = [configData valueForKeyPath:@"state.selectedProject"];
	if(pid){
		[projectSelector setSelectedProjectById:pid];
	}
	
	
	// restore task
	NSString *tid = [configData valueForKeyPath:@"state.selectedTask"];
	if(tid){
		[taskSelector setSelectedTaskById:tid];
	}
	
	// restore note text
	notesTextLabel.text = [configData valueForKeyPath:@"state.note"];

}

- (BOOL) validateDataExists {
	if([[[FreshbooksAPI sharedInstance] projectData] count] > 0){
		return YES;
	}
	else{
		[rootViewController showSettingsView];
		[[[[UIAlertView alloc] initWithTitle:@"Project Data is not Loaded" message:@"Please update your authentication information." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] autorelease] show];
		return NO;
	}
}

- (IBAction)showSettings:(id)sender {
	[rootViewController toggleView];
}

- (IBAction)resetButtonClicked:(id)sender {
	resetSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to reset the timer?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Reset" otherButtonTitles:nil];
	[resetSheet showInView:[rootViewController view]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(actionSheet == resetSheet && buttonIndex == 0){
		// reset timer
		[self stopTimer];
		timer.seconds_elapsed = 0;
		[self timerDidUpdate:timer];
		
		[actionSheet release];
		resetSheet = nil;
	}
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet {
	if(actionSheet == resetSheet){
		[actionSheet release];
		resetSheet = nil;
	}
}

- (IBAction)startButtonClicked:(UIButton *)sender {
	if(timer.running){
		[self stopTimer];
	}
	else{
		[self startTimer];
	}
}

- (void)startTimer {
	[timer start];
	[startButton setTitle:@"Pause"];
}

- (void)stopTimer {
	[timer stop];
	[startButton setTitle:@"Start"];
}

- (IBAction)timeButtonClicked:(UIButton *)sender{
	[timePickerController open];
}

- (IBAction)timeDoneButtonClicked:(id)sender{
	[timePickerController close];
}


- (IBAction) submitButtonClicked:(id)sender {
	NSString *err;
	
	if([self validateDataExists]){
		[self stopTimer];
		if([[[FreshbooksAPI sharedInstance] timeEntryQueue] submitTime:timer.seconds_elapsed  project:projectSelector.selectedProject task:taskSelector.selectedTask note:noteController.note error:&err]){
			// reset timer
			timer.seconds_elapsed = 0;
			[self timerDidUpdate:timer];
			// reset notes
			[configData setValue:@"" forKeyPath:@"state.note"];
			notesTextLabel.text = @"";
			[noteController restoreNoteContentFromSavedState];
		}
		else{
			[[[[UIAlertView alloc] initWithTitle:@"Error Saving Time Entry" message:err delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] autorelease] show];
		}
	}
}

- (IBAction)addNoteButtonClicked:(id)sender {
	if(!self.noteController){
		EditNoteController *nc = [[EditNoteController alloc] initWithNibName:@"EditNoteView" bundle:nil];
		self.noteController = nc;
		nc.appState = [configData valueForKey:@"state"];
		[nc restoreNoteContentFromSavedState];
		[nc release];
		[self.view insertSubview:self.noteController.view belowSubview:modalBackdrop];
	}
	
	[self.noteController show];
}

- (void)handleNoteChanged:(NSNotification *) notification {
	notesTextLabel.text = [configData valueForKeyPath:@"state.note"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)timerDidUpdate:(Timer *)atimer {
	NSString *title = [NSString stringWithFormat:@"%@:%@:%@", [timer stringHours], [timer stringMinutes], [timer stringSeconds]];
	[timeButton setTitle:title];
	
	//save state to plist
	[configData setValue:[NSNumber numberWithInteger: timer.seconds_elapsed] forKeyPath:@"state.seconds_elapsed"];
//	NSLog(@"setting start_date %@", timer.start_date);
	[configData setValue:timer.start_date forKeyPath:@"state.start_date"];
	
	if([timer currentElapsedSeconds] + timer.seconds_elapsed){
		resetButton.enabled = YES;
		submitButton.enabled = YES;
	}
	else{
		resetButton.enabled = NO;
		submitButton.enabled = NO;
	}
	
	// disabled edit if timer is over 24 hours
	if([timer currentElapsedSeconds] + timer.seconds_elapsed >= 86400){
		timeButton.enabled = NO;
		editTimeIcon.image = [UIImage imageNamed:@"icon_edit_disabled.png"];
	}
	else{
		timeButton.enabled = YES;
		editTimeIcon.image = [UIImage imageNamed:@"icon_edit.png"];
	}
}

- (IBAction)projectButtonClicked:(id)sender {
	if([[[FreshbooksAPI sharedInstance] projectData] count] > 0){
		[projectSelector show];
	}
	else if([configData valueForKeyPath:@"authentication.isValid"]){
		[rootViewController showSettingsView];
		[[[[UIAlertView alloc] initWithTitle:@"No Projects Exist" message:@"Please create a project, then tap Refresh Data." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] autorelease] show];
	}
	else{
		[rootViewController showSettingsView];
		[[[[UIAlertView alloc] initWithTitle:@"Project Data is not Loaded" message:@"Please update your authentication information." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] autorelease] show];
	}
	[self restoreTextForButton:sender];
}

- (IBAction)taskButtonClicked:(id)sender {
	if(projectSelector.selectedProject){
		[taskSelector show];
	}
}


- (void)selectedProjectDidUpdate:(NSMutableDictionary *)selectedProject {
	projectTextLabel.text = [selectedProject valueForKey:@"name"];
	[configData setValue:[selectedProject valueForKey:@"id"] forKeyPath:@"state.selectedProject"];
}

- (void)selectedTaskDidUpdate:(NSMutableDictionary *)selectedTask {
	taskTextLabel.text = [selectedTask valueForKey:@"name"];
	[configData setValue:[selectedTask valueForKey:@"id"] forKeyPath:@"state.selectedTask"];
}

- (IBAction)projectButtonTouchDown:(UIButton *)sender {
	[self highlightTextForButton:sender];
}

- (IBAction)projectButtonTouchCancel:(UIButton *)sender {
	[self restoreTextForButton:sender];
}


- (void) highlightLabel:(UILabel *)label {
	label.textColor = [UIColor whiteColor];
	label.shadowColor = [UIColor blackColor];
	label.shadowOffset = CGSizeMake(-1.0, -1.0);
}

- (void) restoreLabel:(UILabel *)label {
	label.textColor = [UIColor blackColor];
	label.shadowColor = [UIColor whiteColor];
	label.shadowOffset = CGSizeMake(1.0, 1.0);
}

- (void) highlightTextForButton:(UIButton *)button {
	if(button == projectButton){
		[self highlightLabel:projectLabel];
		[self highlightLabel:projectTextLabel];
	}
	if(button == taskButton){
		[self highlightLabel:taskLabel];
		[self highlightLabel:taskTextLabel];
	}
	if(button == noteButton){
		[self highlightLabel:notesLabel];
		[self highlightLabel:notesTextLabel];
	}
}

- (void) restoreTextForButton:(UIButton *)button {
	if(button == projectButton){
		[self restoreLabel:projectLabel];
		[self restoreLabel:projectTextLabel];
	}
	if(button == taskButton){
		[self restoreLabel:taskLabel];
		[self restoreLabel:taskTextLabel];
	}
	if(button == noteButton){
		[self restoreLabel:notesLabel];
		[self restoreLabel:notesTextLabel];
	}
}


- (void)dealloc {
	[super dealloc];
}


@end

@implementation UIButton (simple)

- (void) setTitle:(NSString *)new_title {
	[self setTitle:new_title	forState: UIControlStateNormal];
	[self setTitle:new_title	forState: UIControlStateDisabled];
	[self setTitle:new_title	forState: UIControlStateHighlighted];
	[self setTitle:new_title	forState: UIControlStateSelected];
}

- (void) setImage:(UIImage *)new_image {
	[self setImage:new_image	forState: UIControlStateNormal];
	[self setImage:new_image	forState: UIControlStateDisabled];
	[self setImage:new_image	forState: UIControlStateHighlighted];
	[self setImage:new_image	forState: UIControlStateSelected];
}

@end

