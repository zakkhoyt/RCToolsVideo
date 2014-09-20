//
//  VWWHUDView.m
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 9/19/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWHUDView.h"
#import "NSTimer+Blocks.h"
#import "VWWLocationController.h"
#import "VWWMotionMonitor.h"
#import "VWW.h"

@interface VWWHUDView (){
    // Location related
    UILabel *coordinateLabel;
    UILabel *topSpeedLabel;
    UILabel *distanceFromHomeLabel;
    UILabel *altitudeLabel;
    
    // Heading related
    UILabel *headingLabel;

    
    // Motion related
    UILabel *accelerometerCurrentLabel;
    UILabel *gyroscopeCurrentLabel;

    UILabel *accelerometerLimitsLabel;
    UILabel *gyroscopeLimitsLabel;

}

@end

@implementation VWWHUDView


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textColor = [UIColor whiteColor];
        self.labelColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        self.renderDropShadows = YES;
        self.textAlignment = NSTextAlignmentCenter;
        
        [[VWWLocationController sharedInstance] start];
        [[VWWMotionMonitor sharedInstance] startAll];
        
        [NSTimer scheduledTimerWithTimeInterval:0.2 block:^{
//            [self setNeedsDisplay];
            [self updateContent];
        } repeats:YES];
    }
    return self;
}

-(void)dealloc{
    [[VWWLocationController sharedInstance] stop];
    [[VWWMotionMonitor sharedInstance] stopDevice];
}

//- (void)drawRect:(CGRect)rect {
//
//}

-(UILabel*)labelWithFrame:(CGRect)frame{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    if(self.renderDropShadows){
        label.shadowColor = [UIColor blackColor];
        label.shadowOffset = CGSizeMake(-1, -1);
    }
    label.textAlignment = self.textAlignment;
    label.backgroundColor = self.labelColor;
    label.textColor = self.textColor;
    label.numberOfLines = 0;
    [self addSubview:label];
    
    return label;
   
}

