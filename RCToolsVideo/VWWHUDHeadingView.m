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
@property (nonatomic, strong) UILabel *headingLabel;
@end
@implementation VWWHUDHeadingView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.headingLabel.text = @"n/a";
    }
    return self;
}

-(void)setHeading:(CLHeading*)heading{
    _heading = heading;

    [self setLabel];
    [self setGrid];
}

-(void)setLabel{
    if(self.headingLabel == nil){
        CGRect frame = CGRectMake(0, 0, self.bounds.size.width, 21);
        self.headingLabel = [[UILabel alloc]initWithFrame:frame];
        self.headingLabel.textColor = [UIColor whiteColor];
        self.headingLabel.textAlignment = NSTextAlignmentCenter;
        self.headingLabel.shadowOffset = CGSizeMake(0, -1);
        self.headingLabel.shadowColor = [UIColor blackColor];
        [self addSubview:self.headingLabel];
    }
    
    float magneticHeading = 0;
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    if(deviceOrientation == UIDeviceOrientationLandscapeRight){
        magneticHeading = self.heading.magneticHeading - 90;
        if(magneticHeading < 0){
            magneticHeading += 360;
        }
    } else {
        magneticHeading = self.heading.magneticHeading + 90;
        if(magneticHeading > 360){
            magneticHeading -= 360;
        }
    }
    
    self.headingLabel.text = [NSString stringWithFormat:@"Heading: %.2f +/-%lu",
                              magneticHeading,
                              (unsigned long)self.heading.headingAccuracy];

}

-(void)setGrid{
    // The grid is drawn once and then panned in this view
    // The grid is 560 degrees wide. Self will show 200 of those degrees.
    if(self.headingGridView == nil){
        self.headingGridView = [[VWWHeadingGridView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width * 2.8, self.bounds.size.height)];
        self.headingGridView.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        [self addSubview:self.headingGridView];
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
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint start = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height - 12);
    CGPoint end = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height);
    [self drawSolidLineUsingContext:context fromPoint:start toPoint:end width:6 color:[UIColor whiteColor]];
}



@end
