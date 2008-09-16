//
//  EditNoteController.m
//  FreshbooksTimer
//
//  Created by Dave Grijalva on 8/14/08.
//  Copyright 2008 Dave Grijalva. All rights reserved.
//

#import "EditNoteController.h"


@implementation EditNoteController

@synthesize appState;

- (void) show {
	[super show];
	[textView becomeFirstResponder];
}

- (void) hide {
	[super hide];
	[textView resignFirstResponder];
	[appState setObject:textView.text forKey:@"note"];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"NoteHasChanged" object:nil];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self restoreNoteContentFromSavedState];
}

- (NSString *)note {
	return textView.text;
}

-(void) restoreNoteContentFromSavedState {
	if([appState valueForKey:@"note"]){
		textView.text = [appState valueForKey:@"note"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"NoteHasChanged" object:nil];
	}
}

- (IBAction) clearNoteButtonPressed:(id) sender {
	if(textView.text.length){
		UIActionSheet *sheet = [[[UIActionSheet alloc] initWithTitle:@"Are you sure you want to clear this text?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Clear" otherButtonTitles:nil] autorelease];
		[sheet showInView:self.view.window];
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(buttonIndex == 0){
		textView.text = @"";
	}
}

@end

