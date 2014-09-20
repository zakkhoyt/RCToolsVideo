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

static NSString *VWWSessionTableViewCellTitleKey = @"title";
static NSString *VWWSessionTableViewCellTypeType = @"type";

typedef enum {
    VWWSessionTableViewCellTextType = 0,
    VWWSessionTableViewCellSwitchType = 1,
    VWWSessionTableViewCellButtonType = 2
} VWWSessionTableViewCellType;

static NSString *VWWSegueOptionsToSession = @"VWWSegueOptionsToSession";
static NSString *VWWSegueOptionsToPreview = @"VWWSegueOptionsToPreview";

@interface VWWSessionOptionsTableViewController () <VWWSwitchTableViewCellDelegate, VWWButtonTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *hudOptions;
@property (nonatomic, strong) NSArray *resolutionOptions;
@end

@implementation VWWSessionOptionsTableViewController

//-(BOOL)prefersStatusBarHidden{
//    return NO;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.hudOptions = @[@{VWWSessionTableViewCellTitleKey : @"Accelermeters",
                          VWWSessionTableViewCellTypeType : @(VWWSessionTableViewCellSwitchType)},
                        @{VWWSessionTableViewCellTitleKey : @"Gyrosopes",
                         VWWSessionTableViewCellTypeType : @(VWWSessionTableViewCellSwitchType)},
                        @{VWWSessionTableViewCellTitleKey : @"Accelermeter Min/Max",
                         VWWSessionTableViewCellTypeType : @(VWWSessionTableViewCellSwitchType)},
                        @{VWWSessionTableViewCellTitleKey : @"Gyrosope Min/Max",
                          VWWSessionTableViewCellTypeType : @(VWWSessionTableViewCellSwitchType)},
                        @{VWWSessionTableViewCellTitleKey : @"Heading",
                          VWWSessionTableViewCellTypeType: @(VWWSessionTableViewCellSwitchType)},
                        @{VWWSessionTableViewCellTitleKey : @"Altitude",
                          VWWSessionTableViewCellTypeType: @(VWWSessionTableViewCellSwitchType)},
                        @{VWWSessionTableViewCellTitleKey : @"Distance From Home",
                          VWWSessionTableViewCellTypeType : @(VWWSessionTableViewCellSwitchType)},
                        @{VWWSessionTableViewCellTitleKey : @"Top Speed",
                          VWWSessionTableViewCellTypeType : @(VWWSessionTableViewCellSwitchType)},
                        @{VWWSessionTableViewCellTitleKey : @"Coordinates",
                          VWWSessionTableViewCellTypeType : @(VWWSessionTableViewCellSwitchType)},
                        @{VWWSessionTableViewCellTitleKey : @"Text Drop Shadow",
                          VWWSessionTableViewCellTypeType : @(VWWSessionTableViewCellSwitchType)},
                        @{VWWSessionTableViewCellTitleKey : @"Compass Indicator",
                          VWWSessionTableViewCellTypeType : @(VWWSessionTableViewCellSwitchType)},
                        @{VWWSessionTableViewCellTitleKey : @"Attitude Indicator",
                          VWWSessionTableViewCellTypeType : @(VWWSessionTableViewCellSwitchType)}];
    
    
    self.resolutionOptions = @[@{VWWSessionTableViewCellTitleKey : @"352x288",
                                 VWWSessionTableViewCellTypeType : @(VWWSessionTableViewCellTextType)},
                               @{VWWSessionTableViewCellTitleKey : @"640x480",
                                 VWWSessionTableViewCellTypeType : @(VWWSessionTableViewCellTextType)},
                               @{VWWSessionTableViewCellTitleKey : @"1280x720",
                                 VWWSessionTableViewCellTypeType : @(VWWSessionTableViewCellTextType)},
                               @{VWWSessionTableViewCellTitleKey : @"1920x1080",
                                 VWWSessionTableViewCellTypeType : @(VWWSessionTableViewCellTextType)}];
    
    [self addGestureRecognizers];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
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

#pragma mark Private methods
-(void)addGestureRecognizers{
//    UIView *myTransparentGestureView = [[UIView alloc] initWithFrame:CGRectMake(0,0,20,20)];
//    UILabel *nextLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,40,30)];
//    nextLabel.text = @"Ready";
//    nextLabel.backgroundColor = [UIColor redColor];
//    nextLabel.textColor = self.view.tintColor;
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressHandler:)];
    [self.navigationController.navigationBar addGestureRecognizer:longPressGesture];
