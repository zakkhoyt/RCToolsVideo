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

@implementation VWWUserDefaults

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
