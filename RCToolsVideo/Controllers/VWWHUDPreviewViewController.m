//
//  VWWHUDPreviewViewController.m
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 9/18/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWHUDPreviewViewController.h"
#import "VWWHUDView.h"

@interface VWWHUDPreviewViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *fieldImageView;
@property (weak, nonatomic) IBOutlet UIImageView *hudImageView;
@property (nonatomic, strong) VWWHUDView *hudView;

@end

@implementation VWWHUDPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureHandler:)];
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:singleTapGestureRecognizer];

    NSUInteger index = arc4random() % 2;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"field0%ld", (long)index]];
    self.fieldImageView.image = image;
    
//    __weak VWWHUDPreviewViewController *welf = self;
    
    VWWHUDView *hudView = [[[NSBundle mainBundle]loadNibNamed:@"VWWHUDView" owner:self options:nil] firstObject];
    hudView.frame = self.view.bounds;
    [hudView setNeedsDisplay];
    self.hudView = hudView;
    [self.view addSubview:self.hudView];
    [self.hudView setImageBlock:^(UIImage *image) {
//        welf.hudImageView.image = image;
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
}

-(void)singleTapGestureHandler:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
