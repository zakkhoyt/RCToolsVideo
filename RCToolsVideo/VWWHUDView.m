//
//  VWWHUDView.m
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 5/31/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//
// Exampel image here: http://hobbywireless.com/images/STORM%20OSD%20kit_01.jpg

//accelerometers        current|max
//gyros                 current|max
//heading               true | magnetic
//altitude              agl | asl
//distance from home    meters | feet
//speed                 current|max
//coordinates           current

// HUD type
//accelerometers        graph
//gyros                 graph
//heading               graph
//compass indicator     arrow
//attitude indicator    graphics


#import "VWWHUDView.h"
#import "VWW.h"
#import "NSTimer+Blocks.h"
#import "UIView+RenderToImage.h"


#import "VWWHUDCoordinateView.h"
#import "VWWHUDHeadingView.h"
#import "VWWHUDSpeedView.h"
#import "VWWHUDHomeView.h"
#import "VWWHUDAltitudeView.h"
#import "VWWHUDDateView.h"
#import "VWWHUDWatermarkView.h"
#import "VWWHUDAttitudeView.h"
#import "VWWHUDForcesView.h"


@import CoreMotion;
@import CoreLocation;



/*-------------------------------------------------------------------------
 * Given two lat/lon points on earth, calculates the heading
 * from lat1/lon1 to lat2/lon2.
 *
 * lat/lon params in radians
 * result in radians
 *-------------------------------------------------------------------------*/

@interface VWWHUDView () <CLLocationManagerDelegate>

// Callback block
@property (nonatomic, strong) VWWHUDViewImageBlock imageBlock;

// UI
@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet VWWHUDCoordinateView *coordinateView;
@property (weak, nonatomic) IBOutlet VWWHUDHeadingView *headingView;
@property (weak, nonatomic) IBOutlet VWWHUDSpeedView *speedView;
@property (weak, nonatomic) IBOutlet VWWHUDHomeView *homeView;
@property (weak, nonatomic) IBOutlet VWWHUDAltitudeView *altitudeView;
@property (weak, nonatomic) IBOutlet VWWHUDDateView *dateView;
@property (weak, nonatomic) IBOutlet VWWHUDWatermarkView *watermarkView;
@property (weak, nonatomic) IBOutlet VWWHUDAttitudeView *attitudeView;
@property (weak, nonatomic) IBOutlet VWWHUDForcesView *forcesView;

@property (weak, nonatomic) IBOutlet UILabel *coordinateLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *altitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *watermarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *attitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *forcesLabel;

// Sensors
@property (nonatomic, strong) CMAltimeter *altimeter;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) CLLocationManager *locationManager;

// Variables for the sensors

@property (nonatomic, strong) NSNumber *currentAltitude;
@property (nonatomic, strong) CMDeviceMotion *currentMotion;
@property (nonatomic, strong) CLHeading *currentHeading;
@property (nonatomic, strong) CLLocation *currentLocation;

@property (nonatomic, strong) NSNumber *baseAltitude;
@property (nonatomic, strong) CMDeviceMotion *baseMotion;
@property (nonatomic, strong) CLHeading *baseHeading;
@property (nonatomic, strong) CLLocation *baseLocation;

@property (nonatomic) CGFloat maxForce;
@property (nonatomic) CGFloat maxAltitudeASL;
@property (nonatomic) CGFloat maxAltitudeAGL;
@property (nonatomic) CGFloat maxSpeed;
@end


@interface VWWHUDView (CoreMotion)
-(void)startAltimeter;
-(void)stopAltimeter;
-(void)setupCoreMotion;
-(void)startDeviceMotion;
-(void)stopDeviceMotion;
@end
@interface VWWHUDView (CoreLocation)
-(void)setupCoreLocation;
-(void)startHeading;
-(void)stopHeading;
-(void)startLocations;
-(void)stopLocations;
@end


@implementation VWWHUDView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self customizeView:self];
}

