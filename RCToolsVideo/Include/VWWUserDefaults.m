//
//  VWWUserDefaults.m
//  Synthesizer
//
//  Created by Zakk Hoyt on 2/17/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWUserDefaults.h"

static NSString *VWWUserDefaultsHUDKey = @"hud";
static NSString *VWWUserDefaultsResolutionKey = @"resolution";

static NSString *VWWUserDefaultsAccelerometersKey = @"accelerometers";
static NSString *VWWUserDefaultsGyroscopesKey = @"gyroscopes";
static NSString *VWWUserDefaultsAccelerometerLimitsKey = @"accelerometerLimits";
static NSString *VWWUserDefaultsGyroscopeLimitsKey = @"gyroscopeLimits";
static NSString *VWWUserDefaultsHeadingKey = @"heading";
static NSString *VWWUserDefaultsAltitudeKey = @"altitude";
static NSString *VWWUserDefaultsDistanceFromHomeKey = @"distanceFromHome";
static NSString *VWWUserDefaultsSpeedKey = @"speed";
static NSString *VWWUserDefaultsCoordinatesKey = @"coordinates";
static NSString *VWWUserDefaultsDateKey = @"VWWUserDefaultsDateKey";
static NSString *VWWUserDefaultsDropShadowKey = @"dropShadow";
static NSString *VWWUserDefaultsCompassIndicatorKey = @"compassIndicator";
static NSString *VWWUserDefaultsAttitudeIndicatorKey = @"attitudeIndicator";
static NSString *VWWUserDefaultsTextColorKey = @"textColor";
static NSString *VWWUserDefaultsLabelColorKey = @"labelColor";
static NSString *VWWUserDefaultsVersionKey = @"version";
@implementation VWWUserDefaults


