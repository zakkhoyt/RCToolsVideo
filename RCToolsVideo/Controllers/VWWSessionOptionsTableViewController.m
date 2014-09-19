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
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *hudOptions;
@property (nonatomic, strong) NSArray *resolutionOptions;
@end

@implementation VWWSessionOptionsTableViewController

-(BOOL)prefersStatusBarHidden{
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.hudOptions = @[@"Distance From Home",
                        @"Coordinates",
                        @"Coordinates + Speed",
                        @"Maximum Forces",
                        @"Compass"];
    
    self.resolutionOptions = @[@"352x288",
                               @"640x480",
                               @"1280x720",
                               @"1920x1080"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:VWWSegueOptionsToSession]){

    } else if([segue.identifier isEqualToString:VWWSegueOptionsToPreview]){
        
    }
}


#pragma mark IBAction
- (IBAction)readyButtonAction:(id)sender {
//    [self performSegueWithIdentifier:VWWSegueOptionsToSession sender:self];
    [self performSegueWithIdentifier:VWWSegueOptionsToPreview sender:self];
}


#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return self.hudOptions.count;
    } else if(section == 1){
        return self.resolutionOptions.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Option" forIndexPath:indexPath];
        cell.textLabel.text = self.hudOptions[indexPath.row];
        if(indexPath.row == [VWWUserDefaults hud]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    } else if(indexPath.section == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Option" forIndexPath:indexPath];
        cell.textLabel.text = self.resolutionOptions[indexPath.row];
        if(indexPath.row == [VWWUserDefaults resolution]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

        return cell;
    }
    return nil;
}

#pragma mark UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"HUD Mode";
    } else if(section == 1){
        return @"Resolution";
    }
    return @"";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if(indexPath.section == 0){
        for(NSUInteger index = 0; index < self.hudOptions.count; index++){
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:indexPath.section]];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [VWWUserDefaults setHUD:indexPath.row];
    } else if(indexPath.section == 1){
        for(NSUInteger index = 0; index < self.resolutionOptions.count; index++){
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:indexPath.section]];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [VWWUserDefaults setResolution:indexPath.row];
    }
//    [self performSegueWithIdentifier:VWWSegueOptionsToSession sender:self];
//    [self performSegueWithIdentifier:VWWSegueOptionsToPreview sender:self];
}

@end
