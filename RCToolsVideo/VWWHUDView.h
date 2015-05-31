//
//  VWWHUDView.h
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 9/19/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VWWHUDView : UIView
@property (nonatomic) BOOL renderDropShadows;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *labelColor;
@property (nonatomic, strong) UIColor *hudColor;
@property (nonatomic) NSTextAlignment textAlignment;

@end
