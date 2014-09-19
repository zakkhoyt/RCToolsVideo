//
//  APM Logger
//
//  Created by Zakk Hoyt 2014
//  Copyright (c) 2014 Zakk Hoyt.
//
//  http://www-users.cs.york.ac.uk/~fisher/mkfilter/trad.html

#import "VWWMotionMonitor.h"
#import "VWW.h"

const NSUInteger kFilterSampleCount = 32;

@interface VWWMotionMonitor ()
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic) BOOL accelerometerRunning;
@property (nonatomic) BOOL magnetometerRunning;
@property (nonatomic) BOOL gyrosRunning;
@property (nonatomic) BOOL deviceRunning;


@property (nonatomic) BOOL altimeterRunning;
@property (nonatomic, strong) CMAltimeter *altimeterManager;


@property (nonatomic, strong) NSMutableArray *accelerometersHistory;
@property (nonatomic, strong) NSMutableArray *gyroscopesHistory;
@property (nonatomic, strong) NSMutableArray *magnetometersHistory;
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

+(BOOL)serviceExists{
    VWW_LOG_TODO;
    return YES;
    
}

-(void)startAll{
    [self startAccelerometer];
    [self startGyroscope];
    [self startMagnetometer];
    [self startDevice];
    //    [self startAltimeter];
    
}
-(void)stopAll{
    [self stopAccelerometer];
    [self stopGyroscope];
    [self stopMagnetometer];
    [self stopDevice];
    //    [self stopAltimeter];
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
    
}

#pragma mark Private methods

-(void)initializeClass{
    self.motionManager = [[CMMotionManager alloc]init];
    self.updateInterval = 1/30.0f;
    
    self.altimeterManager = [[CMAltimeter alloc]init];
    
    
    self.accelerometersHistory = [@[]mutableCopy];
    self.gyroscopesHistory = [@[]mutableCopy];
    self.magnetometersHistory = [@[]mutableCopy];
    for(NSUInteger index = 0; index < kFilterSampleCount; index++){
        VWWSample *sample = [[VWWSample alloc]init];
        [self.accelerometersHistory addObject:sample];
        [self.gyroscopesHistory addObject:sample];
        [self.magnetometersHistory addObject:sample];
    }
    
    VWW_LOG_TRACE;
}


