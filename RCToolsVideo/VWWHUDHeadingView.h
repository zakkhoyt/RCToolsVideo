//
//  VWWHUDHeadingView.h
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 5/31/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "VWWHUDView.h"
#import <CoreLocation/CoreLocation.h>

@interface VWWHUDHeadingView : VWWHUDView
@property (nonatomic, strong) CLHeading *heading;
@end