-(void)updateContent{
    const CGFloat kHeight = 30.0;
    const CGFloat kGutter = 8.0;

    
    // *************************************** Coordinate *******************************************
    if([VWWUserDefaults renderCoordinates]){
        if(coordinateLabel == nil){
            CGRect frame = CGRectMake(0, self.bounds.size.height - 1*kHeight - 0*kGutter, self.bounds.size.width, kHeight);
            coordinateLabel = [self labelWithFrame:frame];
        }
        if([VWWLocationController sharedInstance].location){
            coordinateLabel.text = [NSString stringWithFormat:@"%f,%f",
                                    [VWWLocationController sharedInstance].location.coordinate.latitude,
                                    [VWWLocationController sharedInstance].location.coordinate.longitude];
        } else {
            coordinateLabel.text = @"n/a";
        }
    }

    
    // *************************************** Speed *******************************************
    if([VWWUserDefaults renderSpeed]){
        if(topSpeedLabel == nil){
            CGRect frame = CGRectMake(0, self.bounds.size.height - 2*kHeight - 1*kGutter, self.bounds.size.width, kHeight);
            topSpeedLabel = [self labelWithFrame:frame];
        }
        topSpeedLabel.text = [NSString stringWithFormat:@"Speed:%.f Max:%.f m/s",
                              [VWWLocationController sharedInstance].currentSpeed,
                              [VWWLocationController sharedInstance].maxSpeed];
    }
    
    
    // *************************************** Distance from home *******************************************
    if([VWWUserDefaults renderDistanceFromHome]){
    if(distanceFromHomeLabel == nil){
        CGRect frame = CGRectMake(0, self.bounds.size.height - 3*kHeight - 2*kGutter, self.bounds.size.width, kHeight);
        distanceFromHomeLabel = [self labelWithFrame:frame];
    }
    distanceFromHomeLabel.text = [NSString stringWithFormat:@"△ Home: %ldm",
                                  (long)[VWWLocationController sharedInstance].distanceFromHome];
    }
    
    

    // *************************************** Heading *******************************************
    if([VWWUserDefaults renderHeading]){
        if(headingLabel == nil){
            CGRect frame = CGRectMake(0, self.bounds.size.height - 4*kHeight - 3*kGutter, self.bounds.size.width, kHeight);
            headingLabel = [self labelWithFrame:frame];
        }
        if([VWWLocationController sharedInstance].heading){
            headingLabel.text = [NSString stringWithFormat:@"Heading: (T)%.2f (M)%.2f",
                                 [VWWLocationController sharedInstance].heading.trueHeading,
                                 [VWWLocationController sharedInstance].heading.magneticHeading];
        } else {
            headingLabel.text = @"n/a";
        }
    }
    
    // *************************************** Altitude *******************************************
    if([VWWUserDefaults renderAltitude]){
        if(altitudeLabel == nil){
            CGRect frame = CGRectMake(0, self.bounds.size.height - 5*kHeight - 4*kGutter, self.bounds.size.width, kHeight);
            altitudeLabel = [self labelWithFrame:frame];
        }
//        if([VWWLocationController sharedInstance].heading){
            altitudeLabel.text = [NSString stringWithFormat:@"Altitude: (A)%.0fm (R)%.0fm",
                                 [VWWLocationController sharedInstance].altitude,
                                 [VWWLocationController sharedInstance].relativeAltitude];
//        } else {
//            headingLabel.text = @"n/a";
//        }
    }
    

    // *************************************** Accelerometers *******************************************
    if([VWWUserDefaults renderAccelerometers]){
        if(accelerometerCurrentLabel == nil){
            CGRect frame = CGRectMake(0, 0, self.bounds.size.width, 1*kHeight);
            accelerometerCurrentLabel = [self labelWithFrame:frame];
        }
        if([VWWMotionMonitor sharedInstance].accelerometers){
            VWWSample *acc = [VWWMotionMonitor sharedInstance].accelerometers;
            accelerometerCurrentLabel.text = [NSString stringWithFormat:@"Acc x:%.2f y:%.2f z:%.2f",
                                              acc.x.value, acc.y.value, acc.z.value];
        } else {
            accelerometerCurrentLabel.text = @"n/a";
        }
    }
    
    // *************************************** Gyroscopes *******************************************
    if([VWWUserDefaults renderGyroscopes]){
        if(gyroscopeCurrentLabel == nil){
            CGRect frame = CGRectMake(0, 1*kHeight + 1*kGutter, self.bounds.size.width, 1*kHeight);
            gyroscopeCurrentLabel = [self labelWithFrame:frame];
        }
        
        if([VWWMotionMonitor sharedInstance].gyroscopeLimits){
            VWWSample *gyro = [VWWMotionMonitor sharedInstance].gyroscopes;
            gyroscopeCurrentLabel.text = [NSString stringWithFormat:@"Gyro.max x:%.2f y:%.2f z:%.2f",
                                          gyro.x.value, gyro.y.value, gyro.z.value];
        } else {
            gyroscopeCurrentLabel.text = @"n/a";
        }
    }
    
    // *************************************** Accelerometer limits *******************************************
    if([VWWUserDefaults renderAccelerometerLimits]){
        if(accelerometerLimitsLabel == nil){
            CGRect frame = CGRectMake(0, 2*kHeight + 2*kGutter, self.bounds.size.width, 2*kHeight);
            accelerometerLimitsLabel = [self labelWithFrame:frame];
        }
        if([VWWMotionMonitor sharedInstance].accelerometerLimits){
            VWWDeviceLimits *aLimits = [VWWMotionMonitor sharedInstance].accelerometerLimits;
            accelerometerLimitsLabel.text = [NSString stringWithFormat:@"Acc.max x:%.2f y:%.2f z:%.2f\n"
                                             @"Acc.min x:%.2f y:%.2f z:%.2f",
                                             aLimits.x.max, aLimits.y.max, aLimits.z.max,
                                             aLimits.x.min, aLimits.y.min, aLimits.z.min];
        } else {
            accelerometerLimitsLabel.text = @"n/a";
        }
    }

    // *************************************** Gyroscope limits *******************************************
    if([VWWUserDefaults renderGyroscopeLimits]){
        if(gyroscopeLimitsLabel == nil){
            CGRect frame = CGRectMake(0, 4*kHeight + 3*kGutter, self.bounds.size.width, 2*kHeight);
            gyroscopeLimitsLabel = [self labelWithFrame:frame];
        }
        
        if([VWWMotionMonitor sharedInstance].gyroscopeLimits){
            VWWDeviceLimits *aLimits = [VWWMotionMonitor sharedInstance].gyroscopeLimits;
            gyroscopeLimitsLabel.text = [NSString stringWithFormat:@"Gyro.max x:%.2f y:%.2f z:%.2f\n"
                                         @"Gyro.min x:%.2f y:%.2f z:%.2f",
                                         aLimits.x.max, aLimits.y.max, aLimits.z.max,
                                         aLimits.x.min, aLimits.y.min, aLimits.z.min];
        } else {
            gyroscopeLimitsLabel.text = @"n/a";
        }
    }
    
}

@end