#pragma mark Accelerometers
-(void)startAccelerometer{
    if(self.accelerometerRunning == YES) return;
    
    self.motionManager.accelerometerUpdateInterval = self.updateInterval;
    
    NSOperationQueue* accelerometerQueue = [[NSOperationQueue alloc] init];
    
    [self.motionManager startAccelerometerUpdatesToQueue:accelerometerQueue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        @synchronized(self.accelerometersHistory){
            // Subtract the average of the last kFilterSampleCount samples
            float xTotal = 0, yTotal = 0, zTotal = 0;
            for(NSUInteger index = 0; index < kFilterSampleCount; index++){
                VWWSample *sample = self.accelerometersHistory[index];
                xTotal += sample.x.value;
                yTotal += sample.y.value;
                zTotal += sample.z.value;
            }
            
            float xHPF = xTotal / (float)kFilterSampleCount;
            float yHPF = yTotal / (float)kFilterSampleCount;
            float zHPF = zTotal / (float)kFilterSampleCount;
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(motionController:didUpdateAcceleremeters:)]){
                
                VWWSample *currentSample = [[VWWSample alloc]init];
                currentSample.x.value = accelerometerData.acceleration.x;
                currentSample.y.value = accelerometerData.acceleration.y;
                currentSample.z.value = accelerometerData.acceleration.z;
                currentSample.x.hpf = xHPF;
                currentSample.y.hpf = yHPF;
                currentSample.z.hpf = zHPF;
                
                [self.delegate motionController:self didUpdateAcceleremeters:currentSample];
                
                // Add this sample to the history
                [self.accelerometersHistory addObject:currentSample];
                [self.accelerometersHistory removeObjectAtIndex:0];
            }
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
        @synchronized(self.gyroscopesHistory){
            // Subtract the average of the last kFilterSampleCount samples
            float xTotal = 0, yTotal = 0, zTotal = 0;
            for(NSUInteger index = 0; index < kFilterSampleCount; index++){
                VWWSample *sample = self.gyroscopesHistory[index];
                xTotal += sample.x.value;
                yTotal += sample.y.value;
                zTotal += sample.z.value;
            }
            
            float xHPF = xTotal / (float)kFilterSampleCount;
            float yHPF = yTotal / (float)kFilterSampleCount;
            float zHPF = zTotal / (float)kFilterSampleCount;
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(motionController:didUpdateGyroscopes:)]){
                
                VWWSample *currentSample = [[VWWSample alloc]init];
                currentSample.x.value = gyroData.rotationRate.x;
                currentSample.y.value = gyroData.rotationRate.y;
                currentSample.z.value = gyroData.rotationRate.z;
                currentSample.x.hpf = xHPF;
                currentSample.y.hpf = yHPF;
                currentSample.z.hpf = zHPF;
                
                [self.delegate motionController:self didUpdateGyroscopes:currentSample];
                
                // Add this sample to the history
                [self.gyroscopesHistory addObject:currentSample];
                [self.gyroscopesHistory removeObjectAtIndex:0];
            }
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
        @synchronized(self.magnetometersHistory){
            // Subtract the average of the last kFilterSampleCount samples
            float xTotal = 0, yTotal = 0, zTotal = 0;
            for(NSUInteger index = 0; index < kFilterSampleCount; index++){
                VWWSample *sample = self.magnetometersHistory[index];
                xTotal += sample.x.value;
                yTotal += sample.y.value;
                zTotal += sample.z.value;
            }
            
            float xHPF = xTotal / (float)kFilterSampleCount;
            float yHPF = yTotal / (float)kFilterSampleCount;
            float zHPF = zTotal / (float)kFilterSampleCount;
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(motionController:didUpdateMagnetometers:)]){
                
                VWWSample *currentSample = [[VWWSample alloc]init];
                currentSample.x.value = magnetometerData.magneticField.x;
                currentSample.y.value = magnetometerData.magneticField.y;
                currentSample.z.value = magnetometerData.magneticField.z;
                currentSample.x.hpf = xHPF;
                currentSample.y.hpf = yHPF;
                currentSample.z.hpf = zHPF;
                
                [self.delegate motionController:self didUpdateMagnetometers:currentSample];
                
                // Add this sample to the history
                [self.magnetometersHistory addObject:currentSample];
                [self.magnetometersHistory removeObjectAtIndex:0];
            }
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
    
    CMDeviceMotionHandler deviceHandler = ^(CMDeviceMotion *motion, NSError *error) {
        
        //        float xHPF = 0;
        //        float yHPF = 0;
        //        float zHPF = 0;
        
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(motionController:didUpdateAttitude:)]){
            //        VWWSampleAxis *x = [[VWWSampleAxis alloc]init];
            //        x.value = magnetometerData.magneticField.x;
            //        x.hpf = xHPF;
            //
            //        VWWSampleAxis *y = [[VWWSampleAxis alloc]init];
            //        y.value = magnetometerData.magneticField.y;
            //        y.hpf = yHPF;
            //
            //        VWWSampleAxis *z = [[VWWSampleAxis alloc]init];
            //        z.value = magnetometerData.magneticField.z;
            //        z.hpf = zHPF;
            //
            //        VWWSample *sample = [[VWWSample alloc]initWithX:x Y:y Z:z];
            VWWSample *sample = [[VWWSample alloc]init];
            
            [self.delegate motionController:self didUpdateAttitude:sample];
        }
    };
    
    [self.motionManager startDeviceMotionUpdatesToQueue:deviceQueue withHandler:deviceHandler];
    self.deviceRunning = YES;
    VWW_LOG_DEBUG(@"Started device motion");
    
}
-(void)stopDevice{
    if(self.deviceRunning == NO) return;
    
    [self.motionManager stopDeviceMotionUpdates];
    self.deviceRunning = NO;
    VWW_LOG_DEBUG(@"Stopped device motion");
}


#pragma mark Altimeter
//-(void)startAltimeter{
//    if(self.altimeterRunning == YES) return;
//
//    NSOperationQueue* altimeterQueue = [[NSOperationQueue alloc] init];
//    [self.altimeterManager startRelativeAltitudeUpdatesToQueue:altimeterQueue withHandler:^(CMAltitudeData *altimeterData, NSError *error) {
//
//
//
//        if(self.delegate && [self.delegate respondsToSelector:@selector(motionController:didUpdateAltimeter:limits:)]){
//            [self.delegate motionController:self didUpdateAltimeter:altimeterData limits:self.altimeterLimits];
//        }
//    }];
//    self.altimeterRunning = YES;
//    VWW_LOG_DEBUG(@"Started Altimeter");
//}
//
//-(void)stopAltimeter{
//    if(self.altimeterRunning == NO) return;
//
//    [self.altimeterManager stopRelativeAltitudeUpdates];
//    self.altimeterRunning = NO;
//    VWW_LOG_DEBUG(@"Stopped Altimeter");
//}

@end
