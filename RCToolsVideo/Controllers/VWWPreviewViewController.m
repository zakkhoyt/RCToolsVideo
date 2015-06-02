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
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UIButton *calibrateButton;
@end

@implementation VWWPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.exitButton.layer.cornerRadius = self.exitButton.frame.size.width / 2.0;
    self.calibrateButton.layer.cornerRadius = self.calibrateButton.frame.size.width / 2.0;
    
    NSUInteger index = arc4random() % 7;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"field0%ld", (long)index]];
    self.fieldImageView.image = image;
    self.fieldImageView.parallaxIntensity = 100;
    
    VWWHUDView *hudView = [[[NSBundle mainBundle]loadNibNamed:@"VWWHUDView" owner:self options:nil] firstObject];
    hudView.frame = self.view.bounds;
    [hudView setNeedsDisplay];
    self.hudView = hudView;
    [self.view addSubview:self.hudView];
    
    [self.view bringSubviewToFront:self.toolView];
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

- (IBAction)calibrateButtonTouchUpInside:(id)sender {
    [self.hudView calibrate];
}
- (IBAction)exitButtonTouchUpInside:(id)sender {
    self.view.clipsToBounds = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
