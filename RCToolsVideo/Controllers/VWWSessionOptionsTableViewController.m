//
//  VWWSessionOptionsTableViewController.m
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 9/18/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWSessionOptionsTableViewController.h"

@interface VWWSessionOptionsTableViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *options;
@end

@implementation VWWSessionOptionsTableViewController

-(BOOL)prefersStatusBarHidden{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.options = [NSArray arrayWithObjects:@"HUD one", @"HUD two", @"HUD three", nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    VWWSessionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VWWSessionTableViewCell" forIndexPath:indexPath];
    //    NSURL *sessionURL = self.sessionURLs[indexPath.row];
    //    cell.sessionURL = sessionURL;
    //    return cell;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Option" forIndexPath:indexPath];
    cell.textLabel.text = self.options[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}



@end
