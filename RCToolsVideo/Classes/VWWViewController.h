

#import <AVFoundation/AVFoundation.h>
#import "VWWPreviewView.h"
#import "VWWVideoProcessor.h"

@interface VWWViewController : UIViewController <VWWVideoProcessorDelegate>
{
    VWWVideoProcessor *videoProcessor;
    
	UIView *previewView;
    VWWPreviewView *oglView;
    UIBarButtonItem *recordButton;
	UILabel *frameRateLabel;
	UILabel *dimensionsLabel;
	UILabel *typeLabel;
 
    NSTimer *timer;
    
	BOOL shouldShowStats;
	
	UIBackgroundTaskIdentifier backgroundRecordingID;
}

@property (nonatomic, retain) IBOutlet UIView *previewView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *recordButton;

- (IBAction)toggleRecording:(id)sender;

@end
