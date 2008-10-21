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

