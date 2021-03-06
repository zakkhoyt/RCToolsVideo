//
//  VWWPermissionsViewController.m
//  
//
//  Created by Zakk Hoyt on 6/11/15.
//
//

#import "VWWPermissionsViewController.h"
#import "VWWPermissionTableViewCell.h"
#import "VWWPermissionsTableHeaderView.h"
#import "VWWPermission.h"

@interface VWWPermissionsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, strong) VWWPermissionsViewControllerEmptyBlock completionBlock;

@end

@implementation VWWPermissionsViewController

#pragma mark Private methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 76.0;
    NSBundle* bundle = [NSBundle bundleForClass:[VWWPermissionTableViewCell class]];
    [self.tableView registerNib:[UINib nibWithNibName:@"VWWPermissionTableViewCell" bundle:bundle] forCellReuseIdentifier:VWWPermissionTableViewCellIdentifier];
    
    
}

-(void)refresh{
    [self.tableView reloadData];
}

- (IBAction)privacyBarButtonAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (IBAction)doneBarButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
    if(_completionBlock){
        _completionBlock();
    }
}

#pragma mark Public methods
-(void)setCloseButtonTitle:(NSString*)title{
    if(title == nil){
        [self.navigationItem setRightBarButtonItem:nil];
    } else {
        [self.navigationItem setRightBarButtonItem:self.doneButton];
    }
}

-(void)setCompletionBlock:(VWWPermissionsViewControllerEmptyBlock)completionBlock{
    _completionBlock = completionBlock;
}

-(void)displayDeniedAlertForPermission:(VWWPermission*)permission{
    NSString *message = [NSString stringWithFormat:@"It looks like you denied access to %@. Please approve it in iOS Settings", permission.type];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Uh oh!" message:message preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"Now" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }]];
    
    [self presentViewController:ac animated:YES completion:NULL];

}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.permissions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VWWPermissionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VWWPermissionTableViewCellIdentifier];
    if(cell == nil){
        cell = [[VWWPermissionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VWWPermissionTableViewCellIdentifier];
    }
    cell.permission = self.permissions[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    NSBundle* bundle = [NSBundle bundleForClass:[VWWPermissionsTableHeaderView class]];
    VWWPermissionsTableHeaderView *view = [[bundle loadNibNamed:@"VWWPermissionsTableHeaderView" owner:self options:nil]firstObject];
    view.titleLabel.text = self.headerText;
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 70.0;
}




@end
