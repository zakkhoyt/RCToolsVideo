//
//  VWWHUDHomeView.h
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 5/31/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "VWWHUDView.h"
@import CoreLocation;

@interface VWWHUDHomeView : VWWHUDView
@property (nonatomic, strong) CLLocation *homeLocation;
@property (nonatomic, strong) CLLocation *currentLocation;
@end
