//
//  VWWHUDView.m
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 6/14/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "VWWHUDView.h"

@implementation VWWHUDView

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

-(void)drawStringUsingContext:(CGContextRef)context text:(NSString*)text point:(CGPoint)point color:(UIColor*)color{
    NSDictionary* stringAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:20],
                                       NSForegroundColorAttributeName: color};
    
    NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:text attributes:stringAttributes];
    [attrStr drawAtPoint:point];
}

@end
