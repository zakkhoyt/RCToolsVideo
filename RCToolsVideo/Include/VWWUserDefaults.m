//
//  VWWUserDefaults.m
//  Synthesizer
//
//  Created by Zakk Hoyt on 2/17/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWUserDefaults.h"

static NSString *VWWUserDefaultsTuningSensorKey = @"tuningSensor";
static NSString *VWWUserDefaultsTuningFilterKey = @"tuningFilter";
static NSString *VWWUserDefaultsTuningColorSchemeKey = @"tuningColorScheme";
static NSString *VWWUserDefaultsTuningUpdateFrequencyKey = @"tuningUpdateFrequency";

static NSString *VWWUserDefaultsHPFKey = @"hpf";
static NSString *VWWUserDefaultsHasInitializedKey = @"hasInitialized";
static NSString *VWWUserDefaultsLogGPSKey = @"logGPS";
static NSString *VWWUserDefaultsLogHeadingKey = @"logHeading";
static NSString *VWWUserDefaultsLogAccelerometersKey = @"logAccelerometers";
static NSString *VWWUserDefaultsLogGryoscopesKey = @"logGyroscopes";
static NSString *VWWUserDefaultsLogMagnetometersKey = @"logMagnetometers";
static NSString *VWWUserDefaultsLogAttitudeKey = @"logAttitude";
static NSString *VWWUserDefaultsLogOverlayDataOnVideoKey = @"overlayDataOnVideo";
static NSString *VWWUserDefaultsUnitsKey = @"units";
static NSString *VWWUserDefaultsOffsetKey = @"offset";
static NSString *VWWUserDefaultsUpdateFrequencyKey = @"updateFrequency";
static NSString *VWWUserDefaultsSensitivityKey = @"sensitivity";

@implementation VWWUserDefaults