//    [myTransparentGestureView addGestureRecognizer:longPressGesture];
//
//    [self.navigationItem.rightBarButtonItem setCustomView:myTransparentGestureView];
//    // Or you could set it like this
//    // self.navigationItem.backBarButtonItem.customView = myTransparentGestureView;
}

#pragma mark IBAction

-(void)longPressHandler:(UILongPressGestureRecognizer*)sender{
    VWW_LOG_TRACE;
    if (sender.state == UIGestureRecognizerStateBegan) {
        // set a default rectangle in case we don't find the back button for some reason
        CGRect rect = CGRectMake(self.view.bounds.size.width - 100, 20, 100, 44);

        // iterate through the subviews looking for something that looks like it might be the right location to be the back button
        for (UIView *subview in self.navigationController.navigationBar.subviews) {
            if (subview.frame.origin.x > self.view.bounds.size.width - 100) {
                rect = subview.frame;
                break;
            }
        }
        
        // ok, let's get the point of the long press
        CGPoint longPressPoint = [sender locationInView:self.navigationController.navigationBar];
        
        // if the long press point in the rectangle then do whatever
        if (CGRectContainsPoint(rect, longPressPoint)){
            [self performSegueWithIdentifier:VWWSegueOptionsToSession sender:self];
        }
            
    }
}
- (IBAction)readyButtonAction:(id)sender {
//
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


-(VWWSwitchTableViewCell*)switchTableViewCellFromDictionary:(NSDictionary*)dictionary{
    VWWSwitchTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"VWWSwitchTableViewCell"];
    cell.titleLabel.text = dictionary[VWWSessionTableViewCellTitleKey];
    cell.delegate = self;
    return cell;
}

-(VWWButtonTableViewCell*)buttonTableViewCellFromDictionary:(NSDictionary*)dictionary{
    VWWButtonTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"VWWButtonTableViewCell"];
    cell.titleLabel.text = dictionary[VWWSessionTableViewCellTitleKey];
    [cell.actionButton setTitle:@"Pick" forState:UIControlStateNormal];
    cell.delegate = self;
    return cell;
}

-(VWWTextTableViewCell*)textTableViewCellFromDictionary:(NSDictionary*)dictionary{
    VWWTextTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"VWWTextTableViewCell"];
    cell.titleLabel.text = dictionary[VWWSessionTableViewCellTitleKey];
    return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dictionary = nil;
    if(indexPath.section == 0){
        dictionary = self.hudOptions[indexPath.row];
    } else if(indexPath.section == 1){
        dictionary = self.resolutionOptions[indexPath.row];
    }
    
    
