//
//  VWWAssetsLibraryController.h
//  Throwback
//
//  Created by Zakk Hoyt on 7/10/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VWW.h"

@import AssetsLibrary;

@interface VWWAssetsLibraryController : NSObject

+(VWWAssetsLibraryController*)sharedInstance;

-(void)saveVideoAtURLToAppAlbum:(NSURL*)url
                       metadata:(NSDictionary *)metadata
                     completion:(VWWAssetsLibraryControllerURLErrorBlock)completion;
-(void)saveImageToAppAlbum:(UIImage*)image
                    metadata:(NSDictionary *)metadata
                  completion:(VWWAssetsLibraryControllerURLErrorBlock)completion;
-(void)assetsWithCompletionBlock:(VWWArrayBlock)completionBlock;
-(void)cameraImagesWithCompletionBlock:(VWWArrayBlock)completionBlock;




@end
