//
//  UIView+NGAParallaxMotion.h
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 6/1/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NGAParallaxMotion)

// Positive values make the view appear to be above the surface
// Negative values are below.
// The unit is in points
@property (nonatomic) CGFloat parallaxIntensity;

@end

