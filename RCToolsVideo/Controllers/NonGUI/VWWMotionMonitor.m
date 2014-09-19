//
//  APM Logger
//
//  Created by Zakk Hoyt 2014
//  Copyright (c) 2014 Zakk Hoyt.
//
//  http://www-users.cs.york.ac.uk/~fisher/mkfilter/trad.html

#import "VWWMotionMonitor.h"
#import "VWW.h"

@interface VWWMotionMonitor ()
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic) NSTimeInterval updateInterval;

@property (nonatomic) BOOL accelerometerRunning;
@property (nonatomic) BOOL magnetometerRunning;
@property (nonatomic) BOOL gyrosRunning;
@property (nonatomic) BOOL deviceRunning;

@end


@implementation VWWMotionMonitor
#pragma mark Public methods

+(VWWMotionMonitor*)sharedInstance{
    static VWWMotionMonitor *instance;
    if(instance == nil){
        instance = [[VWWMotionMonitor alloc]init];
    }
    return instance;
}

-(id)init{
    self = [super init];
    if(self){
        [self initializeClass];
    }
    return self;
}


-(void)setUpdateInterval:(NSTimeInterval)updateInterval{
    _updateInterval = updateInterval;
    if(self.accelerometerRunning){
        self.motionManager.accelerometerUpdateInterval = self.updateInterval;
    }
    
    if(self.gyrosRunning){
        self.motionManager.gyroUpdateInterval = self.updateInterval;
    }
    
    if(self.magnetometerRunning){
        self.motionManager.magnetometerUpdateInterval = self.updateInterval;
    }
    
    if(self.deviceRunning){
        self.motionManager.deviceMotionUpdateInterval = self.updateInterval;
    }
    if(self.deviceRunning){
        self.motionManager.deviceMotionUpdateInterval = self.updateInterval;
    }
    
}

#pragma mark Private methods

-(void)initializeClass{
    self.motionManager = [[CMMotionManager alloc]init];
    self.updateInterval = 1/30.0f;
    
    self.accelerometerLimits = [[VWWDeviceLimits alloc]init];
    self.gyroscopeLimits = [[VWWDeviceLimits alloc]init];
    self.magnetometerLimits = [[VWWDeviceLimits alloc]init];
}



#pragma mark Public methods
-(void)startAll{
    [self startAccelerometer];
    [self startGyroscope];
    [self startMagnetometer];
    [self startDevice];
}
-(void)stopAll{
    [self stopAccelerometer];
    [self stopGyroscope];
    [self stopMagnetometer];
    [self stopDevice];
}
-(void)resetStats{
    @synchronized(self.accelerometerLimits){
        self.accelerometerLimits = [[VWWDeviceLimits alloc]init];
    }
    @synchronized(self.gyroscopeLimits){
        self.gyroscopeLimits = [[VWWDeviceLimits alloc]init];
    }
    @synchronized(self.magnetometerLimits){
        self.magnetometerLimits = [[VWWDeviceLimits alloc]init];
    }
}

#pragma mark Accelerometers
-(void)startAccelerometer{
    if(self.accelerometerRunning == YES) return;
    self.motionManager.accelerometerUpdateInterval = self.updateInterval;
    NSOperationQueue* accelerometerQueue = [[NSOperationQueue alloc] init];
    [self.motionManager startAccelerometerUpdatesToQueue:accelerometerQueue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        @synchronized(self.accelerometerLimits){
            self.accelerometers = [accelerometerData copy];
            self.accelerometerLimits.x.max = MAX(self.accelerometerLimits.x.max, accelerometerData.acceleration.x);
            self.accelerometerLimits.x.min = MIN(self.accelerometerLimits.x.min, accelerometerData.acceleration.x);
            self.accelerometerLimits.y.max = MAX(self.accelerometerLimits.y.max, accelerometerData.acceleration.y);
            self.accelerometerLimits.y.min = MIN(self.accelerometerLimits.y.min, accelerometerData.acceleration.y);
            self.accelerometerLimits.z.max = MAX(self.accelerometerLimits.z.max, accelerometerData.acceleration.z);
            self.accelerometerLimits.z.min = MIN(self.accelerometerLimits.z.min, accelerometerData.acceleration.z);
        }
    }];
    self.accelerometerRunning = YES;
    VWW_LOG_DEBUG(@"Started Accelerometer");
}


-(void)stopAccelerometer{
    if(self.accelerometerRunning == NO) return;
    
    [self.motionManager stopAccelerometerUpdates];
    self.accelerometerRunning = NO;
    VWW_LOG_DEBUG(@"Stopped Accelerometer");
}


