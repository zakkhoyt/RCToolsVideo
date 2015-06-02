//
//  VWWHUDPreviewViewController.m
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 9/18/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWPreviewViewController.h"
#import "VWWHUDView.h"
#import "UIView+ParallaxMotion.h"

@interface VWWPreviewViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *fieldImageView;
@property (nonatomic, strong) VWWHUDView *hudView;
@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@end

@implementation VWWPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureHandler:)];
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:singleTapGestureRecognizer];

    NSUInteger index = arc4random() % 7;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"field0%ld", (long)index]];
    self.fieldImageView.image = image;
    self.fieldImageView.parallaxIntensity = 100;
    
    VWWHUDView *hudView = [[[NSBundle mainBundle]loadNibNamed:@"VWWHUDView" owner:self options:nil] firstObject];
    hudView.frame = self.view.bounds;
    [hudView setNeedsDisplay];
    self.hudView = hudView;
    [self.view addSubview:self.hudView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIView animateWithDuration:0.2 animations:^{
        self.fieldImageView.alpha = 0;
    }];
}

-(void)singleTapGestureHandler:(id)sender{
    self.view.clipsToBounds = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
