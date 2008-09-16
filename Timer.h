//
//  Timer.h
//  FreshbooksTimer
//
//  Created by Dave Grijalva on 7/18/08.
//  Copyright 2008 Dave Grijalva. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Timer : NSObject {
	id delegate;
	bool running;
	NSInteger seconds_elapsed;
	NSDate *start_date;
	NSTimer *update_interval;
}
@property (nonatomic, retain) id delegate;
@property (nonatomic) bool running;
@property (nonatomic, assign) NSInteger seconds_elapsed;
@property (nonatomic, retain) NSDate *start_date;

-(NSInteger) hours;
-(NSInteger) minutes;
-(NSInteger) seconds;

-(void) setHours:(NSInteger)new_hours;
-(void) setMinutes:(NSInteger)new_minutes;
-(void) setSeconds:(NSInteger)new_seconds;

-(void) setByTimeInterval:(NSTimeInterval)interval;

-(NSString *) stringHours;
-(NSString *) stringMinutes;
-(NSString *) stringSeconds;

-(NSString *) paddedIntString:(NSInteger)value toLength:(NSInteger)length;

-(NSInteger) currentElapsedSeconds;
-(void) handleUpdateInterval:(NSTimer *)update_interval;
	

-(void) stop;
-(void) start;
-(void) startAt:(NSDate *)s_date;

@end

@protocol TimerDelgate

-(void) timerDidUpdate:(Timer *)timer;

@end

