//
//  VWWSampleAxis.h
//  RCToolsBalancer
//
//  Created by Zakk Hoyt on 9/11/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VWWSampleAxis : NSObject
-(id)init;
// Stores the offset if High Pass Filter is enabled
@property (nonatomic) float hpf;
// The current value for the sample;
@property (nonatomic) float value;

//-(id)initWithDictionary:(NSDictionary*)dictionary;
//-(NSDictionary*)dictionaryRepresentation;
@end
