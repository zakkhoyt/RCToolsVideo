//
//  VWWAssetsLibraryController.m
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 7/10/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWAssetsLibraryController.h"


static NSString *kAppAlbumName = @"RC Video";

@interface VWWAssetsLibraryController ()
@property (nonatomic, strong) ALAssetsLibrary *library;
@property (nonatomic, strong) ALAssetsGroup *appAlbumGroup;
@end


@implementation VWWAssetsLibraryController


+(VWWAssetsLibraryController *)sharedInstance{
    static VWWAssetsLibraryController *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[VWWAssetsLibraryController alloc]init];
    });
    return instance;
}


- (id)init {
    self = [super init];
    if(self){
        _library = [[ALAssetsLibrary alloc]init];
    }
    return self;
}


-(void)assetsWithCompletionBlock:(VWWArrayBlock)completionBlock{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self ensureAppAlbumExists];
        NSMutableArray *assets = [@[]mutableCopy];
        [self.appAlbumGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if(result){
                [assets addObject:result];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(assets);
        });
    });
    
}

-(void)cameraImagesWithCompletionBlock:(VWWArrayBlock)completionBlock{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self ensureAppAlbumExists];
        NSMutableArray *assets = [@[]mutableCopy];
        [self.library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            [self.appAlbumGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if(result){
                    [assets addObject:result];
                }
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(assets);
            });
            
        } failureBlock:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(assets);
            });
        }];
    });
}

-(void)ensureAppAlbumExists{
    __block BOOL complete = NO;
    // Iterate the asset groups to find app album and record the URL. If it doesn't exist, create it.
    __weak VWWAssetsLibraryController *weakSelf = self;
    [self.library enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        NSString *groupName = [group valueForProperty:ALAssetsGroupPropertyName];
        if([groupName isEqualToString:kAppAlbumName]){
            weakSelf.appAlbumGroup = group;
            NSLog(@"Found App Album. Group = %@", weakSelf.appAlbumGroup);
            *stop = YES;
            complete = YES;
            return;
        }
        
        if(group == nil && weakSelf.appAlbumGroup == nil){
            [self.library addAssetsGroupAlbumWithName:kAppAlbumName resultBlock:^(ALAssetsGroup *group) {
                if(group){
                    weakSelf.appAlbumGroup = group;
                    NSLog(@"Created App Album. Group = %@", weakSelf.appAlbumGroup);
                } else{
//                    NSLog(@"Not App Album. Group = %@", weakSelf.appAlbumGroup);
                }
                complete = YES;
            } failureBlock:^(NSError *error) {
                weakSelf.appAlbumGroup = nil;
                NSLog(@"***** ERROR! Failed to create App Album Group");
                complete = YES;
            }];
            
        }
        
    } failureBlock:^(NSError *error) {
        NSLog(@"***** ERROR! Failed to create App Album because of access permissions");
        complete = YES;
    }];
    
    
    
    while (!complete) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}


-(void)saveVideoAtURLToAppAlbum:(NSURL*)url
                  metadata:(NSDictionary *)metadata
                completion:(VWWAssetsLibraryControllerURLErrorBlock)completion{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self ensureAppAlbumExists];
        
        // Save to camera roll
        [self.library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error) {
            if(assetURL){
                [self.library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                    if(asset){
                        [self.appAlbumGroup addAsset:asset];
                        NSLog(@"Wrote photo into App Album");
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(assetURL, error);
                        });
                    }
                } failureBlock:^(NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(assetURL, error);
                    });
                }];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(assetURL, error);
                });
                
            }
            
            
        }];
    });
    
}


-(void)saveImageToAppAlbum:(UIImage*)image
                    metadata:(NSDictionary *)metadata
                  completion:(VWWAssetsLibraryControllerURLErrorBlock)completion{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self ensureAppAlbumExists];
        
        // Save to camera roll
        [self.library writeImageToSavedPhotosAlbum:image.CGImage
                                          metadata:metadata
                                   completionBlock:^(NSURL *assetURL, NSError *error){
                                       
                                       if(assetURL){
                                           [self.library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                                               if(asset){
                                                   [self.appAlbumGroup addAsset:asset];
                                                   NSLog(@"Wrote photo into App Album");
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       completion(assetURL, error);
                                                   });
                                               }
                                           } failureBlock:^(NSError *error) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   completion(assetURL, error);
                                               });
                                           }];
                                       } else {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               completion(assetURL, error);
                                           });

                                       }
                                       
                                       
                                   }];
    });
    
}






@end
