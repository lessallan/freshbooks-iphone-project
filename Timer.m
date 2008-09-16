//
//  Timer.m
//  FreshbooksTimer
//
//  Created by Dave Grijalva on 7/18/08.
//  Copyright 2008 Dave Grijalva. All rights reserved.
//

#import "Timer.h"


@implementation Timer
@synthesize delegate;
@synthesize running;
@synthesize seconds_elapsed;
@synthesize start_date;

-(id) init {
	self = [super init];
	running = FALSE;
	seconds_elapsed = 0;
	return self;
}

-(void) start {
	[self startAt:[NSDate date]];
}

-(void) startAt:(NSDate *)s_date {
	self.start_date = s_date;
	update_interval = [[NSTimer timerWithTimeInterval:(NSTimeInterval)0.5 target:self selector:NSSelectorFromString(@"handleUpdateInterval:") userInfo:nil repeats:YES] retain];
	[[NSRunLoop mainRunLoop] addTimer:update_interval forMode:NSDefaultRunLoopMode];
	running = TRUE;
	[delegate timerDidUpdate:self];
}

-(void) stop {
	seconds_elapsed += [self currentElapsedSeconds];

	self.start_date = nil;
	
	[update_interval invalidate];
	[update_interval release];
	update_interval = nil;
	
	[delegate timerDidUpdate:self];
	running = FALSE;
}

-(NSInteger) currentElapsedSeconds {
	if(start_date != nil){
		return [[NSNumber numberWithDouble:[start_date timeIntervalSinceNow]] integerValue] * -1;
	} else {
		return 0;
	}
}

-(void) handleUpdateInterval:(NSTimer *)update_interval {
	[delegate timerDidUpdate:self];
}

-(NSInteger) hours {
	return (seconds_elapsed + [self currentElapsedSeconds]) / 3600;
}

-(NSInteger) minutes {
	return ((seconds_elapsed + [self currentElapsedSeconds]) / 60) % 60;
}

-(NSInteger) seconds {
	return (seconds_elapsed + [self currentElapsedSeconds]) % 60;
}

-(void) setHours:(NSInteger)new_hours{
	seconds_elapsed = seconds_elapsed - ([self hours] * 3600) + (new_hours * 3600);
	[delegate timerDidUpdate:self];
}

-(void) setMinutes:(NSInteger)new_minutes{
	seconds_elapsed = seconds_elapsed - ([self minutes] * 60) + (new_minutes * 60);
	[delegate timerDidUpdate:self];
}

-(void) setSeconds:(NSInteger)new_seconds{
	seconds_elapsed = seconds_elapsed - [self seconds] + new_seconds;
	[delegate timerDidUpdate:self];
}

-(void) setByTimeInterval:(NSTimeInterval)interval {
	self.seconds_elapsed = [[NSNumber numberWithDouble:interval] integerValue];
	[delegate timerDidUpdate:self];
}

-(NSString *) stringHours{
	return [NSString stringWithFormat:@"%i",[self hours]];
}

-(NSString *) stringMinutes{
	return [self paddedIntString:[self minutes] toLength:2];
}

-(NSString *) stringSeconds{
	return [self paddedIntString:[self seconds] toLength:2];
}

-(NSString *) paddedIntString:(NSInteger)value toLength:(NSInteger)length {
	NSString *output;
	output = [NSString stringWithFormat:@"%i", value];
	while([output length] < length){
		output = [@"0" stringByAppendingString:output];
	}
	
	return output;
}

@end
