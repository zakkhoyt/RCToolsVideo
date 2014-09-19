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
-(void)resetStats;

// CLHeading includes true and magnetic
@property (nonatomic, copy) CLHeading *heading;

// In m/s
@property (nonatomic) CLLocationSpeed maxSpeed;
@property (nonatomic) CLLocationSpeed currentSpeed;

// CLLocation
@property (nonatomic, copy) CLLocation *location;

// In meters
@property (nonatomic) CLLocationDistance distanceFromHome;
@end
