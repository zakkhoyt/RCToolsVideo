//
//  VWWSessionOptionsTableViewController.m
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 9/18/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWSessionOptionsTableViewController.h"
#import "VWWHUDPreviewViewController.h"
#import "VWWSessionViewController.h"
#import "VWW.h"


static NSString *VWWSegueOptionsToSession = @"VWWSegueOptionsToSession";
static NSString *VWWSegueOptionsToPreview = @"VWWSegueOptionsToPreview";

@interface VWWSessionOptionsTableViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *headingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *altitudeSeitch;
@property (weak, nonatomic) IBOutlet UISwitch *distanceHomeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *speedSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *coordinateSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *dateSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *attitudeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *forcesSwitch;
@end

@implementation VWWSessionOptionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *readyButton = [[UIBarButtonItem alloc]initWithTitle:@"Ready" style:UIBarButtonItemStylePlain target:self action:@selector(readyButtonAction:)];
    self.navigationItem.rightBarButtonItem = readyButton;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    self.headingSwitch.on = [VWWUserDefaults renderHeading];
    self.altitudeSeitch.on = [VWWUserDefaults renderAltitude];
    self.distanceHomeSwitch.on = [VWWUserDefaults renderDistanceFromHome];
    self.speedSwitch.on = [VWWUserDefaults renderSpeed];
    self.coordinateSwitch.on = [VWWUserDefaults renderCoordinates];
    self.dateSwitch.on = [VWWUserDefaults renderDate];
    self.attitudeSwitch.on = [VWWUserDefaults renderAttitudeIndicator];
    self.forcesSwitch.on = [VWWUserDefaults renderAccelerometers];
}


- (void)readyButtonAction:(id)sender {
    
    [VWWUserDefaults setRenderHeading:self.headingSwitch.on];
    [VWWUserDefaults setRenderAltitude:self.altitudeSeitch.on];
    [VWWUserDefaults setRenderDistanceFromHome:self.distanceHomeSwitch.on];
    [VWWUserDefaults setRenderSpeed:self.speedSwitch.on];
    [VWWUserDefaults setRenderCoordinates:self.coordinateSwitch.on];
    [VWWUserDefaults setRenderDate:self.dateSwitch.on];
    [VWWUserDefaults setRenderAttitudeIndicator:self.attitudeSwitch.on];
    [VWWUserDefaults setRenderAccelerometers:self.forcesSwitch];
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"Preview" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self performSegueWithIdentifier:VWWSegueOptionsToPreview sender:self];
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"Video" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self performSegueWithIdentifier:VWWSegueOptionsToSession sender:self];
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
 
    }]];
    
    [self presentViewController:ac animated:YES completion:NULL];
}

@end







