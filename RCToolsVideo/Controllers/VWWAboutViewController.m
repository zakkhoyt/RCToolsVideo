//
//  VWWAbouytViewController.m
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 6/1/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "VWWAboutViewController.h"

@interface VWWAboutViewController ()

@end

@implementation VWWAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.title = @"About";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
