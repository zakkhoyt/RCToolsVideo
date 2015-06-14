//
//  VWWHUDView.h
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 6/14/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VWWHUDView : UIView

-(void)drawSolidLineUsingContext:(CGContextRef)context
                       fromPoint:(CGPoint)fromPoint
                         toPoint:(CGPoint)toPoint
                           width:(CGFloat)width
                           color:(UIColor*)color;

-(void)drawStringUsingContext:(CGContextRef)context
                         text:(NSString*)text
                        point:(CGPoint)point
                        color:(UIColor*)color;

@end
