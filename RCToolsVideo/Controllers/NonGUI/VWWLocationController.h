//
//  VWWLocationController.h
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 9/18/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VWWBlocks.h"
@import CoreLocation;



@interface VWWLocationController : NSObject

+(VWWLocationController*)sharedInstance;
-(void)start;
-(void)stop;
//-(void)reset;
//-(void)getCurrentLocationWithCompletionBlock:(VWWCLLocationBlock)completionBlock;
//@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, copy) CLHeading *heading;
@property (nonatomic, copy) CLLocation *location;;

@end
