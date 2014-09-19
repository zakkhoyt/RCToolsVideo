//
//  VWWDeviceLimits.m
//  RCTools
//
//  Created by Zakk Hoyt on 4/17/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWDeviceLimits.h"

@implementation VWWDeviceLimits
-(id)init{
    self = [super init];
    if(self){
        _x = [[VWWDeviceAxisLimits alloc]init];
        _y = [[VWWDeviceAxisLimits alloc]init];
        _z = [[VWWDeviceAxisLimits alloc]init];
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary*)dictionary{
    
    self = [super init];
    if(self){
        //    _x = [[VWWDeviceAxisLimits alloc]initWithDictionary:dictionary[@]]
        NSLog(@"Dictionary: %@", dictionary);

        NSDictionary *xDictionary = dictionary[@"x"];
        _x = [[VWWDeviceAxisLimits alloc]initWithDictionary:xDictionary];
        
        NSDictionary *yDictionary = dictionary[@"y"];
        _y = [[VWWDeviceAxisLimits alloc]initWithDictionary:yDictionary];
        
        NSDictionary *zDictionary = dictionary[@"z"];
        _z = [[VWWDeviceAxisLimits alloc]initWithDictionary:zDictionary];
    }
    return self;
}

-(NSDictionary*)dictionaryRepresentation{
    return @{@"x" : [self.x dictionaryRepresentation],
             @"y" : [self.y dictionaryRepresentation],
             @"z" : [self.z dictionaryRepresentation]};
}



-(void)reset{
    [self.x reset];
    [self.y reset];
    [self.z reset];
}

-(NSString*)description{
    return [NSString stringWithFormat:@"x: %@\n"
            @"y: %@\n"
            @"z: %@\n",
            _x.description, _y.description, _z.description];
}
@end
