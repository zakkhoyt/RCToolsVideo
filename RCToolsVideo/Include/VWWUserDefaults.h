//
//  VWWUserDefaults.h
//  Synthesizer
//
//  Created by Zakk Hoyt on 2/17/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface VWWUserDefaults : NSObject


+(NSUInteger)hud;
+(void)setHUD:(NSUInteger)hud;

+(NSUInteger)resolution;
+(void)setResolution:(NSUInteger)resolution;


#pragma mark HUD
// Acc
+(BOOL)renderAccelerometers;
+(void)setRenderAccelerometers:(BOOL)renderAccelerometers;

// Gyro
+(BOOL)renderGyroscopes;
+(void)setRenderGyroscopes:(BOOL)renderGyroscopes;

// AccMax
+(BOOL)renderAccelerometerLimits;
+(void)setRenderAccelerometerLimits:(BOOL)renderAccelerometerLimits;

// GyroMax
+(BOOL)renderGyroscopeLimits;
+(void)setRenderGyroscopeLimits:(BOOL)renderGyroscopeLimits;

// Heading
+(BOOL)renderHeading;
+(void)setRenderHeading:(BOOL)renderHeading;

// Altitude
+(BOOL)renderAltitude;
+(void)setRenderAltitude:(BOOL)renderAltitude;


// DistanceFromHome
+(BOOL)renderDistanceFromHome;
+(void)setRenderDistanceFromHome:(BOOL)renderDistanceFromHome;

// Speed
+(BOOL)renderSpeed;
+(void)setRenderSpeed:(BOOL)renderSpeed;

// Coordinates
+(BOOL)renderCoordinates;
+(void)setRenderCoordinates:(BOOL)renderCoordinates;

// DropShadow
+(BOOL)renderDropShadow;
+(void)setRenderDropShadow:(BOOL)renderDropShadow;

// Compass Indiciator
+(BOOL)renderCompassIndicator;
+(void)setRenderCompassIndicator:(BOOL)renderCompassIndicator;

// Attitude Indicator
+(BOOL)renderAttitudeIndicator;
+(void)setRenderAttitudeIndicator:(BOOL)renderAttitudeIndicator;



// TextColor
+(UIColor*)textColor;
+(void)setTextColor:(UIColor*)textColor;

// LabelColor
+(UIColor*)labelColor;
+(void)setLabelColor:(UIColor*)labelColor;

// Version
+(NSString*)version;
+(void)setVersion:(NSString*)version;


@end
