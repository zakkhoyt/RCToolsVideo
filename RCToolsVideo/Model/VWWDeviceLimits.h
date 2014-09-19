//
//  VWWDeviceLimits.h
//  RCTools
//
//  Created by Zakk Hoyt on 4/17/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VWWDeviceAxisLimits.h"
@interface VWWDeviceLimits : NSObject
-(id)initWithDictionary:(NSDictionary*)dictionary;
-(NSDictionary*)dictionaryRepresentation;
@property (nonatomic, strong) VWWDeviceAxisLimits *x;
@property (nonatomic, strong) VWWDeviceAxisLimits *y;
@property (nonatomic, strong) VWWDeviceAxisLimits *z;
-(void)reset;


@end
