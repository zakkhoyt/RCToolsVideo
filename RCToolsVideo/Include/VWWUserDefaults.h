//
//  VWWUserDefaults.h
//  Synthesizer
//
//  Created by Zakk Hoyt on 2/17/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VWWUserDefaults : NSObject

+(float)sensitivity;
+(void)setSensitivity:(float)sensitivity;


+(NSUInteger)tuningSensor;
+(void)setTuningSensor:(NSUInteger)tuningSensor;

+(NSUInteger)tuningFilter;
+(void)setTuningFilter:(NSUInteger)tuningFilter;

+(NSUInteger)tuningColorScheme;
+(void)setTuningColorScheme:(NSUInteger)tuningColorScheme;

+(NSUInteger)tuningUpdateFrequency;
+(void)setTuningUpdateFrequency:(NSUInteger)tuningUpdateFrequency;

+(BOOL)hpf;
+(void)setHFP:(BOOL)hpf;

+(BOOL)hasInitialized;
+(void)setHasInitialized:(BOOL)hasInitialized;



+(BOOL)logGPS;
+(void)setLogGPS:(BOOL)log;

+(BOOL)logHeading;
+(void)setLogHeading:(BOOL)log;

+(BOOL)logAccelerometers;
+(void)setLogAccelerometers:(BOOL)log;

+(BOOL)logGyroscopes;
+(void)setLogGyroscopes:(BOOL)log;

+(BOOL)logMagnetometers;
+(void)setLogMagnetometers:(BOOL)log;

+(BOOL)logAttitude;
+(void)setLogAttitude:(BOOL)log;

+(BOOL)overlayDataOnVideo;
+(void)setOverlayDataOnVideo:(BOOL)overlay;

+(NSUInteger)updateFrequency;
+(void)setUpdateFrequency:(NSUInteger)updateFrequency;


//+(VWWUnitType)units;
//+(void)setUnits:(VWWUnitType)units;
//
//+(VWWOffsetType)offset;
//+(void)setOffset:(VWWOffsetType)offset;
//


@end
