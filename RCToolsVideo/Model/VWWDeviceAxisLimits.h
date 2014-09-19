//
//  VWWDeviceAxisLimits.h
//  RCTools
//
//  Created by Zakk Hoyt on 4/17/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VWWDeviceAxisLimits : NSObject
-(id)initWithDictionary:(NSDictionary*)dictionary;
@property (nonatomic) float min;
@property (nonatomic) float max;
@property (nonatomic) float rms;
-(void)reset;
-(NSDictionary*)dictionaryRepresentation;
@end
