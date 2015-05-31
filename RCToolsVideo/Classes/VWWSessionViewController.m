

//#import <QuartzCore/QuartzCore.h>
#import "VWWSessionViewController.h"
//#import "VWWSessionOptionsTableViewController.h"
////static inline double radians (double degrees) { return degrees * (M_PI / 180); }
//static NSString *VWWSegueOptionsToSession = @"VWWSegueOptionsToSession";
//static NSString *VWWSegueOptionsToPreview = @"VWWSegueOptionsToPreview";

@import Photos;
@import CoreLocation;
#import "PHAsset+Utility.h"
#import "UIView+RenderToImage.h"
#import "NSTimer+Blocks.h"
#import "GPUImage.h"
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
@end


@implementation VWWSessionViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.navigationController.navigationBarHidden = YES;
    
    self.hudView = [[VWWHUDView alloc]initWithFrame:self.view.bounds];
    self.gpuImageView = [[GPUImageView alloc]initWithFrame:self.view.bounds];
    self.gpuImageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    self.toolsView.backgroundColor = [UIColor clearColor];
    self.recordButton.layer.cornerRadius = self.recordButton.frame.size.height / 2.0;
    self.exitButton.layer.cornerRadius = self.exitButton.frame.size.height / 2.0;
    
    
    
    [self.view addSubview:self.gpuImageView];
    [self.gpuImageView addSubview:self.toolsView];

    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationLandscapeRight;
    
    [self setupFilters];
    
    [self.videoCamera startCameraCapture];
    
}

#pragma mark Private methods

-(void)setupFilters{
    
    self.filter = [[GPUImageOverlayBlendFilter alloc] init];
    [(GPUImageFilter*)self.filter setBackgroundColorRed:0.0 green:1.0 blue:0.0 alpha:1.0];
    [self.videoCamera addTarget:self.filter];
    
    UIImage *image = [self.hudView imageRepresentation];
    self.sourcePicture = [[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:YES];
    [self.sourcePicture processImage];
    [self.sourcePicture addTarget:self.filter];

    
    [NSTimer scheduledTimerWithTimeInterval:1.0 block:^{
        [self updateText];
    } repeats:YES];
    
    
    [self.filter addTarget:self.gpuImageView];
}

// This usually breaks with:
// NSAssert(framebufferReferenceCount > 0, @"Tried to overrelease a framebuffer, did you forget to call -useNextFrameForImageCapture before using -imageFromCurrentFramebuffer?");
-(void)updateText{
    static NSUInteger counter = 1;
    NSLog(@"Counter: %lu", (unsigned long)counter++);
    
    
    UIImage *image = [self.hudView imageRepresentation];
//    UIImage *image = [UIImage imageNamed:@"RCToolsVideo_60"];
    
    if(counter == 1){
        [self.filter useNextFrameForImageCapture];
        [self.sourcePicture useNextFrameForImageCapture];
        self.sourcePicture = [[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:YES];
        [self.sourcePicture processImageWithCompletionHandler:^{
            [self.sourcePicture addTarget:self.filter];
        }];
        
    } else {
        
        [self.sourcePicture updateCGImage:image.CGImage smoothlyScaleOutput:YES];
        [self.sourcePicture processImageWithCompletionHandler:^{
            //            [self.sourcePicture addTarget:self.filter];
        }];
    }
    
}


#pragma mark IBActions

- (IBAction)recordButtonTouchUpInside:(UIButton*)sender {
    if([sender.titleLabel.text isEqualToString:@"Rec"]){
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
        [self startRecording];
    } else {
        [sender setTitle:@"Rec" forState:UIControlStateNormal];
        [self stopRecording];
    }
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
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        [self.filter removeTarget:self.movieWriter];
        self.videoCamera.audioEncodingTarget = nil;
        [self.movieWriter finishRecording];
        NSLog(@"Movie completed");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [PHAsset saveVideoAtURL:self.movieURL location:nil completionBlock:^(PHAsset *asset, BOOL success) {
                if(success){
                    NSLog(@"Success adding video to Photos");
                    [asset saveToAlbum:@"LaserDot" completionBlock:^(BOOL success) {
                        if(success){
                            NSLog(@"Success adding video to App Album");
                        } else {
                            NSLog(@"Error adding video to App Album");
                        }
                        [UIView animateWithDuration:0.3 animations:^{
                            self.exitButton.alpha = 1.0;
                        }];

                    }];
                } else {
                    NSLog(@"Error adding video to Photos");
                }
            }];
        });
    }];
}


