//
//  VWWButtonTableViewCell.h
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 9/19/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWTableViewCell.h"

@class VWWButtonTableViewCell;

@protocol VWWButtonTableViewCellDelegate <NSObject>
-(void)buttonTableViewCellActionButtonTouchUpInside:(VWWButtonTableViewCell*)sender;
@end

@interface VWWButtonTableViewCell : VWWTableViewCell
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) id <VWWButtonTableViewCellDelegate> delegate;
@end
