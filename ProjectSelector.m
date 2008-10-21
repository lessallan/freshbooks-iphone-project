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