//@synthesize previewView;
//
//
//- (void)applicationDidBecomeActive:(NSNotification*)notifcation
//{
//    // For performance reasons, we manually pause/resume the session when saving a recording.
//    // If we try to resume the session in the background it will fail. Resume the session here as well to ensure we will succeed.
//    [videoProcessor resumeCaptureSession];
//}
//
////-(BOOL)prefersStatusBarHidden {
////    return YES;
////}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    [UIApplication sharedApplication].statusBarHidden = YES;
//    
//    // Initialize the class responsible for managing AV capture session and asset writer
//    videoProcessor = [[VWWVideoProcessor alloc] init];
//    videoProcessor.delegate = self;
//    
//    // Keep track of changes to the device orientation so we can update the video processor
//    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
//    [notificationCenter addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    
//    // Setup and start the capture session
//    [videoProcessor setupAndStartCaptureSession];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication]];
//    
//    oglView = [[VWWPreviewView alloc] initWithFrame:CGRectZero];
//    // Our interface is always in portrait.
//    oglView.transform = [videoProcessor transformFromCurrentVideoOrientationToOrientation:(AVCaptureVideoOrientation)UIInterfaceOrientationPortrait];
//    [previewView addSubview:oglView];
//    CGRect bounds = CGRectZero;
//    bounds.size = [self.previewView convertRect:self.previewView.bounds toView:oglView].size;
//    oglView.bounds = bounds;
//    oglView.center = CGPointMake(previewView.bounds.size.width/2.0, previewView.bounds.size.height/2.0);
//    
//    // Set up labels
//    shouldShowStats = NO;
//    self.statusSwitch.on = NO;
// 
//
//    [self.view bringSubviewToFront:self.toolbarView];
//
//}
//
//
//- (void)viewDidUnload
//{
//    [super viewDidUnload];
//    
//    [self cleanup];
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
//    timer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(updateLabels) userInfo:nil repeats:YES];
//}
//
//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    
//    [timer invalidate];
//    timer = nil;
//}
//
//
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
////    if([segue.identifier isEqualToString:VWWSegueSessionToOptions]){
////        VWWSessionOptionsTableViewController *vc = segue.destinationViewController;
////
////    }
//}
//
//// UIDeviceOrientationDidChangeNotification selector
//- (void)deviceOrientationDidChange
//{
//    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
//    // Don't update the reference orientation when the device orientation is face up/down or unknown.
//    if ( UIDeviceOrientationIsPortrait(orientation) || UIDeviceOrientationIsLandscape(orientation) )
//        [videoProcessor setReferenceOrientation:(AVCaptureVideoOrientation)orientation];
//    
//    if(orientation == UIDeviceOrientationPortrait){
//        [UIView animateWithDuration:0.2 animations:^{
//            self.rButton.transform = CGAffineTransformIdentity;
//            self.statusSwitch.transform = CGAffineTransformIdentity;
//            self.exitButton.transform = CGAffineTransformIdentity;
//        }];
//    } else if(orientation == UIDeviceOrientationPortraitUpsideDown){
//        [UIView animateWithDuration:0.2 animations:^{
//            self.rButton.transform = CGAffineTransformMakeRotation(M_PI);
//            self.statusSwitch.transform = CGAffineTransformMakeRotation(M_PI);
//            self.exitButton.transform = CGAffineTransformMakeRotation(M_PI);
//        }];
//    } else if(orientation == UIDeviceOrientationLandscapeLeft){
//        [UIView animateWithDuration:0.2 animations:^{
//            self.rButton.transform = CGAffineTransformMakeRotation(M_PI / 2.0);
//            self.statusSwitch.transform = CGAffineTransformMakeRotation(M_PI / 2.0);
//            self.exitButton.transform = CGAffineTransformMakeRotation(M_PI / 2.0);
//        }];
//    } else if(orientation == UIDeviceOrientationLandscapeRight){
//        [UIView animateWithDuration:0.2 animations:^{
//            self.rButton.transform = CGAffineTransformMakeRotation(-M_PI / 2.0);
//            self.statusSwitch.transform = CGAffineTransformMakeRotation(-M_PI / 2.0);
//            self.exitButton.transform = CGAffineTransformMakeRotation(-M_PI / 2.0);
//        }];
//    }
//}
//
//
//- (void)dealloc
//{
//    [self cleanup];
//    //	[super dealloc];
//}
//
//#pragma mark Private methods
//
//- (void)cleanup
//{
//    //	[oglView release];
//    oglView = nil;
//    
//    frameRateLabel = nil;
//    dimensionsLabel = nil;
//    typeLabel = nil;
//    
//    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
//    [notificationCenter removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
//    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
//    
//    [notificationCenter removeObserver:self name:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication]];
//    
//    // Stop and tear down the capture session
//    [videoProcessor stopAndTearDownCaptureSession];
//    videoProcessor.delegate = nil;
//    //    [videoProcessor release];
//}
//- (void)updateLabels
//{
//    // Lazy loading
//    if(frameRateLabel == nil){
//        frameRateLabel = [self labelWithText:@"" yPosition: (CGFloat) 10.0];
//        [previewView addSubview:frameRateLabel];
//    }
//    if(dimensionsLabel == nil){
//        dimensionsLabel = [self labelWithText:@"" yPosition: (CGFloat) 54.0];
//        [previewView addSubview:dimensionsLabel];
//    }
//    if(typeLabel == nil){
//        typeLabel = [self labelWithText:@"" yPosition: (CGFloat) 98.0];
//        [previewView addSubview:typeLabel];
//    }
//    
//	if (shouldShowStats) {
//		NSString *frameRateString = [NSString stringWithFormat:@"%.2f FPS ", [videoProcessor videoFrameRate]];
// 		frameRateLabel.text = frameRateString;
// 		[frameRateLabel setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.25]];
// 		
// 		NSString *dimensionsString = [NSString stringWithFormat:@"%d x %d ", [videoProcessor videoDimensions].width, [videoProcessor videoDimensions].height];
// 		dimensionsLabel.text = dimensionsString;
// 		[dimensionsLabel setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.25]];
// 		
// 		CMVideoCodecType type = [videoProcessor videoType];
// 		type = OSSwapHostToBigInt32( type );
// 		NSString *typeString = [NSString stringWithFormat:@"%.4s ", (char*)&type];
// 		typeLabel.text = typeString;
// 		[typeLabel setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.25]];
// 	}
// 	else {
// 		frameRateLabel.text = @"";
// 		[frameRateLabel setBackgroundColor:[UIColor clearColor]];
// 		
// 		dimensionsLabel.text = @"";
// 		[dimensionsLabel setBackgroundColor:[UIColor clearColor]];
// 		
// 		typeLabel.text = @"";
// 		[typeLabel setBackgroundColor:[UIColor clearColor]];
// 	}
//}
//
//- (UILabel *)labelWithText:(NSString *)text yPosition:(CGFloat)yPosition
//{
////    if([text isEqualToString:@""]) text = @"eh?";
//	CGFloat labelWidth = 200.0;
//	CGFloat labelHeight = 40.0;
//	CGFloat xPosition = 10;
//	CGRect labelFrame = CGRectMake(xPosition, yPosition, labelWidth, labelHeight);
//	UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
////	[label setFont:[UIFont systemFontOfSize:36]];
////	[label setLineBreakMode:NSLineBreakByWordWrapping];
////	[label setTextAlignment:NSTextAlignmentRight];
//	[label setTextColor:[UIColor whiteColor]];
//	[label setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.25]];
////	[[label layer] setCornerRadius: 4];
//	[label setText:text];
//	
////	return [label autorelease];
//    return label;
//}
//
//#pragma mark IBActions
//- (IBAction)exitButtonTouchUpInside:(UIButton *)sender {
//    [videoProcessor stopRecording];
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//
//- (IBAction)statusSwitchValueChanged:(UISwitch*)sender {
//    shouldShowStats = sender.on;
//}
//
//- (IBAction)toggleRecording:(id)sender 
//{
//	// Wait for the recording to start/stop before re-enabling the record button.
//	[[self rButton] setEnabled:NO];
//	
//	if ( [videoProcessor isRecording] ) {
//		// The recordingWill/DidStop delegate methods will fire asynchronously in response to this call
//		[videoProcessor stopRecording];
//	}
//	else {
//		// The recordingWill/DidStart delegate methods will fire asynchronously in response to this call
//        [videoProcessor startRecording];
//	}
//}
//
//
////- (IBAction)settingsButtonAction:(id)sender {
////    [self performSegueWithIdentifier:VWWSegueSession sender:self];
////}
//
//
//#pragma mark VWWVideoProcessorDelegate
//
//- (void)recordingWillStart
//{
//	dispatch_async(dispatch_get_main_queue(), ^{
//		[[self rButton] setEnabled:NO];	
//		[[self rButton] setTitle:@"Stop" forState:UIControlStateNormal];
//
//		// Disable the idle timer while we are recording
//		[UIApplication sharedApplication].idleTimerDisabled = YES;
//
//		// Make sure we have time to finish saving the movie if the app is backgrounded during recording
//		if ([[UIDevice currentDevice] isMultitaskingSupported])
//			backgroundRecordingID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{}];
//	});
//}
//
//- (void)recordingDidStart
//{
//	dispatch_async(dispatch_get_main_queue(), ^{
//		[[self rButton] setEnabled:YES];
//	});
//}
//
//- (void)recordingWillStop
//{
//	dispatch_async(dispatch_get_main_queue(), ^{
//		// Disable until saving to the camera roll is complete
//		[[self rButton] setTitle:@"Record" forState:UIControlStateNormal];
//		[[self rButton] setEnabled:NO];
//		
//		// Pause the capture session so that saving will be as fast as possible.
//		// We resume the sesssion in recordingDidStop:
//		[videoProcessor pauseCaptureSession];
//	});
//}
//
//- (void)recordingDidStop
//{
//	dispatch_async(dispatch_get_main_queue(), ^{
//		[[self rButton] setEnabled:YES];
//		
//		[UIApplication sharedApplication].idleTimerDisabled = NO;
//
//		[videoProcessor resumeCaptureSession];
//
//		if ([[UIDevice currentDevice] isMultitaskingSupported]) {
//			[[UIApplication sharedApplication] endBackgroundTask:backgroundRecordingID];
//			backgroundRecordingID = UIBackgroundTaskInvalid;
//		}
//	});
//}
//
//- (void)pixelBufferReadyForDisplay:(CVPixelBufferRef)pixelBuffer
//{
//	// Don't make OpenGLES calls while in the background.
//	if ( [UIApplication sharedApplication].applicationState != UIApplicationStateBackground )
//		[oglView displayPixelBuffer:pixelBuffer];
//}

@end
