//
//  VWWButtonTableViewCell.m
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 9/19/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWButtonTableViewCell.h"

@implementation VWWButtonTableViewCell

- (IBAction)actionButtonTouchUpInside:(id)sender {
    [self.delegate buttonTableViewCellActionButtonTouchUpInside:self];
}

@end
