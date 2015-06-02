//
//  UIView+NGAParallaxMotion.m
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 6/1/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "UIView+ParallaxMotion.h"
#import <objc/runtime.h>

static void * const kNGAParallaxDepthKey = (void*)&kNGAParallaxDepthKey;

@implementation UIView (NGAParallaxMotion)
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 70000
#warning DISABLED WITHOUT IOS7 SDK
#else
static void * const kNGAParallaxMotionEffectGroupKey = (void*)&kNGAParallaxMotionEffectGroupKey;
#endif

-(void)setParallaxIntensity:(CGFloat)parallaxDepth
{
    if (self.parallaxIntensity == parallaxDepth)
        return;
    
    objc_setAssociatedObject(self, kNGAParallaxDepthKey, @(parallaxDepth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    // skip this part if pre-iOS7
    if (![UIInterpolatingMotionEffect class])
        return;
    
    if (parallaxDepth == 0.0)
    {
        [self removeMotionEffect:[self nga_parallaxMotionEffectGroup]];
        [self nga_setParallaxMotionEffectGroup:nil];
        return;
    }
    
    UIMotionEffectGroup * parallaxGroup = [self nga_parallaxMotionEffectGroup];
    if (!parallaxGroup)
    {
        parallaxGroup = [[UIMotionEffectGroup alloc] init];
        [self nga_setParallaxMotionEffectGroup:parallaxGroup];
        [self addMotionEffect:parallaxGroup];
    }
    
    UIInterpolatingMotionEffect *xAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    UIInterpolatingMotionEffect *yAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    
    NSArray * motionEffects = @[xAxis, yAxis];
    
    for (UIInterpolatingMotionEffect * motionEffect in motionEffects )
    {
        motionEffect.maximumRelativeValue = @(parallaxDepth);
        motionEffect.minimumRelativeValue = @(-parallaxDepth);
    }
    parallaxGroup.motionEffects = motionEffects;
#endif
}

-(CGFloat)parallaxIntensity
{
    NSNumber * val = objc_getAssociatedObject(self, kNGAParallaxDepthKey);
    if (!val)
        return 0.0;
    return val.doubleValue;
}

#pragma mark -

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000

-(UIMotionEffectGroup*)nga_parallaxMotionEffectGroup
{
    return objc_getAssociatedObject(self, kNGAParallaxMotionEffectGroupKey);
}

-(void)nga_setParallaxMotionEffectGroup:(UIMotionEffectGroup*)group
{
    objc_setAssociatedObject(self, kNGAParallaxMotionEffectGroupKey, group, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSAssert( group == objc_getAssociatedObject(self, kNGAParallaxMotionEffectGroupKey), @"set didn't work" );
}
#endif

@end


