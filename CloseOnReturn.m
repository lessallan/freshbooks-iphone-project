//
//  CloseOnReturn.m
//  FreshbooksTimer
//
//  Created by Dave Grijalva on 7/21/08.
//  Copyright 2008 Dave Grijalva. All rights reserved.
//

#import "CloseOnReturn.h"


@implementation CloseOnReturn

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}

@end
