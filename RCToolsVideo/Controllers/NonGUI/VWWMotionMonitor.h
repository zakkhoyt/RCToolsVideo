//
//  APM Logger
//
//  Created by Zakk Hoyt 2014
//  Copyright (c) 2014 Zakk Hoyt.
//


#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import "VWWSample.h"

@class VWWMotionMonitor;

@protocol VWWMotionMonitorDelegate <NSObject>
@required

@optional
-(void)motionController:(VWWMotionMonitor*)sender didUpdateAcceleremeters:(VWWSample*)accelerometers;
-(void)motionController:(VWWMotionMonitor*)sender didUpdateGyroscopes:(VWWSample*)gyroscopes;
-(void)motionController:(VWWMotionMonitor*)sender didUpdateMagnetometers:(VWWSample*)magnetometers;
-(void)motionController:(VWWMotionMonitor*)sender didUpdateAttitude:(VWWSample*)attitude;

//-(void)motionController:(VWWMotionMonitor*)sender didUpdateAltimeter:(CMAltitudeData*)altimeter limits:(VWWDeviceLimits*)limits;
@end


@interface VWWMotionMonitor : NSObject
+(VWWMotionMonitor*)sharedInstance;
@property (nonatomic, weak) id <VWWMotionMonitorDelegate> delegate;
@property (nonatomic) NSTimeInterval updateInterval;

-(void)startAccelerometer;
-(void)stopAccelerometer;

//-(void)startAltimeter;
//-(void)stopAltimeter;


-(void)startGyroscope;
-(void)stopGyroscope;


-(void)startMagnetometer;
-(void)stopMagnetometer;


-(void)startAll;
-(void)stopAll;
@end
