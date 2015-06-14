//
//  VWWSessionOptionsTableViewController.m
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 9/18/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWOptionsTableViewController.h"
#import "VWWPreviewViewController.h"
#import "VWWSessionViewController.h"
#import "VWW.h"
#import "VWWPermissionKit.h"


static NSString *VWWSegueOptionsToSession = @"VWWSegueOptionsToSession";
static NSString *VWWSegueOptionsToPreview = @"VWWSegueOptionsToPreview";

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


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSArray *permissions =
    @[
      [VWWCameraPermission permissionWithLabelText:@"We need to access your camera to record video."],
      [VWWMicrophonePermission permissionWithLabelText:@"We need to access your microphone to add audio to videos"],
      [VWWCoreLocationWhenInUsePermission permissionWithLabelText:@"For rendering your heading, altitude, speed, distance home, etc..."],
      [VWWPhotosPermission permissionWithLabelText:@"To save your videos to your Photos library."],
      ];
    
    
    [VWWPermissionsManager requirePermissions:permissions
                                        title:@"We'll need some things from you before we get started."
                           fromViewController:self
                                 resultsBlock:^(NSArray *permissions) {
                                     [permissions enumerateObjectsUsingBlock:^(VWWPermission *permission, NSUInteger idx, BOOL *stop) {
                                         NSLog(@"%@ - %@", permission.type, [permission stringForStatus]);
                                     }];
                                 }];

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

-(void)aboutButtonAction:(id)sender{
    [self performSegueWithIdentifier:@"SegueOptionsToAbout" sender:self];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35.0;
}



@end