-(void)customizeView:(UIView*)view{
    self.backgroundColor = [UIColor clearColor];
    
    // Clear UI
    self.coordinateLabel.text = nil;
    self.speedLabel.text = nil;
    self.altitudeLabel.text = nil;
    self.dateLabel.text = nil;
    self.watermarkLabel.text = nil;
    self.attitudeLabel.text = nil;
    self.forcesLabel.text = nil;
    
    
    // Only show what the user wants to see
    self.coordinateView.hidden = !(BOOL)[VWWUserDefaults renderCoordinates];
    self.headingView.hidden = !(BOOL)[VWWUserDefaults renderHeading];
    self.speedView.hidden = !(BOOL)[VWWUserDefaults renderSpeed];
    self.homeView.hidden = !(BOOL)[VWWUserDefaults renderDistanceFromHome];
    self.altitudeView.hidden = !(BOOL)[VWWUserDefaults renderAltitude];
    self.dateView.hidden = !(BOOL)[VWWUserDefaults renderDate];
    self.watermarkView.hidden = NO;
    self.attitudeView.hidden = !(BOOL)[VWWUserDefaults renderAttitudeIndicator];
    self.forcesView.hidden = !(BOOL)[VWWUserDefaults renderAccelerometers];

    
    [view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([obj isKindOfClass:[UILabel class]]){
            UILabel *label = obj;
            label.font = [UIFont boldSystemFontOfSize:label.font.pointSize];
            label.textColor = [UIColor whiteColor];
            label.shadowColor = [UIColor blackColor];
            label.shadowOffset = CGSizeMake(1, 1);
            
        } else if([obj isKindOfClass:[UIView class]]){
            UIView *view = obj;
#if defined(DEBUG)
            view.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.2];
#else
            view.backgroundColor = [UIColor clearColor];
#endif
            
        }
        
        UIView *view = obj;
        [self customizeView:view];
    }];
    
}

-(void)commonInit{
    
    
    [self startSensors];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.25 block:^{
        [self update];
        
        if(_imageBlock){
            UIImage *image = [self imageRepresentation];
            _imageBlock(image);
        }
    } repeats:YES];

}

-(void)dealloc{
    [self.timer invalidate];
    _timer = nil;
    [self stopSensors];
    
}



-(void)startSensors{
    
    // Core Motino
    if([CMAltimeter isRelativeAltitudeAvailable]){
        [self startAltimeter];
    }
    
    [self setupCoreMotion];
    [self startDeviceMotion];
    
    
    // Core location
    [self setupCoreLocation];
    
    if([CLLocationManager headingAvailable]){
        [self startHeading];
    }
    
    if([CLLocationManager locationServicesEnabled]){
        [self startLocations];
    }
}

-(void)stopSensors{
    [self stopAltimeter];
    [self stopDeviceMotion];
    [self stopHeading];
    [self stopLocations];
}


-(void)update{
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    
    // Calculate before rendering
    self.maxForce = MAX(self.maxForce, self.currentMotion.userAcceleration.x);
    self.maxForce = MAX(self.maxForce, self.currentMotion.userAcceleration.y);
    self.maxForce = MAX(self.maxForce, self.currentMotion.userAcceleration.z);
    
    self.maxSpeed = MAX(self.maxSpeed, self.currentLocation.speed);
    
    self.maxAltitudeAGL = MAX(self.maxAltitudeAGL, self.currentAltitude.floatValue);
    self.maxAltitudeASL = MAX(self.maxAltitudeASL, self.currentLocation.altitude);
    
    
    
    NSMutableString *altitude = [NSMutableString new];
    if(self.currentAltitude == nil){
        [altitude appendString:@"n/a (AGL)"];
        
    } else {
        [altitude appendFormat:@"%.2fm (AGL)", self.currentAltitude.floatValue];
    }
    
    
    NSMutableString *speed = [NSMutableString new];
    if(self.currentLocation == nil){
        self.coordinateLabel.text = @"n/a";
        [speed appendString:@"n/a"];;
        [altitude appendFormat:@"\nn/a (ASL)"];
    } else {
        self.coordinateLabel.text = [NSString stringWithFormat:@"%.5f,%.5f +/- %lum",
                                     self.currentLocation.coordinate.latitude,
                                     self.currentLocation.coordinate.longitude,
                                     (unsigned long)self.currentLocation.horizontalAccuracy];
        [speed appendFormat:@"Speed: %.2fmps", self.currentLocation.speed];
        [speed appendFormat:@"\nMax: %.2fmps", self.maxSpeed];
        
        self.homeView.homeLocation = self.baseLocation;
        self.homeView.currentLocation = self.currentLocation;
        
        
        
        [altitude appendFormat:@"\n%.2fm (ASL)\n+/-%lum",
         self.currentLocation.altitude,
         (unsigned long)self.currentLocation.verticalAccuracy];
    }
    self.speedLabel.text = speed;
    self.altitudeLabel.text = altitude;
    
    // TODO: Use date formatter
    NSString *date = [NSDate date].description;
    self.dateLabel.text = [date stringByReplacingOccurrencesOfString:@"+0000" withString:@""];
    
    self.watermarkLabel.text = @"RCToolsVideo by VaporWarewolf";
    
    
    
    // For Right landscape, pitch and roll are reversed disregarding sign
    
    float roll = 0;
    float pitch = 0;
    float yaw = 0;
    if(deviceOrientation == UIDeviceOrientationLandscapeRight){
        pitch = self.currentMotion.attitude.roll - self.baseMotion.attitude.roll;
        if(pitch > M_PI){
            pitch -= 2*M_PI;
        }
        if(pitch < -M_PI){
            pitch += 2*M_PI;
        }
        roll = self.currentMotion.attitude.pitch - self.baseMotion.attitude.pitch;
        roll *= -1;
        yaw = self.currentMotion.attitude.yaw - self.baseMotion.attitude.yaw;
        yaw *= -1;
    } else {
        pitch = self.currentMotion.attitude.roll - self.baseMotion.attitude.roll;
        pitch *= -1;
        if(pitch > M_PI){
            pitch -= 2*M_PI;
        }
        if(pitch < -M_PI){
            pitch += 2*M_PI;
        }
        roll = self.currentMotion.attitude.pitch - self.baseMotion.attitude.pitch;
        yaw = -self.currentMotion.attitude.yaw - self.baseMotion.attitude.yaw;
    }

    
    
    
    self.attitudeLabel.text = [NSString stringWithFormat:@"Roll:%.2f\n"
                               @"Pitch:%.2f\n"
                               @"Yaw:%.2f\n"
                               @"(radians)",
                               roll, pitch, yaw];
    
    self.forcesLabel.text = [NSString stringWithFormat:@"Max Force: %.2fg", self.maxForce];
}



