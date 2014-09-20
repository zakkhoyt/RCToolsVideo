//
//  VWWVideoViewController.m
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 9/19/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWVideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface VWWVideoViewController ()

@end

@implementation VWWVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    
//    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:self.url];
//    player.view.frame = self.view.bounds;
//    [self presentMoviePlayerViewControllerAnimated:player];
////   [self.view addSubview:player.view];
//
//    [player play];
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
