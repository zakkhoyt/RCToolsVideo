//
//  VWWUserDefaults.h
//  Synthesizer
//
//  Created by Zakk Hoyt on 2/17/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VWWUserDefaults : NSObject


+(NSUInteger)hud;
+(void)setHUD:(NSUInteger)hud;

+(NSUInteger)resolution;
+(void)setResolution:(NSUInteger)resolution;


@end
