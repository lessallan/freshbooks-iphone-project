//
//  ProjectSelector.m
//  FreshbooksTimer
//
//  Created by Dave Grijalva on 7/24/08.
//  Copyright 2008 Dave Grijalva. All rights reserved.
//

#import "ProjectSelector.h"
#import "FreshbooksAPI.h"
#import "MainViewController.h"
#import "RootViewController.h"

@implementation ProjectSelector

@synthesize mainViewController;
@synthesize projectTextLabel;
@synthesize modalBackdrop;
@synthesize selectedProject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		//hidden to start
		self.view.frame = CGRectMake(0.0, 460.0, self.view.frame.size.width, self.view.frame.size.height);
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(projectDataChanged:) name:@"ProjectDataChanged" object:nil];
	}
	return self;
}

 - (void)viewDidLoad {
	 projectPicker.delegate = self;
	 projectPicker.dataSource = self;
 }

- (void)projectDataChanged:(NSNotification *)notification {
	[projectPicker reloadAllComponents];
	[self validateSelectedProject];
}

- (void)validateSelectedProject {
	if(self.selectedProject){
		NSMutableArray *projectData = [[FreshbooksAPI sharedInstance] projectData];
		BOOL projectStillExists = NO;
		for (NSInteger i = 0; i < [projectData count]; ++i) {
			if([[self.selectedProject valueForKey:@"id"] compare: [[projectData objectAtIndex:i] valueForKey:@"id"]] == NSOrderedSame){
//				NSLog(@"project found at index %i", i);
				projectStillExists = YES;
				[self setSelectedProjectByIndex:i];
			}
		}
		
		if(!projectStillExists){
//			NSLog(@"project not found.  clearing");
			[self clearSelectedProject];
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
	[self setSelectedProjectByIndex:[projectPicker selectedRowInComponent:0]];
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
	return [[[FreshbooksAPI sharedInstance] projectData] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [[[[FreshbooksAPI sharedInstance] projectData] objectAtIndex:row] valueForKey:@"name"];
}

- (void)setSelectedProjectByIndex:(NSInteger)row {
	self.selectedProject = [[[FreshbooksAPI sharedInstance] projectData] objectAtIndex:row];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"SelectedProjectChanged" object:self];
	[mainViewController selectedProjectDidUpdate:selectedProject];
	[projectPicker selectRow:row inComponent:0 animated:NO];
}

- (void)setSelectedProjectById: (NSString *)pid {
	[pid retain];
	NSMutableArray *pd = [[FreshbooksAPI sharedInstance] projectData];
	for(NSInteger i = 0; i < [pd count]; ++i){
		NSString *indexId = [[pd objectAtIndex:i] valueForKey:@"id"];
		if([indexId caseInsensitiveCompare: pid] == NSOrderedSame){
			[self setSelectedProjectByIndex:i];
		}
	}
	[pid release];
}

- (void) clearSelectedProject {
	self.selectedProject = nil;
	[mainViewController selectedProjectDidUpdate:selectedProject];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"SelectedProjectChanged" object:self];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	[self setSelectedProjectByIndex:row];
}

@end
