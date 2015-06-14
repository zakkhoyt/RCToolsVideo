//
//  VWWHUDAttitudeView.m
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 5/31/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "VWWHUDAttitudeView.h"

@interface VWWHUDAttitudeView ()
@property (nonatomic) CGFloat pitch;
@property (nonatomic) CGFloat roll;
@property (nonatomic) CGFloat yaw;
@property (nonatomic, strong) UIView *pitchAbove1View;
@property (nonatomic, strong) UIView *pitchAbove2View;
@property (nonatomic, strong) UIView *pitchBelow1View;
@property (nonatomic, strong) UIView *pitchBelow2View;
@property (nonatomic, strong) UIView *pitchView;
@property (nonatomic, strong) UIView *rollView;
@property (nonatomic, strong) UILabel *attitudeLabel;

@end

@implementation VWWHUDAttitudeView


-(void)setPitch:(CGFloat)pitch roll:(CGFloat)roll yaw:(CGFloat)yaw{
    _pitch = pitch;
    _roll = roll;
    _yaw = yaw;
    [self renderAttitude];
    [self renderText];
}

-(void)renderAttitude{
    //    if(self.rollLayer == nil){
    //        self.rollLayer = [CAShapeLayer layer];
    //        UIBezierPath *linePath = [UIBezierPath bezierPath];
    //        CGPoint leftPoint = CGPointMake(0, self.bounds.size.height / 2.0);
    //        CGPoint rightPoint = CGPointMake(self.bounds.size.width, self.bounds.size.height / 2.0);
    //        [linePath moveToPoint:leftPoint];
    //        [linePath addLineToPoint:rightPoint];
    //        self.rollLayer.path = linePath.CGPath;
    //        self.rollLayer.fillColor = [UIColor redColor].CGColor;
    //        self.rollLayer.opacity = 1.0;
    //        self.rollLayer.strokeColor = [UIColor whiteColor].CGColor;
    //        self.rollLayer.lineWidth = 1.0;
    ////        self.rollLayer.anchorPoint = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    //        self.rollLayer.anchorPoint = CGPointMake(0.5, 0.5);
    //        [self.layer addSublayer:self.rollLayer];
    //    }
    //
    //    self.rollLayer.transform = CATransform3DMakeRotation(-(self.roll), 0, 0, 1);
    
    if(self.rollView == nil){
        CGRect frame = CGRectMake(0,
                                  (self.bounds.size.height / 2.0),
                                  self.bounds.size.width, 2);
        
        self.rollView = [[UIView alloc]initWithFrame:frame];
        self.rollView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.rollView];
    }
    
    self.rollView.transform = CGAffineTransformMakeRotation(-self.roll);
    
    if(self.pitchView == nil){
        {
            CGRect frame = CGRectMake(self.bounds.size.width * 0.25,
                                      (self.bounds.size.height / 2.0),
                                      self.bounds.size.width * 0.5,
                                      2);
            
            self.pitchView = [[UIView alloc]initWithFrame:frame];
            self.pitchView.backgroundColor = [UIColor whiteColor];
            [self addSubview:self.pitchView];
        }
        {
            CGRect frame = CGRectMake(self.bounds.size.width * 0.4,
                                      (self.bounds.size.height * 0.25),
                                      self.bounds.size.width * 0.2,
                                      2);
            
            self.pitchAbove1View = [[UIView alloc]initWithFrame:frame];
            self.pitchAbove1View.backgroundColor = [UIColor whiteColor];
            [self addSubview:self.pitchAbove1View];
        }
        {
            CGRect frame = CGRectMake(self.bounds.size.width * 0.4,
                                      (self.bounds.size.height * 0),
                                      self.bounds.size.width * 0.2,
                                      2);
            
            self.pitchAbove2View = [[UIView alloc]initWithFrame:frame];
            self.pitchAbove2View.backgroundColor = [UIColor whiteColor];
            [self addSubview:self.pitchAbove2View];
        }

        {
            CGRect frame = CGRectMake(self.bounds.size.width * 0.4,
                                      self.bounds.size.height * 0.75,
                                      self.bounds.size.width * 0.2,
                                      2);
            
            self.pitchBelow1View = [[UIView alloc]initWithFrame:frame];
            self.pitchBelow1View.backgroundColor = [UIColor whiteColor];
            [self addSubview:self.pitchBelow1View];
        }
        {
            CGRect frame = CGRectMake(self.bounds.size.width * 0.4,
                                      self.bounds.size.height * 1.0,
                                      self.bounds.size.width * 0.2,
                                      2);
            
            self.pitchBelow2View = [[UIView alloc]initWithFrame:frame];
            self.pitchBelow2View.backgroundColor = [UIColor whiteColor];
            [self addSubview:self.pitchBelow2View];
        }
        
        
    }
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, self.pitch / M_PI_2 * self.bounds.size.height / 2.0);
    self.pitchView.transform = transform;
    self.pitchAbove1View.transform = transform;
    self.pitchAbove2View.transform = transform;
    self.pitchBelow1View.transform = transform;
    self.pitchBelow2View.transform = transform;
}

