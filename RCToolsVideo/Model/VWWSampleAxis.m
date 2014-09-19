//
//  VWWSampleAxis.m
//  RCToolsBalancer
//
//  Created by Zakk Hoyt on 9/11/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWSampleAxis.h"

@implementation VWWSampleAxis
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hpf = 0;
        self.value = 0;
    }
    return self;
}
//-(id)initWithDictionary:(NSDictionary*)dictionary{
//    self = [self init];
//    if(self){
//        
//        NSNumber *hpfNumber = dictionary[@"hpf"];
//        self.hpf = hpfNumber.floatValue;
//        
//        NSNumber *valueNumber = dictionary[@"value"];
//        self.value= valueNumber.floatValue;
//        
//    }
//    return self;
//}
//
//
//
//
//-(NSDictionary*)dictionaryRepresentation{
//    return @{@"hpf" : @(self.hpf),
//             @"value" : @(self.value)};
//}

-(NSString*)description{
    return [NSString stringWithFormat:@"value: %f hpf: %f", _value, _hpf ];
}
@end