// Acc
+(BOOL)renderAccelerometers{
    return [[NSUserDefaults standardUserDefaults] boolForKey:VWWUserDefaultsAccelerometersKey];
}
+(void)setRenderAccelerometers:(BOOL)renderAccelerometers{
    [[NSUserDefaults standardUserDefaults] setBool:renderAccelerometers forKey:VWWUserDefaultsAccelerometersKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// Gyro
+(BOOL)renderGyroscopes{
    return [[NSUserDefaults standardUserDefaults] boolForKey:VWWUserDefaultsGyroscopesKey];
}
+(void)setRenderGyroscopes:(BOOL)renderGyroscopes{
    [[NSUserDefaults standardUserDefaults] setBool:renderGyroscopes forKey:VWWUserDefaultsGyroscopesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


// AccMax
+(BOOL)renderAccelerometerLimits{
    return [[NSUserDefaults standardUserDefaults] boolForKey:VWWUserDefaultsAccelerometerLimitsKey];
}
+(void)setRenderAccelerometerLimits:(BOOL)renderAccelerometerLimits{
    [[NSUserDefaults standardUserDefaults] setBool:renderAccelerometerLimits forKey:VWWUserDefaultsAccelerometerLimitsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


// GyroMax
+(BOOL)renderGyroscopeLimits{
    return [[NSUserDefaults standardUserDefaults] boolForKey:VWWUserDefaultsGyroscopeLimitsKey];
}
+(void)setRenderGyroscopeLimits:(BOOL)renderGyroscopeLimits{
    [[NSUserDefaults standardUserDefaults] setBool:renderGyroscopeLimits forKey:VWWUserDefaultsGyroscopeLimitsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



// Heading
+(BOOL)renderHeading{
    return [[NSUserDefaults standardUserDefaults] boolForKey:VWWUserDefaultsHeadingKey];
}
+(void)setRenderHeading:(BOOL)renderHeading{
    [[NSUserDefaults standardUserDefaults] setBool:renderHeading forKey:VWWUserDefaultsHeadingKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// Altitude
+(BOOL)renderAltitude{
    return [[NSUserDefaults standardUserDefaults] boolForKey:VWWUserDefaultsAltitudeKey];
}
+(void)setRenderAltitude:(BOOL)renderAltitude{
    [[NSUserDefaults standardUserDefaults] setBool:renderAltitude forKey:VWWUserDefaultsAltitudeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



// DistanceFromHome
+(BOOL)renderDistanceFromHome{
    return [[NSUserDefaults standardUserDefaults] boolForKey:VWWUserDefaultsDistanceFromHomeKey];
}
+(void)setRenderDistanceFromHome:(BOOL)renderDistanceFromHome{
    [[NSUserDefaults standardUserDefaults] setBool:renderDistanceFromHome forKey:VWWUserDefaultsDistanceFromHomeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


// Speed
+(BOOL)renderSpeed{
    BOOL r = [[NSUserDefaults standardUserDefaults] boolForKey:VWWUserDefaultsSpeedKey];;
    return r;
//    return [[NSUserDefaults standardUserDefaults] boolForKey:VWWUserDefaultsSpeedKey];
}
+(void)setRenderSpeed:(BOOL)renderSpeed{
    [[NSUserDefaults standardUserDefaults] setBool:renderSpeed forKey:VWWUserDefaultsSpeedKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


// Coordinates
+(BOOL)renderCoordinates{
    return [[NSUserDefaults standardUserDefaults] boolForKey:VWWUserDefaultsCoordinatesKey];
}
+(void)setRenderCoordinates:(BOOL)renderCoordinates{
    [[NSUserDefaults standardUserDefaults] setBool:renderCoordinates forKey:VWWUserDefaultsCoordinatesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// date
+(BOOL)renderDate{
    return [[NSUserDefaults standardUserDefaults] boolForKey:VWWUserDefaultsDateKey];
}
+(void)setRenderDate:(BOOL)renderDate{
    [[NSUserDefaults standardUserDefaults] setBool:renderDate forKey:VWWUserDefaultsDateKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


// DropShadow
+(BOOL)renderDropShadow{
    return [[NSUserDefaults standardUserDefaults] boolForKey:VWWUserDefaultsDropShadowKey];
}
+(void)setRenderDropShadow:(BOOL)renderDropShadow{
    [[NSUserDefaults standardUserDefaults] setBool:renderDropShadow forKey:VWWUserDefaultsDropShadowKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


// Compass Indiciator
+(BOOL)renderCompassIndicator{
    return [[NSUserDefaults standardUserDefaults] boolForKey:VWWUserDefaultsCompassIndicatorKey];
}
+(void)setRenderCompassIndicator:(BOOL)renderCompassIndicator{
    [[NSUserDefaults standardUserDefaults] setBool:renderCompassIndicator forKey:VWWUserDefaultsCompassIndicatorKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// Attitude Indicator
+(BOOL)renderAttitudeIndicator{
    return [[NSUserDefaults standardUserDefaults] boolForKey:VWWUserDefaultsAttitudeIndicatorKey];
}
+(void)setRenderAttitudeIndicator:(BOOL)renderAttitudeIndicator{
    [[NSUserDefaults standardUserDefaults] setBool:renderAttitudeIndicator forKey:VWWUserDefaultsAttitudeIndicatorKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


// TextColor
+(UIColor*)textColor{
    return [[NSUserDefaults standardUserDefaults] objectForKey:VWWUserDefaultsTextColorKey];
}
+(void)setTextColor:(UIColor*)textColor{
    [[NSUserDefaults standardUserDefaults] setObject:textColor forKey:VWWUserDefaultsTextColorKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


// LabelColor
+(UIColor*)labelColor{
    return [[NSUserDefaults standardUserDefaults] objectForKey:VWWUserDefaultsLabelColorKey];
}
+(void)setLabelColor:(UIColor*)labelColor{
    [[NSUserDefaults standardUserDefaults] setObject:labelColor forKey:VWWUserDefaultsLabelColorKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


// Version
+(NSString*)version{
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:VWWUserDefaultsVersionKey];
    if(version == nil) version = @"";
    return version;
}
+(void)setVersion:(NSString*)version{
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:VWWUserDefaultsVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



+(NSUInteger)hud{
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:VWWUserDefaultsHUDKey];
    if(number == nil){
        return 0;
    }
    return number.unsignedIntegerValue;
}
+(void)setHUD:(NSUInteger)hud{
    [[NSUserDefaults standardUserDefaults] setObject:@(hud) forKey:VWWUserDefaultsHUDKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(NSUInteger)resolution{
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:VWWUserDefaultsResolutionKey];
    if(number == nil){
        return 0;
    }
    return number.unsignedIntegerValue;
}
+(void)setResolution:(NSUInteger)resolution{
    [[NSUserDefaults standardUserDefaults] setObject:@(resolution) forKey:VWWUserDefaultsResolutionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
