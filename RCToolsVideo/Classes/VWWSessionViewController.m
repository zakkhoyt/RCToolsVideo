

#import <QuartzCore/QuartzCore.h>
#import "VWWSessionViewController.h"
#import "VWWSessionOptionsTableViewController.h"
//static inline double radians (double degrees) { return degrees * (M_PI / 180); }
static NSString *VWWSegueOptionsToSession = @"VWWSegueOptionsToSession";
static NSString *VWWSegueOptionsToPreview = @"VWWSegueOptionsToPreview";

@interface VWWSessionViewController ()
@property (weak, nonatomic) IBOutlet UIButton *rButton;
@property (weak, nonatomic) IBOutlet UIButton *sButton;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIView *toolbarView;

@end


@implementation VWWSessionViewController

@synthesize previewView;
@synthesize recordButton;

- (void)applicationDidBecomeActive:(NSNotification*)notifcation
{
    // For performance reasons, we manually pause/resume the session when saving a recording.
    // If we try to resume the session in the background it will fail. Resume the session here as well to ensure we will succeed.
    [videoProcessor resumeCaptureSession];
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    // Initialize the class responsible for managing AV capture session and asset writer
    videoProcessor = [[VWWVideoProcessor alloc] init];
    videoProcessor.delegate = self;
    
    // Keep track of changes to the device orientation so we can update the video processor
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    // Setup and start the capture session
    [videoProcessor setupAndStartCaptureSession];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication]];
    
    oglView = [[VWWPreviewView alloc] initWithFrame:CGRectZero];
    // Our interface is always in portrait.
    oglView.transform = [videoProcessor transformFromCurrentVideoOrientationToOrientation:(AVCaptureVideoOrientation)UIInterfaceOrientationPortrait];
    [previewView addSubview:oglView];
    CGRect bounds = CGRectZero;
    bounds.size = [self.previewView convertRect:self.previewView.bounds toView:oglView].size;
    oglView.bounds = bounds;
    oglView.center = CGPointMake(previewView.bounds.size.width/2.0, previewView.bounds.size.height/2.0);
    
    // Set up labels
    shouldShowStats = YES;
    
    frameRateLabel = [self labelWithText:@"" yPosition: (CGFloat) 10.0];
    [previewView addSubview:frameRateLabel];
    
    dimensionsLabel = [self labelWithText:@"" yPosition: (CGFloat) 54.0];
    [previewView addSubview:dimensionsLabel];
    
    typeLabel = [self labelWithText:@"" yPosition: (CGFloat) 98.0];
    [previewView addSubview:typeLabel];
    
    [self.view bringSubviewToFront:self.toolbar];
    [self.view bringSubviewToFront:self.toolbarView];

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self cleanup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(updateLabels) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [timer invalidate];
    timer = nil;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if([segue.identifier isEqualToString:VWWSegueSessionToOptions]){
//        VWWSessionOptionsTableViewController *vc = segue.destinationViewController;
//
//    }
}

// UIDeviceOrientationDidChangeNotification selector
- (void)deviceOrientationDidChange
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    // Don't update the reference orientation when the device orientation is face up/down or unknown.
    if ( UIDeviceOrientationIsPortrait(orientation) || UIDeviceOrientationIsLandscape(orientation) )
        [videoProcessor setReferenceOrientation:(AVCaptureVideoOrientation)orientation];
    
    if(orientation == UIDeviceOrientationPortrait){
        [UIView animateWithDuration:0.2 animations:^{
            self.rButton.transform = CGAffineTransformIdentity;
            self.sButton.transform = CGAffineTransformIdentity;
        }];
    } else if(orientation == UIDeviceOrientationPortraitUpsideDown){
        [UIView animateWithDuration:0.2 animations:^{
            self.rButton.transform = CGAffineTransformMakeRotation(M_PI);
            self.sButton.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    } else if(orientation == UIDeviceOrientationLandscapeLeft){
        [UIView animateWithDuration:0.2 animations:^{
            self.rButton.transform = CGAffineTransformMakeRotation(M_PI / 2.0);
            self.sButton.transform = CGAffineTransformMakeRotation(M_PI / 2.0);
        }];
    } else if(orientation == UIDeviceOrientationLandscapeRight){
        [UIView animateWithDuration:0.2 animations:^{
            self.rButton.transform = CGAffineTransformMakeRotation(-M_PI / 2.0);
            self.sButton.transform = CGAffineTransformMakeRotation(-M_PI / 2.0);
        }];
    }
}


- (void)dealloc
{
    [self cleanup];
    //	[super dealloc];
}

#pragma mark Private methods

- (void)cleanup
{
    //	[oglView release];
    oglView = nil;
    
    frameRateLabel = nil;
    dimensionsLabel = nil;
    typeLabel = nil;
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    
    [notificationCenter removeObserver:self name:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication]];
    
    // Stop and tear down the capture session
    [videoProcessor stopAndTearDownCaptureSession];
    videoProcessor.delegate = nil;
    //    [videoProcessor release];
}
- (void)updateLabels
{
	if (shouldShowStats) {
		NSString *frameRateString = [NSString stringWithFormat:@"%.2f FPS ", [videoProcessor videoFrameRate]];
 		frameRateLabel.text = frameRateString;
 		[frameRateLabel setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.25]];
 		
 		NSString *dimensionsString = [NSString stringWithFormat:@"%d x %d ", [videoProcessor videoDimensions].width, [videoProcessor videoDimensions].height];
 		dimensionsLabel.text = dimensionsString;
 		[dimensionsLabel setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.25]];
 		
 		CMVideoCodecType type = [videoProcessor videoType];
 		type = OSSwapHostToBigInt32( type );
 		NSString *typeString = [NSString stringWithFormat:@"%.4s ", (char*)&type];
 		typeLabel.text = typeString;
 		[typeLabel setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.25]];
 	}
 	else {
 		frameRateLabel.text = @"";
 		[frameRateLabel setBackgroundColor:[UIColor clearColor]];
 		
 		dimensionsLabel.text = @"";
 		[dimensionsLabel setBackgroundColor:[UIColor clearColor]];
 		
 		typeLabel.text = @"";
 		[typeLabel setBackgroundColor:[UIColor clearColor]];
 	}
}

