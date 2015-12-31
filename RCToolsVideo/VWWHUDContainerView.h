//
//  VWWHUDView.h
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 5/31/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^VWWHUDViewImageBlock)(UIImage* image);

@interface VWWHUDContainerView : UIView
-(void)setImageBlock:(VWWHUDViewImageBlock)imageBlock;
-(void)calibrate;
@end