-(void)setImageBlock:(VWWHUDViewImageBlock)imageBlock{
    _imageBlock = imageBlock;
}

-(void)calibrate{
    self.maxAltitudeAGL = 0;
    self.maxAltitudeASL = 0;
    self.maxForce = 0;
    self.maxSpeed = 0;
    
    self.baseAltitude = nil;
    self.baseHeading = nil;
    self.baseLocation = nil;
    self.baseMotion = nil;
    
    [self update];
}
@end

@implementation VWWHUDView (CoreLocation)

-(void)setupCoreLocation{
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    [_locationManager requestWhenInUseAuthorization];
    
}
-(void)startHeading{
    [self.locationManager startUpdatingHeading];
}

-(void)stopHeading{
    [self.locationManager stopUpdatingHeading];
}

-(void)stopLocations{
    [self.locationManager stopUpdatingLocation];
}

-(void)startLocations{
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager startUpdatingLocation];
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading{
    self.currentHeading = [newHeading copy];
    self.headingView.heading = [newHeading copy];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    if(locations.count){
        CLLocation *location = [locations firstObject];
        if(self.baseLocation == nil){
            self.baseLocation = [location copy];
        } else {
            self.currentLocation = [location copy];
        }
    }
}
@end


@implementation VWWHUDView (CoreMotion)

-(void)setupCoreMotion{
    self.motionManager = [[CMMotionManager alloc]init];
    self.motionManager.showsDeviceMovementDisplay = YES;
}
-(void)startAltimeter{
    self.altimeter = [[CMAltimeter alloc]init];
    [self.altimeter startRelativeAltitudeUpdatesToQueue:[NSOperationQueue new] withHandler:^(CMAltitudeData *altitudeData, NSError *error) {
        if(self.baseAltitude == nil){
            self.baseAltitude = [altitudeData.relativeAltitude copy];
        } else {
            self.currentAltitude = [altitudeData.relativeAltitude copy];
        }
    }];
}

-(void)stopAltimeter{
    [self.altimeter stopRelativeAltitudeUpdates];
}

-(void)startDeviceMotion{
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue new] withHandler:^(CMDeviceMotion *motion, NSError *error) {
        if(self.baseMotion == nil){
            self.baseMotion = [motion copy];
        }
        self.currentMotion = [motion copy];
    }];
}
-(void)stopDeviceMotion{
    [self.motionManager stopDeviceMotionUpdates];
}


@end