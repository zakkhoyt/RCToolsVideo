//
//  VWWDeviceAxisLimits.m
//  RCTools
//
//  Created by Zakk Hoyt on 4/17/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWDeviceAxisLimits.h"

@implementation VWWDeviceAxisLimits

-(id)initWithDictionary:(NSDictionary*)dictionary{
    self = [self init];
    if(self){
        NSNumber *minNumber = dictionary[@"min"];
        self.min = minNumber.floatValue;
        
        NSNumber *rmsNumber = dictionary[@"rms"];
        self.rms = rmsNumber.floatValue;
        
        NSNumber *maxNumber = dictionary[@"max"];
        self.max = maxNumber.floatValue;
    }
    return self;
}



-(void)reset{
    self.min = 0;
    self.max = 0;
    self.rms = 0;

}

-(NSDictionary*)dictionaryRepresentation{
    return @{@"min" : @(self.min),
             @"max" : @(self.max),
             @"rms" : @(self.rms)};
}

-(NSString*)description{
    return [NSString stringWithFormat:@"min: %f\n"
            @"max: %f\n"
            @"rms: %f\n",
            _min, _max, _rms];
}
@end