+(float)sensitivity{
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:VWWUserDefaultsSensitivityKey];
    if(number == nil){
        return 1.0;
    }
    return number.floatValue;
}
+(void)setSensitivity:(float)sensitivity{
    [[NSUserDefaults standardUserDefaults] setObject:@(sensitivity) forKey:VWWUserDefaultsSensitivityKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}





+(NSUInteger)tuningFilter{
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:VWWUserDefaultsTuningFilterKey];
    if(number == nil){
        return 1; // Butterworth
    }
    return number.unsignedIntegerValue;
}
+(void)setTuningFilter:(NSUInteger)tuningFilter{
    [[NSUserDefaults standardUserDefaults] setObject:@(tuningFilter) forKey:VWWUserDefaultsTuningFilterKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



+(NSUInteger)tuningSensor{
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:VWWUserDefaultsTuningSensorKey];
    if(number == nil){
        return 0; // Accelerometer
    }
    return number.unsignedIntegerValue;
}
+(void)setTuningSensor:(NSUInteger)tuningSensor{
    [[NSUserDefaults standardUserDefaults] setObject:@(tuningSensor) forKey:VWWUserDefaultsTuningSensorKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSUInteger)tuningColorScheme{
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:VWWUserDefaultsTuningColorSchemeKey];
    if(number == nil){
        return 0; // Dark
    }
    return number.unsignedIntegerValue;
}
+(void)setTuningColorScheme:(NSUInteger)tuningColorScheme{
    [[NSUserDefaults standardUserDefaults] setObject:@(tuningColorScheme) forKey:VWWUserDefaultsTuningColorSchemeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSUInteger)tuningUpdateFrequency{
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:VWWUserDefaultsTuningUpdateFrequencyKey];
    if(number == nil){
        return 200;
    }
    return number.unsignedIntegerValue;
}
+(void)setTuningUpdateFrequency:(NSUInteger)tuningUpdateFrequency{
    [[NSUserDefaults standardUserDefaults] setObject:@(tuningUpdateFrequency) forKey:VWWUserDefaultsTuningUpdateFrequencyKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}




+(BOOL)hpf{
    return [[NSUserDefaults standardUserDefaults] boolForKey:VWWUserDefaultsHPFKey];
}
+(void)setHFP:(BOOL)hpf{
    [[NSUserDefaults standardUserDefaults] setBool:hpf forKey:VWWUserDefaultsHPFKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(BOOL)hasInitialized{
    return [[NSUserDefaults standardUserDefaults] boolForKey:VWWUserDefaultsHasInitializedKey];
}
+(void)setHasInitialized:(BOOL)hasInitialized{
    [[NSUserDefaults standardUserDefaults] setBool:hasInitialized forKey:VWWUserDefaultsHasInitializedKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(BOOL)logGPS{
    return [[NSUserDefaults standardUserDefaults] boolForKey:VWWUserDefaultsLogGPSKey];
}
+(void)setLogGPS:(BOOL)log{
    [[NSUserDefaults standardUserDefaults] setBool:log forKey:VWWUserDefaultsLogGPSKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)logHeading{
    return [[NSUserDefaults standardUserDefaults] boolForKey:VWWUserDefaultsLogHeadingKey];
}
+(void)setLogHeading:(BOOL)log{
    [[NSUserDefaults standardUserDefaults] setBool:log forKey:VWWUserDefaultsLogHeadingKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(BOOL)logAccelerometers{
    return [[NSUserDefaults standardUserDefaults] boolForKey:VWWUserDefaultsLogAccelerometersKey];
}
+(void)setLogAccelerometers:(BOOL)log{
    [[NSUserDefaults standardUserDefaults] setBool:log forKey:VWWUserDefaultsLogAccelerometersKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(BOOL)logGyroscopes{
    return [[NSUserDefaults standardUserDefaults] boolForKey:VWWUserDefaultsLogGryoscopesKey];
}
+(void)setLogGyroscopes:(BOOL)log{
    [[NSUserDefaults standardUserDefaults] setBool:log forKey:VWWUserDefaultsLogGryoscopesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(BOOL)logMagnetometers{
    return [[NSUserDefaults standardUserDefaults] boolForKey:VWWUserDefaultsLogMagnetometersKey];
}
+(void)setLogMagnetometers:(BOOL)log{
    [[NSUserDefaults standardUserDefaults] setBool:log forKey:VWWUserDefaultsLogMagnetometersKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(BOOL)logAttitude{
    return [[NSUserDefaults standardUserDefaults] boolForKey:VWWUserDefaultsLogAttitudeKey];
}
+(void)setLogAttitude:(BOOL)log{
    [[NSUserDefaults standardUserDefaults] setBool:log forKey:VWWUserDefaultsLogAttitudeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)overlayDataOnVideo{
    return [[NSUserDefaults standardUserDefaults] boolForKey:VWWUserDefaultsLogOverlayDataOnVideoKey];
}
+(void)setOverlayDataOnVideo:(BOOL)overlay{
    [[NSUserDefaults standardUserDefaults] setBool:overlay forKey:VWWUserDefaultsLogOverlayDataOnVideoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(NSUInteger)updateFrequency{
    NSNumber *updateFrequencyNumber = [[NSUserDefaults standardUserDefaults] objectForKey:VWWUserDefaultsUpdateFrequencyKey];
    return updateFrequencyNumber == nil ? 2 : updateFrequencyNumber.unsignedIntegerValue;
}
+(void)setUpdateFrequency:(NSUInteger)updateFrequency{
    [[NSUserDefaults standardUserDefaults] setObject:@(updateFrequency) forKey:VWWUserDefaultsUpdateFrequencyKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//
//+(VWWUnitType)units{
//    NSNumber *unitsNumber = [[NSUserDefaults standardUserDefaults] objectForKey:VWWUserDefaultsUnitsKey];
//    return (VWWUnitType)(unitsNumber ? unitsNumber.integerValue : 0);
//}
//+(void)setUnits:(VWWUnitType)units{
//    [[NSUserDefaults standardUserDefaults] setObject:@((NSUInteger)units) forKey:VWWUserDefaultsUnitsKey];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+(VWWOffsetType)offset{
//    NSNumber *offsetNumber = [[NSUserDefaults standardUserDefaults] objectForKey:VWWUserDefaultsOffsetKey];
//    return (VWWOffsetType)(offsetNumber ? offsetNumber.integerValue : 0);
//}
//+(void)setOffset:(VWWOffsetType)offset{
//    [[NSUserDefaults standardUserDefaults] setObject:@((NSUInteger)offset) forKey:VWWUserDefaultsOffsetKey];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}




@end
