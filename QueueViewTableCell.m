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
