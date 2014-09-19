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
    UILabel *coordinateLabel;
    UILabel *topSpeedLabel;
    UILabel *headingLabel;
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
    const CGFloat kHeight = 30.0;
    const CGFloat kGutter = 8.0;

    
    // *************************************** Coordinate *******************************************
    if(coordinateLabel == nil){
        CGRect frame = CGRectMake(0, 0, self.bounds.size.width, kHeight);
        coordinateLabel = [[UILabel alloc]initWithFrame:frame];
        coordinateLabel.center = CGPointMake(self.center.x, self.bounds.size.height - kHeight);
        coordinateLabel.textAlignment = NSTextAlignmentCenter;
//        locationLabel.backgroundColor = [UIColor clearColor];
        coordinateLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        coordinateLabel.textColor = [UIColor whiteColor];
        [self addSubview:coordinateLabel];
    }
    if([VWWLocationController sharedInstance].heading){
        coordinateLabel.text = [NSString stringWithFormat:@"%f,%f",
                                [VWWLocationController sharedInstance].location.coordinate.latitude,
                                [VWWLocationController sharedInstance].location.coordinate.longitude];
    }

    
    // *************************************** Top Speed *******************************************
    if(topSpeedLabel == nil){
        CGRect frame = CGRectMake(0, 0, self.bounds.size.width, kHeight);
        topSpeedLabel = [[UILabel alloc]initWithFrame:frame];
        topSpeedLabel.center = CGPointMake(self.center.x, self.bounds.size.height - 2*kHeight - kGutter);
        topSpeedLabel.textAlignment = NSTextAlignmentCenter;
        //        locationLabel.backgroundColor = [UIColor clearColor];
        topSpeedLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        topSpeedLabel.textColor = [UIColor whiteColor];
        [self addSubview:topSpeedLabel];
    }
    
    if([VWWLocationController sharedInstance].heading){
        topSpeedLabel.text = [NSString stringWithFormat:@"Top Speed:%.f",
                             [VWWLocationController sharedInstance].maxSpeed];
    }

    
    
    
    
    // *************************************** Heading *******************************************
    if(headingLabel == nil){
        CGRect frame = CGRectMake(0, 0, self.bounds.size.width, kHeight);
        headingLabel = [[UILabel alloc]initWithFrame:frame];
        headingLabel.center = CGPointMake(self.center.x, self.bounds.size.height - 3*kHeight - 2*kGutter);
        headingLabel.textAlignment = NSTextAlignmentCenter;
//        locationLabel.backgroundColor = [UIColor clearColor];
        headingLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        headingLabel.textColor = [UIColor whiteColor];
        [self addSubview:headingLabel];
    }
    
    if([VWWLocationController sharedInstance].heading){
        headingLabel.text = [NSString stringWithFormat:@"Heading: (T)%.2f (M)%.2f",
                             [VWWLocationController sharedInstance].heading.trueHeading,
                             [VWWLocationController sharedInstance].heading.magneticHeading];
    }
    
}

@end
