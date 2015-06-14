//
//  VWWPermissionsManager.m
//
//
//  Created by Zakk Hoyt on 6/11/15.
//
//

#import "VWWPermissionsManager.h"
#import "VWWPermissionsViewController.h"
#import "VWWPermissionNotifications.h"

typedef void (^VWWPermissionsManagerEmptyBlock)();

@interface VWWPermissionsManager ()
@property (nonatomic, strong) NSArray *permissions;
@property (nonatomic, strong) VWWPermissionsManagerResultsBlock resultsBlock;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) VWWPermissionsViewController *permissionsViewController;
@property (nonatomic) BOOL required;
@end

@implementation VWWPermissionsManager

#pragma mark Public methods

+(void)optionPermissions:(NSArray*)permissions
                   title:(NSString*)title
      fromViewController:(UIViewController*)viewController
            resultsBlock:(VWWPermissionsManagerResultsBlock)resultsBlock {
    VWWPermissionsManager *permissionsManager = [[self alloc]init];
    [permissionsManager displayPermissions:permissions required:NO title:title fromViewController:viewController resultsBlock:resultsBlock];
}


+(void)requirePermissions:(NSArray*)permissions
                    title:(NSString*)title
       fromViewController:(UIViewController*)viewController
             resultsBlock:(VWWPermissionsManagerResultsBlock)resultsBlock {
    VWWPermissionsManager *permissionsManager = [[self alloc]init];
    [permissionsManager displayPermissions:permissions required:YES title:title fromViewController:viewController resultsBlock:resultsBlock];
}

+(void)readPermissions:(NSArray*)permissions resultsBlock:(VWWPermissionsManagerResultsBlock)resultsBlock{
    VWWPermissionsManager *permissionsManager = [[self alloc]init];
    [permissionsManager readPermissions:permissions resultsBlock:resultsBlock];
}

#pragma mark Private methods

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserverForName:VWWPermissionNotificationsPromptAction object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            dispatch_async(dispatch_get_main_queue(), ^{
                VWWPermission *permission = note.userInfo[VWWPermissionNotificationsPermissionKey];
                [permission presentSystemPromtWithCompletionBlock:^{
                    permission.status = VWWPermissionStatusUninitialized;
                    [permission updatePermissionStatus];
                    // TODO:
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self checkAllPermissionsSatisfied];
                    });
                }];
            });
        }];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self readPermissions];
            });
        }];
        
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL)checkAllPermissionsSatisfied{
    for(VWWPermission *permission in self.permissions) {
        if(permission.status != VWWPermissionStatusAuthorized){
            [self.permissionsViewController setCloseButtonTitle:nil];
            return NO;
        }
    }
    [self.permissionsViewController setCloseButtonTitle:@"Done"];
    return YES;
}

-(void)readPermissions{
    [self.permissions enumerateObjectsUsingBlock:^(VWWPermission *permission, NSUInteger idx, BOOL *stop) {
        [permission updatePermissionStatus];
    }];
}

-(void)showPermissionsViewControllerFromViewController:(UIViewController*)viewController{
    NSBundle* resourcesBundle = [NSBundle bundleForClass:[VWWPermissionsManager class]];
    self.permissionsViewController = [[resourcesBundle loadNibNamed:VWWPermissionsViewControllerIdentifier owner:self options:nil] firstObject];
    self.permissionsViewController.permissions = self.permissions;
    self.permissionsViewController.headerText = self.title;
    __weak VWWPermissionsManager *welf = self;
    [self.permissionsViewController setCompletionBlock:^{
        if(welf.resultsBlock){
            welf.resultsBlock(welf.permissions);
        }
    }];
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:self.permissionsViewController];
    [viewController presentViewController:nc animated:YES completion:NULL];
}


-(void)displayPermissions:(NSArray*)permissions
                 required:(BOOL)required
                    title:(NSString*)title
       fromViewController:(UIViewController*)viewController
             resultsBlock:(VWWPermissionsManagerResultsBlock)resultsBlock{
    
    _permissions = [permissions copy];
    _required = required;
    _title = title;
    _resultsBlock = resultsBlock;
    
    
    [self readPermissions];
    [self showPermissionsViewControllerFromViewController:viewController];
    // TODO: 
    [self checkAllPermissionsSatisfied];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self checkAllPermissionsSatisfied];
    });
    
}

-(void)readPermissions:(NSArray*)permissions resultsBlock:(VWWPermissionsManagerResultsBlock)resultsBlock{
    _permissions = permissions;
    [self readPermissions];
    
    // TODO: This is a quick workaround but it not a good permanent solution.
    // We coul change updatePermissionStatus to use a synchronous implementation, or add a callback to it.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        resultsBlock(_permissions);
    });
}

@end

