//
//  VWWHUDHeadingView.m
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 5/31/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "VWWHUDHeadingView.h"
#import "VWWHeadingGridView.h"

@interface VWWHUDHeadingView ()
@property (nonatomic, strong) VWWHeadingGridView *headingGridView;
@end
@implementation VWWHUDHeadingView

-(void)setHeading:(CLHeading*)heading{
    _heading = heading;
    
    // The grid is drawn once and then panned in this view
    // The grid is 560 degrees wide. Self will show 200 of those degrees.
    if(self.headingGridView == nil){
        self.headingGridView = [[VWWHeadingGridView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width * 2.8, self.bounds.size.height)];
        self.headingGridView.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        [self addSubview:self.headingGridView];
//        [self sendSubviewToBack:self.headingGridView];
    }

    // 1.0 = 200 degrees
    CGFloat magneticHeading = self.heading.magneticHeading + 90;
    if(magneticHeading > 360){
        magneticHeading -= 360;
    }
    CGFloat translateX = magneticHeading * self.bounds.size.width / 200.0;
    self.headingGridView.transform = CGAffineTransformMakeTranslation(-translateX, 0);

}




-(void)drawSolidLineUsingContext:(CGContextRef)context
                       fromPoint:(CGPoint)fromPoint
                         toPoint:(CGPoint)toPoint
                           width:(CGFloat)width
                           color:(UIColor*)color{
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, width);
    CGContextMoveToPoint(context, fromPoint.x, fromPoint.y);
    CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
    CGContextStrokePath(context);
    
}

- (void)drawRect:(CGRect)rect {
    
//    
//    self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
//    // Each tick is 10 degrees.
//    // 560 ticks horizontal + 360 + 2* 100 padding
//    // NSEW each 9 (also big)
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextBeginPath(context);
//    
//    const NSUInteger kHorizontalTicks = 56;
//    const CGFloat kSmallTickHeight = 10;
//    const CGFloat kLargeTickHeight = 20;
//    const CGFloat kGutter = 0;
//    const CGFloat kWidth = 2;
//    
//    CGFloat xPerTick = self.bounds.size.width / kHorizontalTicks;
//    
//    for(NSUInteger index = 0; index <= kHorizontalTicks; index++){
//        CGFloat x = index * xPerTick;
//        if(index % 9 == 0){
//            CGFloat y =  self.bounds.size.height - (kGutter + kLargeTickHeight);
//            [self drawSolidLineUsingContext:context
//                                  fromPoint:CGPointMake(x, y)
//                                    toPoint:CGPointMake(x, y+kLargeTickHeight)
//                                      width:kWidth
//                                      color:[UIColor whiteColor]];
//            
//            //            NSString *text = [self directionFromHeading:self.heading];
//            //            [self drawNameUsingContext:cgContext text:text point:CGPointMake(x, 0) color:[UIColor whiteColor]];
//            
//        } else {
//            CGFloat y =  self.bounds.size.height - (kGutter + kSmallTickHeight);
//            [self drawSolidLineUsingContext:context
//                                  fromPoint:CGPointMake(x, y)
//                                    toPoint:CGPointMake(x, y+kSmallTickHeight)
//                                      width:kWidth
//             
//                                      color:[UIColor whiteColor]];
//            
//        }
//    }
}



@end
