//
//  VWWSessionsViewController.m
//  APM Logger
//
//  Created by Zakk Hoyt on 4/12/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWSessionsViewController.h"
#import "VWWFileController.h"
#import "MBProgressHUD.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "VWWSessionTableViewCell.h"

@import  MediaPlayer;
@import CoreLocation;

static NSString *VWWSegueSessionsToOptions = @"VWWSegueSessionsToOptions";


@interface VWWSessionsViewController () < UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sessions;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic, strong) NSIndexPath *compareIndexPath;
@property (nonatomic, strong) ALAssetsLibrary *library;
@end

@implementation VWWSessionsViewController


#pragma mark UIViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    self.library = [[ALAssetsLibrary alloc]init];
    
    [self loadSessions];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"RC Videos";
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if([segue.identifier isEqualToString:VWWSegueSessionsToVideo]){
//        VWWVideoViewController *vc = segue.destinationViewController;
//        vc.url = sender;
//    }
}


#pragma mark Private

-(void)loadSessions{
//
//    [self.tableView reloadData];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self.library enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            NSString *groupName = [group valueForProperty:ALAssetsGroupPropertyName];
            if([groupName isEqualToString:VWW_ALBUM_NAME]){
                self.sessions = [@[]mutableCopy];
                [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    if(result){
                        [self.sessions addObject:result];
                    }
                }];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
                group = nil;
                *stop = YES;
            }
        } failureBlock:^(NSError *error) {
            VWW_LOG_ERROR(@"Failed to load videos");
        }];
    });
    

    [self.tableView reloadData];
    
}

-(void)deleteSessionAtIndexPath:(NSIndexPath*)indexPath{
//    ALAsset *session = self.sessions[indexPath.row];
//    [self.sessions removeObjectAtIndex:indexPath.row];
//    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [[[UIAlertView alloc]initWithTitle:@"How to delete" message:@"To delete a video, open the Photos app, navigate to RC Video and then press the trash can icon" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil]show];
}



#pragma mark IBActions


- (IBAction)deleteButtonAction:(id)sender {
    self.tableView.editing = !self.tableView.editing;
}
- (IBAction)addButtonAction:(id)sender {
    [self performSegueWithIdentifier:VWWSegueSessionsToOptions sender:self];
}


#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sessions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VWWSessionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VWWSessionTableViewCell" forIndexPath:indexPath];
    ALAsset *asset = self.sessions[indexPath.row];
    cell.thumbnailImageView.image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
    
    NSDate *date = [asset valueForProperty:ALAssetPropertyDate];
    CLLocation *location = [asset valueForProperty:ALAssetPropertyLocation];
    NSNumber *duration = [asset valueForProperty:ALAssetPropertyDuration];
    
    cell.resolutionLabel.text = [NSString stringWithFormat:@"%ldx%ld", (long)asset.defaultRepresentation.dimensions.width, (long)asset.defaultRepresentation.dimensions.height];
    cell.locationLabel.text = @"";
    cell.dateLabel.text = [VWWUtilities stringFromDateAndTime:date];
    cell.durationLabel.text = [NSString stringWithFormat:@"%lds", (long)duration.integerValue];
    [VWWUtilities stringThoroughfareFromLatitude:location.coordinate.latitude longitude:location.coordinate.longitude completionBlock:^(NSString *string) {
        cell.locationLabel.text = string;
    }];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ALAsset *asset = self.sessions[indexPath.row];
    CGFloat height = self.view.bounds.size.width * asset.defaultRepresentation.dimensions.height / asset.defaultRepresentation.dimensions.width;
    return height;
}


#pragma mark UITableView delete stuff

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [self deleteSessionAtIndexPath:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

#ifdef __IPHONE_8_0
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        VWW_LOG_DEBUG(@"Delete Action");
        [self deleteSessionAtIndexPath:indexPath];
        
        
    }];
    deleteRowAction.backgroundColor = [UIColor redColor];
    return @[deleteRowAction];
}
#endif

#pragma mark UITableView move stuff
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
}


#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ALAsset *asset = self.sessions[indexPath.row];
//    [self performSegueWithIdentifier:VWWSegueSessionsToVideo sender:asset.defaultRepresentation.url];
    
    MPMoviePlayerViewController *playerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:asset.defaultRepresentation.url];
    [self presentMoviePlayerViewControllerAnimated:playerVC];
    playerVC.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    [playerVC.moviePlayer play];
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.tableView setEditing:NO animated:YES];
}



@end
