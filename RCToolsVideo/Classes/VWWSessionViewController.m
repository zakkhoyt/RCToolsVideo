

#import "VWWSessionViewController.h"
@import Photos;
@import CoreLocation;
#import "PHAsset+Utility.h"
#import "UIView+RenderToImage.h"
#import "NSTimer+Blocks.h"
#import "GPUImage.h"
#import "MBProgressHUD.h"
#import "VWWHUDView.h"

@interface VWWSessionViewController ()
@property (strong, nonatomic) GPUImageVideoCamera *videoCamera;
@property (strong, nonatomic) GPUImageOutput<GPUImageInput> *filter;
@property (strong, nonatomic) GPUImageMovieWriter *movieWriter;
@property (strong, nonatomic) GPUImagePicture *sourcePicture;

@property (weak, nonatomic) IBOutlet UIView *toolsView;
@property (strong, nonatomic) GPUImageView *gpuImageView;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (nonatomic, strong) PHPhotoLibrary *photos;
@property (nonatomic, strong) NSURL *movieURL;
@property (nonatomic, strong) VWWHUDView *hudView;
@property (weak, nonatomic) IBOutlet UIButton *calibrateButton;
@end


@implementation VWWSessionViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.navigationController.navigationBarHidden = YES;
    
    __weak VWWSessionViewController *welf = self;
    VWWHUDView *hudView = [[[NSBundle mainBundle]loadNibNamed:@"VWWHUDView" owner:self options:nil] firstObject];
    hudView.frame = self.view.bounds;
    [hudView setNeedsDisplay];
    self.hudView = hudView;
    [self.view addSubview:self.hudView];
    [self.hudView setImageBlock:^(UIImage *image) {
        static NSUInteger counter = 1;
        NSLog(@"Counter: %lu", (unsigned long)counter++);
        if(counter == 1){
            [welf.filter useNextFrameForImageCapture];
            [welf.sourcePicture useNextFrameForImageCapture];
            welf.sourcePicture = [[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:YES];
            [welf.sourcePicture processImageWithCompletionHandler:^{
                [welf.sourcePicture addTarget:welf.filter];
            }];
        } else {
            [welf.sourcePicture updateCGImage:image.CGImage smoothlyScaleOutput:YES];
            [welf.sourcePicture processImage];
        }
    }];

    self.gpuImageView = [[GPUImageView alloc]initWithFrame:self.view.bounds];
    self.gpuImageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    self.toolsView.backgroundColor = [UIColor clearColor];
    self.recordButton.layer.cornerRadius = self.recordButton.frame.size.height / 2.0;
    self.calibrateButton.layer.cornerRadius = self.calibrateButton.frame.size.height / 2.0;
    self.exitButton.layer.cornerRadius = self.exitButton.frame.size.height / 2.0;
    
    
    
    [self.view addSubview:self.gpuImageView];
    [self.gpuImageView addSubview:self.toolsView];

    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
    
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    if(deviceOrientation == UIDeviceOrientationLandscapeRight){
        self.videoCamera.outputImageOrientation = UIInterfaceOrientationLandscapeLeft;
    } else {
        self.videoCamera.outputImageOrientation = UIInterfaceOrientationLandscapeRight;
    }
    
    [self setupFilters];
    
    [self.videoCamera startCameraCapture];
    
}

#pragma mark Private methods

-(void)setupFilters{
    
    self.filter = [[GPUImageOverlayBlendFilter alloc] init];
    [(GPUImageFilter*)self.filter setBackgroundColorRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [self.videoCamera addTarget:self.filter];
    
    UIImage *image = [self.hudView imageRepresentation];
    self.sourcePicture = [[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:YES];
    [self.sourcePicture processImage];
    [self.sourcePicture addTarget:self.filter];

    
//    [NSTimer scheduledTimerWithTimeInterval:1.0 block:^{
//        [self updateText];
//    } repeats:YES];
    
    
    [self.filter addTarget:self.gpuImageView];
}

//// This usually breaks with:
//// NSAssert(framebufferReferenceCount > 0, @"Tried to overrelease a framebuffer, did you forget to call -useNextFrameForImageCapture before using -imageFromCurrentFramebuffer?");
//-(void)updateText{
//    static NSUInteger counter = 1;
//    NSLog(@"Counter: %lu", (unsigned long)counter++);
//    
//    
//    UIImage *image = [self.hudView imageRepresentation];
////    UIImage *image = [UIImage imageNamed:@"RCToolsVideo_60"];
//    
//    if(counter == 1){
//        [self.filter useNextFrameForImageCapture];
//        [self.sourcePicture useNextFrameForImageCapture];
//        self.sourcePicture = [[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:YES];
//        [self.sourcePicture processImageWithCompletionHandler:^{
//            [self.sourcePicture addTarget:self.filter];
//        }];
//        
//    } else {
//        
//        [self.sourcePicture updateCGImage:image.CGImage smoothlyScaleOutput:YES];
//        [self.sourcePicture processImageWithCompletionHandler:^{
//            //            [self.sourcePicture addTarget:self.filter];
//        }];
//    }
//    
//}
//

#pragma mark IBActions

- (IBAction)recordButtonTouchUpInside:(UIButton*)sender {
    if([sender.titleLabel.text isEqualToString:@"Record"]){
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
        [self startRecording];
    } else {
        [sender setTitle:@"Record" forState:UIControlStateNormal];
        [self stopRecording];
    }
}
- (IBAction)calibrateButtonTouchUpInsde:(id)sender {
    [self.hudView calibrate];
}

- (IBAction)exitButtonTouchUpInside:(id)sender {
    //[self stopRecording];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Recording video to a file

-(void)startRecording{
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
    self.movieURL = [NSURL fileURLWithPath:pathToMovie];
    self.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:self.movieURL size:CGSizeMake(1280, 720)];
    self.movieWriter.encodingLiveVideo = YES;
    [self.filter addTarget:self.movieWriter];
    NSLog(@"Start recording");
    self.videoCamera.audioEncodingTarget = self.movieWriter;
    [self.movieWriter startRecording];

    [UIView animateWithDuration:0.3 animations:^{
        self.exitButton.alpha = 0.0;
    }];
}

-(void)stopRecording{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        hud.labelText = @"Encoding video...";
        [self.filter removeTarget:self.movieWriter];
        self.videoCamera.audioEncodingTarget = nil;
        [self.movieWriter finishRecording];
        NSLog(@"Movie completed");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [PHAsset saveVideoAtURL:self.movieURL location:nil completionBlock:^(PHAsset *asset, BOOL success) {
                if(success){
                    NSLog(@"Success adding video to Photos");
                    hud.labelText = @"Writing video...";
                    [asset saveToAlbum:@"RC Video" completionBlock:^(BOOL success) {
                        if(success){
                            NSLog(@"Success adding video to App Album");
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [UIView animateWithDuration:0.3 animations:^{
                                    self.exitButton.alpha = 1.0;
                                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                }];
                            });
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            });
                            NSLog(@"Error adding video to App Album");
                        }
                    }];
                } else {
                    NSLog(@"Error adding video to Photos");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    });
                }
            }];
        });
    }];
}
@end
