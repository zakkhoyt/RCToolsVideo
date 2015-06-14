//
//  VWWHeadingGridView.m
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 6/12/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "VWWHeadingGridView.h"

@implementation VWWHeadingGridView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setNeedsDisplay];
    }
    return self;
}





- (void)drawRect:(CGRect)rect {
    
    

    // Each tick is 10 degrees.
    // 560 ticks horizontal + 360 + 2* 100 padding
    // NSEW each 9 (also big)
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    
    const NSUInteger kHorizontalTicks = 56;
    const CGFloat kSmallTickHeight = 10;
    const CGFloat kLargeTickHeight = 12;
    const CGFloat kGutter = 0;
    const CGFloat kWidth = 2;
    
    CGFloat xPerTick = self.bounds.size.width / kHorizontalTicks;
    
    for(NSUInteger index = 0; index <= kHorizontalTicks; index++){
        CGFloat x = index * xPerTick;
        if((index - 1) % 9 == 0){
            CGFloat y =  self.bounds.size.height - (kGutter + kLargeTickHeight);
            [self drawSolidLineUsingContext:context
                                  fromPoint:CGPointMake(x, y)
                                    toPoint:CGPointMake(x, y+kLargeTickHeight)
                                      width:kWidth
                                      color:[UIColor whiteColor]];
            
            
            // W 1, 37,
            // N 10, 46
            // E 19, 55,
            // S 26, 62,
            NSString *text = nil;
            if(index == 1 || index == 37){
                text = @"W";
            } else if(index == 10 || index == 46){
                text = @"N";
            } else if(index == 19 || index == 55){
                text = @"E";
            } else if(index == 28 || index == 64){
                text = @"S";
            }
            if(text){
                CGPoint point = CGPointMake(x-7, self.bounds.size.height - kLargeTickHeight - 25);
                [self drawStringUsingContext:context text:text point:point color:[UIColor whiteColor]];
            }
            
        } else {
            CGFloat y =  self.bounds.size.height - (kGutter + kSmallTickHeight);
            [self drawSolidLineUsingContext:context
                                  fromPoint:CGPointMake(x, y)
                                    toPoint:CGPointMake(x, y+kSmallTickHeight)
                                      width:kWidth
             
                                      color:[UIColor whiteColor]];
            
        }
    }
}


@end