-(void)renderText{
    
//    if(self.attitudeLabel == nil){
//        const CGFloat kHeight = 85;
//        CGRect frame = CGRectMake(0, self.bounds.size.height - kHeight, self.bounds.size.width, kHeight);
//        self.attitudeLabel = [[UILabel alloc]initWithFrame:frame];
//        self.attitudeLabel.numberOfLines = 4;
//        self.attitudeLabel.textColor = [UIColor whiteColor];
//        self.attitudeLabel.textAlignment = NSTextAlignmentLeft;
//        self.attitudeLabel.shadowOffset = CGSizeMake(0, -1);
//        self.attitudeLabel.shadowColor = [UIColor blackColor];
//        [self addSubview:self.attitudeLabel];
//    }
//
//    self.attitudeLabel.text = [NSString stringWithFormat:@"Roll: %.2frad\n"
//                               @"Pitch: %.2frad\n"
//                               @"Yaw: %.2frad\n",
//                               self.roll, self.pitch, self.yaw];
    if(self.attitudeLabel == nil){
        const CGFloat kHeight = 21;
        CGRect frame = CGRectMake(0, self.bounds.size.height - kHeight, self.bounds.size.width, kHeight);
        self.attitudeLabel = [[UILabel alloc]initWithFrame:frame];
        self.attitudeLabel.numberOfLines = 1;
        self.attitudeLabel.textColor = [UIColor whiteColor];
        self.attitudeLabel.textAlignment = NSTextAlignmentCenter;
        self.attitudeLabel.shadowOffset = CGSizeMake(0, -1);
        self.attitudeLabel.shadowColor = [UIColor blackColor];
        self.attitudeLabel.minimumScaleFactor
        [self addSubview:self.attitudeLabel];
    }
    
    self.attitudeLabel.text = [NSString stringWithFormat:@"Roll: %.2frad "
                               @"Pitch: %.2frad "
                               @"Yaw: %.2frad",
                               self.roll, self.pitch, self.yaw];
    
}


//-(void)drawSolidLineUsingContext:(CGContextRef)context
//                       fromPoint:(CGPoint)fromPoint
//                         toPoint:(CGPoint)toPoint
//                           width:(CGFloat)width
//                           color:(UIColor*)color{
//    CGContextSetStrokeColorWithColor(context, color.CGColor);
//    CGContextSetLineWidth(context, width);
//    CGContextMoveToPoint(context, fromPoint.x, fromPoint.y);
//    CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
//    CGContextStrokePath(context);
//
//}

//- (void)drawRect:(CGRect)rect {
//    if(self.heading) {
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGPoint start = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height - 12);
//        CGPoint end = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height);
//        [self drawSolidLineUsingContext:context fromPoint:start toPoint:end width:6 color:[UIColor whiteColor]];
//    }
//}





@end