//    NSInteger type = ((NSNumber*)dictionary[VWWSessionTableViewCellTypeType]).integerValue;
//    UITableViewCell *cell = nil;
//    if(type == VWWSessionTableViewCellTextType){
//        cell = [self textTableViewCellFromDictionary:dictionary];
//    } else if(type == VWWSessionTableViewCellSwitchType){
//        cell = [self switchTableViewCellFromDictionary:dictionary];
//    } else if(type == VWWSessionTableViewCellButtonType){
//        cell = [self buttonTableViewCellFromDictionary:dictionary];
//    }

    if(indexPath.section == 0){
        if(indexPath.row == 0){
            VWWSwitchTableViewCell *cell = [self switchTableViewCellFromDictionary:dictionary];
            cell.optionSwitch.on = [VWWUserDefaults renderAccelerometers];
            return cell;
        } else if(indexPath.row == 1){
            VWWSwitchTableViewCell *cell = [self switchTableViewCellFromDictionary:dictionary];
            cell.optionSwitch.on = [VWWUserDefaults renderGyroscopes];
            return cell;
        } else if(indexPath.row == 2){
            VWWSwitchTableViewCell *cell = [self switchTableViewCellFromDictionary:dictionary];
            cell.optionSwitch.on = [VWWUserDefaults renderAccelerometerLimits];
            return cell;
        } else if(indexPath.row == 3){
            VWWSwitchTableViewCell *cell = [self switchTableViewCellFromDictionary:dictionary];
            cell.optionSwitch.on = [VWWUserDefaults renderGyroscopeLimits];
            return cell;
        } else if(indexPath.row == 4){
            VWWSwitchTableViewCell *cell = [self switchTableViewCellFromDictionary:dictionary];
            cell.optionSwitch.on = [VWWUserDefaults renderHeading];
            return cell;
        } else if(indexPath.row == 5){
            VWWSwitchTableViewCell *cell = [self switchTableViewCellFromDictionary:dictionary];
            cell.optionSwitch.on = [VWWUserDefaults renderAltitude];
            return cell;
        } else if(indexPath.row == 6){
            VWWSwitchTableViewCell *cell = [self switchTableViewCellFromDictionary:dictionary];
            cell.optionSwitch.on = [VWWUserDefaults renderDistanceFromHome];
            return cell;
        } else if(indexPath.row == 7){
            VWWSwitchTableViewCell *cell = [self switchTableViewCellFromDictionary:dictionary];
            cell.optionSwitch.on = [VWWUserDefaults renderSpeed];
            return cell;
        } else if(indexPath.row == 8){
            VWWSwitchTableViewCell *cell = [self switchTableViewCellFromDictionary:dictionary];
            cell.optionSwitch.on = [VWWUserDefaults renderCoordinates];
            return cell;
        } else if(indexPath.row == 9){
            VWWSwitchTableViewCell *cell = [self switchTableViewCellFromDictionary:dictionary];
            cell.optionSwitch.on = [VWWUserDefaults renderDropShadow];
            return cell;
        } else if(indexPath.row == 10){
            VWWSwitchTableViewCell *cell = [self switchTableViewCellFromDictionary:dictionary];
            cell.optionSwitch.on = [VWWUserDefaults renderCompassIndicator];
            return cell;
        } else if(indexPath.row == 11){
            VWWSwitchTableViewCell *cell = [self switchTableViewCellFromDictionary:dictionary];
            cell.optionSwitch.on = [VWWUserDefaults renderAttitudeIndicator];
            return cell;
        }
    } else if(indexPath.section == 1){
        if(indexPath.row == [VWWUserDefaults resolution]){
            VWWTextTableViewCell *cell = [self textTableViewCellFromDictionary:dictionary];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            return cell;
        } else {
            VWWTextTableViewCell *cell = [self textTableViewCellFromDictionary:dictionary];
            cell.accessoryType = UITableViewCellAccessoryNone;
            return cell;
        }
    }
    
    VWW_LOG_CRITICAL(@"Should never reach this default case");
    return [[UITableViewCell alloc]init];
}

#pragma mark UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"HUD Options";
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


#pragma mark  VWWSwitchTableViewCellDelegate
-(void)switchTableViewCell:(VWWSwitchTableViewCell*)sender switchValueChanged:(BOOL)on{
    VWW_LOG_TRACE;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            [VWWUserDefaults setRenderAccelerometers:on];
        } else if(indexPath.row == 1){
            [VWWUserDefaults setRenderGyroscopes:on];
        } else if(indexPath.row == 2){
            [VWWUserDefaults setRenderAccelerometerLimits:on];
        } else if(indexPath.row == 3){
            [VWWUserDefaults setRenderGyroscopeLimits:on];
        } else if(indexPath.row == 4){
            [VWWUserDefaults setRenderHeading:on];
        } else if(indexPath.row == 5){
            [VWWUserDefaults setRenderAltitude:on];
        } else if(indexPath.row == 6){
            [VWWUserDefaults setRenderDistanceFromHome:on];
        } else if(indexPath.row == 7){
            [VWWUserDefaults setRenderSpeed:on];
        } else if(indexPath.row == 8){
            [VWWUserDefaults setRenderCoordinates:on];
        } else if(indexPath.row == 9){
            [VWWUserDefaults setRenderDropShadow:on];
        } else if(indexPath.row == 10){
            [VWWUserDefaults setRenderCompassIndicator:on];
        } else if(indexPath.row == 11){
            [VWWUserDefaults setRenderAttitudeIndicator:on];
        }
    }
}

#pragma mark VWWButtonTableViewCellDelegate
-(void)buttonTableViewCellActionButtonTouchUpInside:(VWWButtonTableViewCell*)sender{
    VWW_LOG_TRACE;
}



@end
