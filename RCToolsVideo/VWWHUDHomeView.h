//
//  VWWHUDHomeView.h
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 5/31/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;

@interface VWWHUDHomeView : UIView
@property (nonatomic, strong) CLLocation *homeLocation;
@property (nonatomic, strong) CLLocation *currentLocation;
@end
