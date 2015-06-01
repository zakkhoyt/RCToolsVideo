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
#import "VWWSwitchTableViewCell.h"
#import "VWWTextTableViewCell.h"
#import "VWWButtonTableViewCell.h"


static NSString *VWWSegueOptionsToSession = @"VWWSegueOptionsToSession";
static NSString *VWWSegueOptionsToPreview = @"VWWSegueOptionsToPreview";

@interface VWWSessionOptionsTableViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISwitch *headingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *altitudeSeitch;
@property (weak, nonatomic) IBOutlet UISwitch *distanceHomeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *speedSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *coordinateSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *dateSwitch;
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
}


- (void)readyButtonAction:(id)sender {
    
    [VWWUserDefaults setRenderHeading:self.headingSwitch.on];
    [VWWUserDefaults setRenderAltitude:self.altitudeSeitch.on];
    [VWWUserDefaults setRenderDistanceFromHome:self.distanceHomeSwitch.on];
    [VWWUserDefaults setRenderSpeed:self.speedSwitch.on];
    [VWWUserDefaults setRenderCoordinates:self.coordinateSwitch.on];
    [VWWUserDefaults setRenderDate:self.dateSwitch.on];
    
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [ac addAction:[UIAlertAction actionWithTitle:@"Preview" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self performSegueWithIdentifier:VWWSegueOptionsToPreview sender:self];
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"Video" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self performSegueWithIdentifier:VWWSegueOptionsToSession sender:self];
    }]];
    
    [self presentViewController:ac animated:YES completion:NULL];

}

- (IBAction)headingSwitchValueChanged:(id)sender {
}
- (IBAction)altitudeSwitchValueChanged:(id)sender {
}
- (IBAction)distanceHomeSwitchValueChanged:(id)sender {
}
- (IBAction)speedSwitchValueChanged:(id)sender {
}
- (IBAction)coordinatesSwitchValueChanged:(id)sender {
}
- (IBAction)dateSwitch:(id)sender {
}

@end







