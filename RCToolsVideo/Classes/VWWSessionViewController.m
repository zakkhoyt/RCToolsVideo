

#import "VWWSessionViewController.h"
@import Photos;
@import CoreLocation;
#import "PHAsset+Utility.h"
#import "UIView+RenderToImage.h"
#import "NSTimer+Blocks.h"
#import "GPUImage.h"
#import "MBProgressHUD.h"
#import "VWWHUDContainerView.h"

@interface VWWSessionViewController ()
@property (strong, nonatomic) GPUImageVideoCamera *videoCamera;
@property (strong, nonatomic) GPUImageOutput<GPUImageInput> *filter;
@property (strong, nonatomic) GPUImageMovieWriter *movieWriter;
@property (strong, nonatomic) GPUImagePicture *sourcePicture;
@property (nonatomic, strong) GPUImageUIElement *uiElementInput;
@property (strong, nonatomic) GPUImageView *filterView;

@property (nonatomic) UIDeviceOrientation lastOrientation;

@property (weak, nonatomic) IBOutlet UIView *toolsView;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (nonatomic, strong) PHPhotoLibrary *photos;
@property (nonatomic, strong) NSURL *movieURL;
@property (nonatomic, strong) VWWHUDContainerView *hudView;
@property (weak, nonatomic) IBOutlet UIButton *calibrateButton;
@end


@implementation VWWSessionViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.navigationController.navigationBarHidden = YES;
    

    [self addOrientationMonitor];
    
    _hudView = [[[NSBundle mainBundle]loadNibNamed:@"VWWHUDContainerView" owner:self options:nil] firstObject];
    _hudView.frame = self.view.bounds;
    [_hudView setNeedsDisplay];
    self.hudView.transform = CGAffineTransformMakeRotation(M_PI);
    [self.view addSubview:self.hudView];

    self.filterView = [[GPUImageView alloc]initWithFrame:self.view.bounds];
    self.filterView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    self.toolsView.backgroundColor = [UIColor clearColor];
    self.recordButton.layer.cornerRadius = self.recordButton.frame.size.height / 2.0;
    self.calibrateButton.layer.cornerRadius = self.calibrateButton.frame.size.height / 2.0;
    self.exitButton.layer.cornerRadius = self.exitButton.frame.size.height / 2.0;
    
    
    
    [self.view addSubview:self.filterView];
    [self.filterView addSubview:self.toolsView];

    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    GPUImageOutput<GPUImageInput> *zhFilter = [GPUImageFilter new];
    GPUImageAlphaBlendFilter *blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
    blendFilter.mix = 1.0;
    
    _uiElementInput = [[GPUImageUIElement alloc] initWithView:self.hudView];
    
    [zhFilter addTarget:blendFilter];
    [_uiElementInput addTarget:blendFilter];
    
    __weak GPUImageUIElement *weakUIElementInput = _uiElementInput;
    [zhFilter setFrameProcessingCompletionBlock:^(GPUImageOutput * filter, CMTime frameTime){
        [weakUIElementInput update];
    }];
    
    
    
    [self.videoCamera addTarget:zhFilter];
    [blendFilter addTarget:_filterView];

    
    [self.videoCamera startCameraCapture];
    
}

#pragma mark Private methods

-(void)addOrientationMonitor {
    NSLog(@"%s", __FUNCTION__);
    _lastOrientation = [UIDevice currentDevice].orientation;
    [NSTimer scheduledTimerWithTimeInterval:0.1 block:^{
        
//        if(_isRecording) {
//            //            NSLog(@"Ignoring rotate because we are recording");
//            return;
//        }
        
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if(orientation != _lastOrientation) {
            _lastOrientation = [UIDevice currentDevice].orientation;
            [self updateUIForOrientation];
        }
    } repeats:YES];
    [self updateUIForOrientation];
}

-(void)updateUIForOrientation {
    NSLog(@"%s", __FUNCTION__);
    
//    [UIView animateWithDuration:0.3 animations:^{
//        [self updateResolutionLabel];
//        [self.rotatableViews enumerateObjectsUsingBlock:^(UIView  * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            switch (_lastOrientation) {
                case UIDeviceOrientationLandscapeLeft:{
                    
                    [_hudView removeFromSuperview];
                    
                    _hudView = [[[NSBundle mainBundle]loadNibNamed:@"VWWHUDView" owner:self options:nil] firstObject];
                    _hudView.frame = CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width);
                    [_hudView setNeedsDisplay];
                    self.hudView.transform = CGAffineTransformMakeRotation(M_PI);
                    [self.view addSubview:self.hudView];

                }
//                    obj.transform = CGAffineTransformMakeRotation(M_PI_2);
                    break;
                case UIDeviceOrientationLandscapeRight:
//                    obj.transform = CGAffineTransformMakeRotation(-M_PI_2);
                    break;
                case UIDeviceOrientationPortraitUpsideDown:
//                    obj.transform = CGAffineTransformMakeRotation(M_PI);
                    break;
                default:
//                    obj.transform = CGAffineTransformIdentity;
                    break;
            }
//        }];
//    }];
    
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
