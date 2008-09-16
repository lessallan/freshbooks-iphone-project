//
//  QueueViewTableCell.m
//  FreshbooksTimer
//
//  Created by Dave Grijalva on 8/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "QueueViewTableCell.h"


@implementation QueueViewTableCell

@synthesize entry;
@synthesize tableController;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleQueueLengthChanged:) name:@"Queue Length Changed" object:nil];
	}
	return self;
}

- (void) update {
	projectLabel.text = [entry valueForKeyPath:@"project.name"];
	taskLabel.text = [entry valueForKeyPath:@"task.name"];
	notesLabel.text = [entry valueForKeyPath:@"note"];
	CGSize size = [notesLabel.text sizeWithFont:notesLabel.font constrainedToSize:notesLabel.frame.size lineBreakMode:notesLabel.lineBreakMode];
	notesLabel.frame = CGRectMake(notesLabel.frame.origin.x, notesLabel.frame.origin.y, notesLabel.frame.size.width, size.height);
	
	if(entry != nil){
		timeLabel.text = [NSString stringWithFormat:@"%02i:%02i", ([[entry valueForKey:@"seconds"] integerValue] / 3600), ([[entry valueForKey:@"seconds"] integerValue] / 60) % 60];
		timeLabel.hidden = NO;
		deleteButton.hidden = NO;
	}
	else{
		timeLabel.hidden = YES;
		deleteButton.hidden = YES;
	}

	if([entry valueForKey:@"isInvalid"]){
		invalidIcon.hidden = NO;
	}
	else{
		invalidIcon.hidden = YES;
	}
}

- (void)handleQueueLengthChanged:(NSNotification *) notification {
	if([entry valueForKey:@"isInvalid"]){
		invalidIcon.hidden = NO;
	}
	else{
		invalidIcon.hidden = YES;
	}
}

- (IBAction) deleteButtonPressed: (id)sender {
	[tableController deleteButtonClickedFor:entry];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

	[super setSelected:selected animated:animated];

	// Configure the view for the selected state
}


- (void)dealloc {
	[super dealloc];
}


@end
