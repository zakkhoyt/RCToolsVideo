//
//  VWWSample.m
//  RCToolsBalancer
//
//  Created by Zakk Hoyt on 9/11/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWSample.h"

@implementation VWWSample
-(id)init{
    self = [super init];
    if(self){
        _x = [[VWWSampleAxis alloc]init];
        _y = [[VWWSampleAxis alloc]init];
        _z = [[VWWSampleAxis alloc]init];
    }
    return self;
}

//-(id)initWithDictionary:(NSDictionary*)dictionary{
//    
//    self = [super init];
//    if(self){
//        NSDictionary *xDictionary = dictionary[@"x"];
//        _x = [[VWWSampleAxis alloc]initWithDictionary:xDictionary];
//        
//        NSDictionary *yDictionary = dictionary[@"y"];
//        _y = [[VWWSampleAxis alloc]initWithDictionary:yDictionary];
//        
//        NSDictionary *zDictionary = dictionary[@"z"];
//        _z = [[VWWSampleAxis alloc]initWithDictionary:zDictionary];
//    }
//    return self;
//}

-(id)initWithX:(VWWSampleAxis*)x Y:(VWWSampleAxis*)y Z:(VWWSampleAxis*)z{
    self = [super init];
    if(self){
        _x = x;
        _y = y;
        _z = z;
    }
    return self;
}

//-(NSDictionary*)dictionaryRepresentation{
//    return @{@"x" : [self.x dictionaryRepresentation],
//             @"y" : [self.y dictionaryRepresentation],
//             @"z" : [self.z dictionaryRepresentation]};
//}

-(NSString*)description{
    return [NSString stringWithFormat:@"x: %@\n"
            @"y: %@\n"
            @"z: %@\n",
            _x.description,
            _y.description,
            _z.description];
}

@end