#pragma mark Gyroscopes

-(void)startGyroscope{
    if(self.gyrosRunning == YES) return;
    self.motionManager.gyroUpdateInterval = self.updateInterval;
    NSOperationQueue* gyroQueue = [[NSOperationQueue alloc] init];
    [self.motionManager startGyroUpdatesToQueue:gyroQueue withHandler:^(CMGyroData *gyroData, NSError *error) {
        @synchronized(self.gyroscopeLimits){
            self.gyroscopes = [gyroData copy];
            self.gyroscopeLimits.x.max = MAX(self.gyroscopeLimits.x.max, gyroData.rotationRate.x);
            self.gyroscopeLimits.x.min = MIN(self.gyroscopeLimits.x.min, gyroData.rotationRate.x);
            self.gyroscopeLimits.y.max = MAX(self.gyroscopeLimits.y.max, gyroData.rotationRate.y);
            self.gyroscopeLimits.y.min = MIN(self.gyroscopeLimits.y.min, gyroData.rotationRate.y);
            self.gyroscopeLimits.z.max = MAX(self.gyroscopeLimits.z.max, gyroData.rotationRate.z);
            self.gyroscopeLimits.z.min = MIN(self.gyroscopeLimits.z.min, gyroData.rotationRate.z);
        }
    }];
    self.gyrosRunning = YES;
    VWW_LOG_DEBUG(@"Started Gyros");
    
}
-(void)stopGyroscope{
    if(self.gyrosRunning == NO) return;
    
    [self.motionManager stopGyroUpdates];
    self.gyrosRunning = NO;
    VWW_LOG_DEBUG(@"Stopped Gyros");
}


#pragma mark Magnetometers


-(void)startMagnetometer{
    if(self.magnetometerRunning == YES) return;
    self.motionManager.magnetometerUpdateInterval = self.updateInterval;
    NSOperationQueue* magnetometerQueue = [[NSOperationQueue alloc] init];
    [self.motionManager startMagnetometerUpdatesToQueue:magnetometerQueue withHandler:^(CMMagnetometerData *magnetometerData, NSError *error) {
        @synchronized(self.magnetometerLimits){
            self.magnetometers = [magnetometerData copy];
            self.magnetometerLimits.x.max = MAX(self.magnetometerLimits.x.max, magnetometerData.magneticField.x);
            self.magnetometerLimits.x.min = MIN(self.magnetometerLimits.x.min, magnetometerData.magneticField.x);
            self.magnetometerLimits.y.max = MAX(self.magnetometerLimits.y.max, magnetometerData.magneticField.y);
            self.magnetometerLimits.y.min = MIN(self.magnetometerLimits.y.min, magnetometerData.magneticField.y);
            self.magnetometerLimits.z.max = MAX(self.magnetometerLimits.z.max, magnetometerData.magneticField.z);
            self.magnetometerLimits.z.min = MIN(self.magnetometerLimits.z.min, magnetometerData.magneticField.z);
        }
    }];
    
    self.magnetometerRunning = YES;
    VWW_LOG_DEBUG(@"Started Magnetometer");
    
}
-(void)stopMagnetometer{
    if(self.magnetometerRunning == NO) return;
    
    [self.motionManager stopMagnetometerUpdates];
    self.magnetometerRunning = NO;
    VWW_LOG_DEBUG(@"Stopped Magnetometer");
}


#pragma mark Attitude
-(void)startDevice{
    if(self.deviceRunning == YES) return;
    self.motionManager.deviceMotionUpdateInterval = self.updateInterval;
    NSOperationQueue* deviceQueue = [[NSOperationQueue alloc] init];
    [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:self.motionManager.attitudeReferenceFrame toQueue:deviceQueue withHandler:^(CMDeviceMotion *motion, NSError *error) {
        self.device = [motion copy];
    }];
//    [self.motionManager startDeviceMotionUpdatesToQueue:deviceQueue withHandler:^(CMDeviceMotion *motion, NSError *error) {
//            self.device = [motion copy];
//    }];
    self.deviceRunning = YES;
    VWW_LOG_DEBUG(@"Started device motion");
    
}
-(void)stopDevice{
    if(self.deviceRunning == NO) return;
    
    [self.motionManager stopDeviceMotionUpdates];
    self.deviceRunning = NO;
    VWW_LOG_DEBUG(@"Stopped device motion");
}


@end
