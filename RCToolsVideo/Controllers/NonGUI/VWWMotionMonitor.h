//
//  APM Logger
//
//  Created by Zakk Hoyt 2014
//  Copyright (c) 2014 Zakk Hoyt.
//


#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import "VWWDeviceLimits.h"

@interface VWWMotionMonitor : NSObject
+(VWWMotionMonitor*)sharedInstance;

-(void)startAll;
-(void)stopAll;
-(void)resetStats;

-(void)startAccelerometer;
-(void)stopAccelerometer;
@property (nonatomic, strong) VWWDeviceLimits *accelerometerLimits;
@property (nonatomic, strong) CMAccelerometerData *accelerometers;

-(void)startGyroscope;
-(void)stopGyroscope;
@property (nonatomic, strong) VWWDeviceLimits *gyroscopeLimits;
@property (nonatomic, strong) CMGyroData *gyroscopes;

-(void)startMagnetometer;
-(void)stopMagnetometer;
@property (nonatomic, strong) VWWDeviceLimits *magnetometerLimits;
@property (nonatomic, strong) CMMagnetometerData *magnetometers;

-(void)startDevice;
-(void)stopDevice;
@property (nonatomic, strong) CMDeviceMotion *device;
@end
