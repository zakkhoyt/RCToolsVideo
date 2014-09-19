//
//  VWWHUDView.m
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 9/19/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWHUDView.h"
#import "NSTimer+Blocks.h"
#import "VWWLocationController.h"

@interface VWWHUDView (){
    UILabel *locationLabel;
}

@end

@implementation VWWHUDView


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [[VWWLocationController sharedInstance] start];
        
        [NSTimer scheduledTimerWithTimeInterval:0.2 block:^{
//            [self setNeedsDisplay];
            [self updateContent];
        } repeats:YES];
    }
    return self;
}

//- (void)drawRect:(CGRect)rect {
//
//}

-(void)updateContent{
    if(locationLabel == nil){
        const CGFloat kHeight = 30;
        CGRect frame = CGRectMake(0, 0, self.bounds.size.width, kHeight);
        locationLabel = [[UILabel alloc]initWithFrame:frame];
        locationLabel.center = CGPointMake(self.center.x, self.bounds.size.height - kHeight);
        locationLabel.textAlignment = NSTextAlignmentCenter;
//        locationLabel.backgroundColor = [UIColor clearColor];
        locationLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        locationLabel.textColor = [UIColor whiteColor];
        [self addSubview:locationLabel];
    }
    locationLabel.text = [NSString stringWithFormat:@"%f,%f",
                          [VWWLocationController sharedInstance].location.coordinate.latitude,
                          [VWWLocationController sharedInstance].location.coordinate.longitude];
}

@end
