//
//  VWWSwitchTableViewCell.m
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 9/19/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWSwitchTableViewCell.h"

@interface VWWSwitchTableViewCell ()

@end

@implementation VWWSwitchTableViewCell


- (IBAction)optionSwitchValueChanged:(UISwitch*)sender {
    [self.delegate switchTableViewCell:self switchValueChanged:sender.on];
}

@end