- (UILabel *)labelWithText:(NSString *)text yPosition:(CGFloat)yPosition
{
//    if([text isEqualToString:@""]) text = @"eh?";
	CGFloat labelWidth = 200.0;
	CGFloat labelHeight = 40.0;
	CGFloat xPosition = 10;
	CGRect labelFrame = CGRectMake(xPosition, yPosition, labelWidth, labelHeight);
	UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
//	[label setFont:[UIFont systemFontOfSize:36]];
//	[label setLineBreakMode:NSLineBreakByWordWrapping];
//	[label setTextAlignment:NSTextAlignmentRight];
	[label setTextColor:[UIColor whiteColor]];
	[label setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.25]];
//	[[label layer] setCornerRadius: 4];
	[label setText:text];
	
//	return [label autorelease];
    return label;
}

#pragma mark IBActions

- (IBAction)toggleRecording:(id)sender 
{
	// Wait for the recording to start/stop before re-enabling the record button.
	[[self recordButton] setEnabled:NO];
	
	if ( [videoProcessor isRecording] ) {
		// The recordingWill/DidStop delegate methods will fire asynchronously in response to this call
		[videoProcessor stopRecording];
	}
	else {
		// The recordingWill/DidStart delegate methods will fire asynchronously in response to this call
        [videoProcessor startRecording];
	}
}


//- (IBAction)settingsButtonAction:(id)sender {
//    [self performSegueWithIdentifier:VWWSegueSession sender:self];
//}


#pragma mark VWWVideoProcessorDelegate

- (void)recordingWillStart
{
	dispatch_async(dispatch_get_main_queue(), ^{
		[[self recordButton] setEnabled:NO];	
		[[self recordButton] setTitle:@"Stop"];

		// Disable the idle timer while we are recording
		[UIApplication sharedApplication].idleTimerDisabled = YES;

		// Make sure we have time to finish saving the movie if the app is backgrounded during recording
		if ([[UIDevice currentDevice] isMultitaskingSupported])
			backgroundRecordingID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{}];
	});
}

- (void)recordingDidStart
{
	dispatch_async(dispatch_get_main_queue(), ^{
		[[self recordButton] setEnabled:YES];
	});
}

- (void)recordingWillStop
{
	dispatch_async(dispatch_get_main_queue(), ^{
		// Disable until saving to the camera roll is complete
		[[self recordButton] setTitle:@"Record"];
		[[self recordButton] setEnabled:NO];
		
		// Pause the capture session so that saving will be as fast as possible.
		// We resume the sesssion in recordingDidStop:
		[videoProcessor pauseCaptureSession];
	});
}

- (void)recordingDidStop
{
	dispatch_async(dispatch_get_main_queue(), ^{
		[[self recordButton] setEnabled:YES];
		
		[UIApplication sharedApplication].idleTimerDisabled = NO;

		[videoProcessor resumeCaptureSession];

		if ([[UIDevice currentDevice] isMultitaskingSupported]) {
			[[UIApplication sharedApplication] endBackgroundTask:backgroundRecordingID];
			backgroundRecordingID = UIBackgroundTaskInvalid;
		}
	});
}

- (void)pixelBufferReadyForDisplay:(CVPixelBufferRef)pixelBuffer
{
	// Don't make OpenGLES calls while in the background.
	if ( [UIApplication sharedApplication].applicationState != UIApplicationStateBackground )
		[oglView displayPixelBuffer:pixelBuffer];
}

@end
