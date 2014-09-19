//
//  VWWSwitchTableViewCell.h
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 9/19/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWTableViewCell.h"

@class VWWSwitchTableViewCell;

@protocol  VWWSwitchTableViewCellDelegate <NSObject>
-(void)switchTableViewCell:(VWWSwitchTableViewCell*)sender switchValueChanged:(BOOL)on;
@end

@interface VWWSwitchTableViewCell : VWWTableViewCell
@property (nonatomic, weak) id <VWWSwitchTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *optionSwitch;
@end
