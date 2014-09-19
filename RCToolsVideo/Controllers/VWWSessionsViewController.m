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

//static NSString *VWWSegueSessionsToSession = @"VWWSegueSessionsToSession";
//static NSString *VWWSegueSessionsToVideo = @"VWWSegueSessionsToVideo";
static NSString *VWWSegueSessionsToOptions = @"VWWSegueSessionsToOptions";
@interface VWWSessionsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sessionURLs;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic, strong) NSIndexPath *compareIndexPath;
@end

@implementation VWWSessionsViewController


#pragma mark UIViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // This notification is fired when VWWFileController is finished writing a file.
    [[NSNotificationCenter defaultCenter] addObserverForName:VWWFileControllerSessionsChanged object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self loadSessions];
    }];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"RC Videos";
    
    [self loadSessions];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if([segue.identifier isEqualToString:VWWSegueSessionsToReview]){
//        VWWSessionReviewViewController *vc = segue.destinationViewController;
//        vc.session = sender;
//    }
}


#pragma mark Private

-(void)loadSessions{
//    self.sessionURLs = [[VWWFileController urlsForSessions] mutableCopy];
    [self.tableView reloadData];
    
}

-(void)deleteSessionAtIndexPath:(NSIndexPath*)indexPath{
    NSURL *sessionURL = self.sessionURLs[indexPath.row];
    [VWWFileController deleteFileAtURL:sessionURL];
    [self.sessionURLs removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

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
    return self.sessionURLs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    VWWSessionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VWWSessionTableViewCell" forIndexPath:indexPath];
//    NSURL *sessionURL = self.sessionURLs[indexPath.row];
//    cell.sessionURL = sessionURL;
//    return cell;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
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
//    UITableViewRowAction *compareRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Compare" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        VWW_LOG_DEBUG(@"Compare Action");
//        
//        // Mark as ready for compare
//        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        self.compareIndexPath = indexPath;
//        self.tableView.editing = NO;
//        
//    }];
//    compareRowAction.backgroundColor = [UIColor greenColor];
//
//    
//    return @[deleteRowAction, compareRowAction];

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
    

    
//    if(self.compareIndexPath == nil){
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        NSURL *sessionURL = self.sessionURLs[indexPath.row];
//        [VWWFileController sessionFromURL:sessionURL completionBlock:^(VWWSession *session) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            [self performSegueWithIdentifier:VWWSegueSessionsToReview sender:session];
//        }];
//    } else {
//        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        self.compareIndexPath = indexPath;
//        self.tableView.editing = NO;
//
//        VWW_LOG_DEBUG(@"Compare session at %ld an %ld", (long)self.compareIndexPath.row, indexPath.row);
//    }
    
}




@end
