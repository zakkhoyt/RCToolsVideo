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
@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeLabel;
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
//@property (nonatomic) CGFloat maxAltitude;
//@property (nonatomic) CGFloat maxSpeed;;
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
    [view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([obj isKindOfClass:[UILabel class]]){
            UILabel *label = obj;
            label.textColor = [UIColor whiteColor];
            label.shadowColor = [UIColor blackColor];
            label.shadowOffset = CGSizeMake(-2, -2);
            
        } else if([obj isKindOfClass:[UIView class]]){
            UIView *view = obj;
            view.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.2];
        }
        
        UIView *view = obj;
        [self customizeView:view];
    }];
    
}

-(void)commonInit{
    self.backgroundColor = [UIColor clearColor];
    
    // Only show what the user wants to see
    self.coordinateView.hidden = ![VWWUserDefaults renderCoordinates];
    self.headingView.hidden = ![VWWUserDefaults renderHeading];
    self.speedView.hidden = ![VWWUserDefaults renderSpeed];
    self.homeView.hidden = ![VWWUserDefaults renderDistanceFromHome];
    self.altitudeView.hidden = ![VWWUserDefaults renderAltitude];
    self.dateView.hidden = ![VWWUserDefaults renderDate];
    self.watermarkView.hidden = NO;
    self.attitudeView.hidden = ![VWWUserDefaults renderAttitudeIndicator];
    self.forcesView.hidden = ![VWWUserDefaults renderAccelerometers];
    
    
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
    // Calculate before rendering
    self.maxForce = MAX(self.maxForce, self.currentMotion.userAcceleration.x);
    self.maxForce = MAX(self.maxForce, self.currentMotion.userAcceleration.y);
    self.maxForce = MAX(self.maxForce, self.currentMotion.userAcceleration.z);
    
    
    
    if(self.currentAltitude == nil){
        self.altitudeLabel.text = @"n/a";
    } else {
        self.altitudeLabel.text = [NSString stringWithFormat:@"%.2fm (AGL)", self.currentAltitude.floatValue];
    }
    
    
    if(self.currentHeading == nil){
        self.headingLabel.text = @"n/a";
    } else {
        self.headingLabel.text = [NSString stringWithFormat:@"Heading: %.2f +/-%lu",
                                  self.currentHeading.magneticHeading,
                                  (unsigned long)self.currentHeading.headingAccuracy];
    }
    
    if(self.currentLocation == nil){
        self.coordinateLabel.text = @"n/a";
        self.speedLabel.text = @"n/a";
        self.homeLabel.text = @"n/a";
    } else {
        self.coordinateLabel.text = [NSString stringWithFormat:@"%.5f,%.5f +/- %lum",
                                     self.currentLocation.coordinate.latitude,
                                     self.currentLocation.coordinate.longitude,
                                     (unsigned long)self.currentLocation.horizontalAccuracy];
        self.speedLabel.text = [NSString stringWithFormat:@"Speed: %.2fmps", self.currentLocation.speed];
        self.homeLabel.text = [NSString stringWithFormat:@"Home: %.2fm", [self.currentLocation distanceFromLocation:self.baseLocation]];
    }
    
    
    self.dateLabel.text = [NSDate date].description;
    
    self.watermarkLabel.text = @"RCToolsVideo by VaporWarewolf";
    
    // For Right landscape, pitch and roll are reversed disregarding sign
    self.attitudeLabel.text = [NSString stringWithFormat:@"r:%.1f\n"
                               @"p:%.1f\n"
                               @"y:%.1f\n"
                               @"(radians)",
                               self.currentMotion.attitude.roll,
                               self.currentMotion.attitude.pitch,
                               self.currentMotion.attitude.yaw];
    
    self.forcesLabel.text = [NSString stringWithFormat:@"Max Force: %.2fg", self.maxForce];
}


-(void)setImageBlock:(VWWHUDViewImageBlock)imageBlock{
    _imageBlock = imageBlock;
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