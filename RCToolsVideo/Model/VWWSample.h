//
//  VWWSample.h
//  RCToolsBalancer
//
//  Created by Zakk Hoyt on 9/11/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VWWSampleAxis.h"

@interface VWWSample : NSObject
-(id)initWithX:(VWWSampleAxis*)x Y:(VWWSampleAxis*)y Z:(VWWSampleAxis*)z;
@property (nonatomic, strong) VWWSampleAxis *x;
@property (nonatomic, strong) VWWSampleAxis *y;
@property (nonatomic, strong) VWWSampleAxis *z;

//-(id)initWithDictionary:(NSDictionary*)dictionary;
//-(NSDictionary*)dictionaryRepresentation;
@end
