

#import <AVFoundation/AVFoundation.h>
#import "VWWPreviewView.h"
#import "VWWVideoProcessor.h"

@interface VWWSessionViewController : UIViewController <VWWVideoProcessorDelegate>
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

- (IBAction)toggleRecording:(id)sender;

@end
