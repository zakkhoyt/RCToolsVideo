//
//  VWWHUDHeadingView.m
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 5/31/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "VWWHUDHeadingView.h"

@implementation VWWHUDHeadingView

-(void)setHeading:(CLHeading*)heading{
    _heading = heading;
    [self setNeedsDisplay];
}

-(void)drawSolidLineUsingContext:(CGContextRef)context
                       fromPoint:(CGPoint)fromPoint
                         toPoint:(CGPoint)toPoint
                           color:(UIColor*)color{
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 0.5f);
    CGContextMoveToPoint(context, fromPoint.x, fromPoint.y);
    CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
    CGContextStrokePath(context);
    
}


- (void)drawRect:(CGRect)rect {
    
    // 20 ticks horizontal
    // NSEW each 9 (also big)
    // Arrow in center
    
    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(cgContext);
    
    const NSUInteger kHorizontalTicks = 20;
    const CGFloat kSmallTickHeight = 10;
    const CGFloat kLargeTickHeight = 20;
    const CGFloat kGutter = 8;
    CGFloat xPerTick = self.bounds.size.width / kHorizontalTicks - 1;
    
    for(NSUInteger index = 0; index <= kHorizontalTicks; index++){
        CGFloat x = index * xPerTick;

//        CGFloat y = index % 9 == 0 ? self.bounds.size.height - (kGutter + kSmallTickHeight) : self.bounds.size.height - (kGutter + kLargeTickHeight);
        CGFloat y =  self.bounds.size.height - (kGutter + kSmallTickHeight);
        [self drawSolidLineUsingContext:cgContext
                              fromPoint:CGPointMake(x, y)
                                toPoint:CGPointMake(x, y+kSmallTickHeight)
                                  color:[UIColor whiteColor]];
    }
    
    
//    [self drawSolidLineUsingContext:cgContext
//                          fromPoint:CGPointMake(0, self.bounds.size.height / 2.0)
//                            toPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height / 2.0)
//                              color:[UIColor whiteColor]];
    
    
//    CGFloat yMax = xBaseline - self.session.limits.x.max * yFactor;
//    [self drawDashedLineUsingContext:cgContext fromPoint:CGPointMake(0, yMax) toPoint:CGPointMake(self.bounds.size.width, yMax) color:xColor];
//    
//    CGFloat yMin = xBaseline - self.session.limits.x.min * yFactor;
//    [self drawDashedLineUsingContext:cgContext fromPoint:CGPointMake(0, yMin) toPoint:CGPointMake(self.bounds.size.width, yMin) color:xColor];
//    
//    CGContextSetLineWidth(cgContext, 2.0f);
//    for(NSInteger index = 0; index < kSamples; index++){
//        NSDictionary *d = self.session.samples[startIndex + index];
//        NSNumber *yNumber = d[@"x"];
//        CGFloat y = -yNumber.floatValue * yFactor + xBaseline;
//        if(index == 0){
//            CGContextMoveToPoint(cgContext, 0, y);
//        } else {
//            CGFloat x = index * xFactor;
//            CGContextAddLineToPoint(cgContext, x, y);
//        }
//    }
//    CGContextStrokePath(cgContext);
    
}

@end
