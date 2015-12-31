//
//  VWWSessionOptionsTableViewController.m
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 9/18/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWOptionsTableViewController.h"
#import "VWWSessionViewController.h"
#import "VWW.h"


static NSString *VWWSegueOptionsToSession = @"VWWSegueOptionsToSession";


@interface VWWOptionsTableViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *headingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *altitudeSeitch;
@property (weak, nonatomic) IBOutlet UISwitch *distanceHomeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *speedSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *coordinateSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *dateSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *attitudeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *forcesSwitch;
@end

@implementation VWWOptionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarHidden = YES;
    UIBarButtonItem *readyButton = [[UIBarButtonItem alloc]initWithTitle:@"Ready" style:UIBarButtonItemStylePlain target:self action:@selector(readyButtonAction:)];
    self.navigationItem.rightBarButtonItem = readyButton;
    
    UIBarButtonItem *aboutButton = [[UIBarButtonItem alloc]initWithTitle:@"About" style:UIBarButtonItemStylePlain target:self action:@selector(aboutButtonAction:)];
    self.navigationItem.leftBarButtonItem = aboutButton;

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
    [VWWUserDefaults setRenderAccelerometers:self.forcesSwitch.on];
    
    [self performSegueWithIdentifier:VWWSegueOptionsToSession sender:self];
}

-(void)aboutButtonAction:(id)sender{
    [self performSegueWithIdentifier:@"SegueOptionsToAbout" sender:self];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35.0;
}



@end







