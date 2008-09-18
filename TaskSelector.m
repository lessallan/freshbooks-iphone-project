//
//  TaskSelector.m
//  FreshbooksTimer
//
//  Created by Dave Grijalva on 7/28/08.
//  Copyright 2008 Dave Grijalva. All rights reserved.
//

#import "TaskSelector.h"
#import "FreshbooksAPI.h"
#import "MainViewController.h"
#import "ProjectSelector.h"


@implementation TaskSelector

@synthesize mainViewController;
@synthesize taskTextLabel;
@synthesize modalBackdrop;
@synthesize selectedTask;
@synthesize selectedProject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		//hidden to start
		self.view.frame = CGRectMake(0.0, 460.0, self.view.frame.size.width, self.view.frame.size.height);
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(projectDataChanged:) name:@"ProjectDataChanged" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedProjectChanged:) name:@"SelectedProjectChanged" object:nil];
	}
	return self;
}

- (void)viewDidLoad {
	taskPicker.delegate = self;
	taskPicker.dataSource = self;
}


- (void)projectDataChanged:(NSNotification *) notification {
	//update view and revalidate
	[taskPicker reloadAllComponents];
	[self verifySelectedTask];
}

- (void)selectedProjectChanged:(NSNotification *) notification {
	self.selectedProject = [notification.object selectedProject];
	[taskPicker reloadAllComponents];
	[self verifySelectedTask];
}

- (void) verifySelectedTask {
	// Make sure selected task still exists
	if(self.selectedTask){
		if(self.selectedProject){
			NSMutableArray *tasks = [self.selectedProject valueForKey:@"tasks"];
			BOOL taskStillExists = NO;
			for (NSInteger i = 0; i < [tasks count]; ++i) {
				if([[self.selectedTask valueForKey:@"id"] compare: [[tasks objectAtIndex:i] valueForKey:@"id"]] == NSOrderedSame){
					//NSLog(@"task found: %@, %@",[self.selectedTask valueForKey:@"id"], [[tasks objectAtIndex:i] valueForKey:@"id"]);
					taskStillExists = YES;
					[self setSelectedTaskByIndex:i];
				}
			}
			
			if(!taskStillExists){
				//NSLog(@"task not found.  clearing: %@",[self.selectedTask valueForKey:@"id"]);
				[self clearSelectedTask];
			}
		}
		else {
			// no selected project.  clear task
			[self clearSelectedTask];
		}
	}
}

- (void) show {
	[UIButton beginAnimations:nil context:nil];
	self.view.frame = CGRectMake(0.0, 200.0, self.view.frame.size.width, self.view.frame.size.height);
	modalBackdrop.alpha = 0.5;
	[UIButton commitAnimations];
	[mainViewController.rootViewController hideTabBar];
}

- (IBAction) doneButtonClicked:(id)sender {
	[self setSelectedTaskByIndex:[taskPicker selectedRowInComponent:0]];
	[self hide];
}

- (void)hide {
	[UIButton beginAnimations:nil context:nil];
	self.view.frame = CGRectMake(0.0, 460.0, self.view.frame.size.width, self.view.frame.size.height);
	modalBackdrop.alpha = 0.0;
	[UIButton commitAnimations];
	[mainViewController.rootViewController showTabBar];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if([[self.selectedProject valueForKey:@"tasks"] count]){
		return [[self.selectedProject valueForKey:@"tasks"] count];
	}
	else{
		return 1;
	}
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	if([[self.selectedProject valueForKey:@"tasks"] count]){
		return [[[self.selectedProject valueForKey:@"tasks"] objectAtIndex:row] valueForKey:@"name"];
	}
	else{
		return @"This project has no tasks.";
	}
}

- (void)clearSelectedTask {
	self.selectedTask = nil;
	[mainViewController selectedTaskDidUpdate:selectedTask];
}

- (void)setSelectedTaskByIndex:(NSInteger)row {
	if([[self.selectedProject valueForKey:@"tasks"] count] > 0){
		self.selectedTask = [[self.selectedProject valueForKey:@"tasks"] objectAtIndex:row];
		[mainViewController selectedTaskDidUpdate:selectedTask];
		[taskPicker selectRow:row inComponent:0 animated:NO];
	}
	else {
		[mainViewController.rootViewController showSettingsView];
		[[[[UIAlertView alloc] initWithTitle:@"Project Has No Tasks" message:@"Please enable tasks for this project, then tap Refresh Data." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] autorelease] show];
		[self hide];
	}
}

- (void)setSelectedTaskById:(NSString *)tid {
	[tid retain];
	NSMutableArray *td = [self.selectedProject valueForKey:@"tasks"];
	for(NSInteger i = 0; i < [td count]; ++i){
		NSString *indexId = [[td objectAtIndex:i] valueForKey:@"id"];
		if([indexId caseInsensitiveCompare: tid] == NSOrderedSame){
			[self setSelectedTaskByIndex:i];
		}
	}
	[tid release];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	[self setSelectedTaskByIndex:row];
}



@end
