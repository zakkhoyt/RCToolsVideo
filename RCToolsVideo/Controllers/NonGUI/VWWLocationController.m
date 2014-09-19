//
//  VWWLocationController.m
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 9/18/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWLocationController.h"
#import "VWW.h"
#import "VWWDefines.h"
#import <UIKit/UIKit.h>
#import "NSTimer+Blocks.h"

@interface VWWLocationController ()
<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
//@property (nonatomic) dispatch_queue_t queue;
@property (nonatomic, strong) VWWArrayBlock locationsUpdatedBlock;
@property (nonatomic, strong) VWWCLLocationBlock currentLocationBlock;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) CLLocation *lastUpdatedLocation;
@property (nonatomic) BOOL isRunning;

@property (nonatomic, strong) CLLocation *homeLocation;
@end


@implementation VWWLocationController



#pragma mark Public methods

+(VWWLocationController*)sharedInstance{
    static VWWLocationController *instance;
    if(instance == nil){
        instance = [[VWWLocationController alloc]init];
    }
    return instance;
}

-(id)init{
    self = [super init];
    if(self){
        [self initializeClass];
    }
    return self;
}

//
//+(BOOL)serviceExists{
//    
//    VWW_LOG_TODO;
//    return YES;
//}
//
//+(BOOL)hasBeenPrompted{
////    NSDate *date = [VWWUserDefaults coreLocationPermissionDate];
////    return date != nil;
//    return YES;
//}
//
//
//+(void)displayPermissionPromptWithCompletionBlock:(VWWBoolBlock)completionBlock{
//    //    CLLocationManager *locationManager = [[CLLocationManager alloc]init];
//    //    _locationManager.delegate = self;
//    //
//    
//}
//


-(void)start{
    if(self.isRunning) return;
    self.isRunning = YES;
    
    [self resetStats];

    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager startUpdatingHeading];
    [self.locationManager startUpdatingLocation];
}
-(void)stop{
    if(self.isRunning == NO) return;
    self.isRunning = NO;
    
    [self.locationManager stopUpdatingHeading];
    [self.locationManager stopUpdatingLocation];
    
}

-(void)resetStats{
    self.location = nil;
    self.maxSpeed = 0;
    self.heading = nil;
    self.homeLocation = nil;
}

//
//
//-(void)setLocationsUpdatedBlock:(VWWArrayBlock)locationsUpdatedBlock{
//    _locationsUpdatedBlock = locationsUpdatedBlock;
//}

//
//-(void)getCurrentLocationWithCompletionBlock:(VWWCLLocationBlock)completionBlock{
//    _currentLocationBlock = completionBlock;
//    [self start];
//}
//

#pragma mark Private methods








-(void)initializeClass{
    
    //    _queue = dispatch_queue_create("com.getsmileapp.smile.location", NULL);
    //    dispatch_async(self.queue, ^{
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    [_locationManager requestWhenInUseAuthorization];
    
    
    //        _locationManager.distanceFilter = 1000;
    
#ifdef __IPHONE_8_0
    if(VWW_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
        [_locationManager requestAlwaysAuthorization];
    }
#endif
}


#pragma mark CLLocationManagerDelegate


/*
 *  locationManager:didUpdateToLocation:fromLocation:
 *
 *  Discussion:
 *    Invoked when a new location is available. oldLocation may be nil if there is no previous location
 *    available.
 *
 *    This method is deprecated. If locationManager:didUpdateLocations: is
 *    implemented, this method will not be called.
 */
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    VWW_LOG_DEBUG(@"");
}

/*
 *  locationManager:didUpdateLocations:
 *
 *  Discussion:
 *    Invoked when new locations are available.  Required for delivery of
 *    deferred locations.  If implemented, updates will
 *    not be delivered to locationManager:didUpdateToLocation:fromLocation:
 *
 *    locations is an array of CLLocation objects in chronological order.
 */
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    if(locations.count){
        CLLocation *location = locations[0];
//        VWW_LOG_DEBUG(@"New location: %@", location.description);
        self.location = location;
        self.currentSpeed = location.speed;
        self.maxSpeed = MAX(self.maxSpeed, location.speed);
        
        if(self.homeLocation == nil){
            self.homeLocation = [location copy];
        }
        self.distanceFromHome = [location distanceFromLocation:self.homeLocation];
        
    }
}

/*
 *  locationManager:didUpdateHeading:
 *
 *  Discussion:
 *    Invoked when a new heading is available.
 */
- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading{
    VWW_LOG_DEBUG(@"New heading: %@", newHeading.description);
    self.heading = newHeading;
}

/*
 *  locationManagerShouldDisplayHeadingCalibration:
 *
 *  Discussion:
 *    Invoked when a new heading is available. Return YES to display heading calibration info. The display
 *    will remain until heading is calibrated, unless dismissed early via dismissHeadingCalibrationDisplay.
 */
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager{
    
    VWW_LOG_DEBUG(@"");
    return NO;
}

/*
 *  locationManager:didDetermineState:forRegion:
 *
 *  Discussion:
 *    Invoked when there's a state transition for a monitored region or in response to a request for state via a
 *    a call to requestStateForRegion:.
 */
- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    
    VWW_LOG_DEBUG(@"");
}

/*
 *  locationManager:didRangeBeacons:inRegion:
 *
 *  Discussion:
 *    Invoked when a new set of beacons are available in the specified region.
 *    beacons is an array of CLBeacon objects.
 *    If beacons is empty, it may be assumed no beacons that match the specified region are nearby.
 *    Similarly if a specific beacon no longer appears in beacons, it may be assumed the beacon is no longer received
 *    by the device.
 */
- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    
    VWW_LOG_DEBUG(@"");
}

/*
 *  locationManager:rangingBeaconsDidFailForRegion:withError:
 *
 *  Discussion:
 *    Invoked when an error has occurred ranging beacons in a region. Error types are defined in "CLError.h".
 */
- (void)locationManager:(CLLocationManager *)manager
rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
              withError:(NSError *)error{
    
    VWW_LOG_DEBUG(@"");
}

/*
 *  locationManager:didEnterRegion:
 *
 *  Discussion:
 *    Invoked when the user enters a monitored region.  This callback will be invoked for every allocated
 *    CLLocationManager instance with a non-nil delegate that implements this method.
 */
- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region {
    
    VWW_LOG_DEBUG(@"");
}

/*
 *  locationManager:didExitRegion:
 *
 *  Discussion:
 *    Invoked when the user exits a monitored region.  This callback will be invoked for every allocated
 *    CLLocationManager instance with a non-nil delegate that implements this method.
 */
- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region{
    
    VWW_LOG_DEBUG(@"");
}

/*
 *  locationManager:didFailWithError:
 *
 *  Discussion:
 *    Invoked when an error has occurred. Error types are defined in "CLError.h".
 */
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    
    
    VWW_LOG_DEBUG(@"error: %@", error);
}

/*
 *  locationManager:monitoringDidFailForRegion:withError:
 *
 *  Discussion:
 *    Invoked when a region monitoring error has occurred. Error types are defined in "CLError.h".
 */
- (void)locationManager:(CLLocationManager *)manager
monitoringDidFailForRegion:(CLRegion *)region
              withError:(NSError *)error{
    
    VWW_LOG_DEBUG(@"error: %@", error);
}

/*
 *  locationManager:didChangeAuthorizationStatus:
 *
 *  Discussion:
 *    Invoked when the authorization status changes for this application.
 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    VWW_LOG_DEBUG(@"");
}
/*
 *  locationManager:didStartMonitoringForRegion:
 *
 *  Discussion:
 *    Invoked when a monitoring for a region started successfully.
 */
- (void)locationManager:(CLLocationManager *)manager
didStartMonitoringForRegion:(CLRegion *)region {
    
    VWW_LOG_DEBUG(@"");
}

/*
 *  Discussion:
 *    Invoked when location updates are automatically paused.
 */
- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager {
    
    VWW_LOG_DEBUG(@"");
}

/*
 *  Discussion:
 *    Invoked when location updates are automatically resumed.
 *
 *    In the event that your application is terminated while suspended, you will
 *	  not receive this notification.
 */
- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager {
    
    VWW_LOG_DEBUG(@"");
}

/*
 *  locationManager:didFinishDeferredUpdatesWithError:
 *
 *  Discussion:
 *    Invoked when deferred updates will no longer be delivered. Stopping
 *    location, disallowing deferred updates, and meeting a specified criterion
 *    are all possible reasons for finishing deferred updates.
 *
 *    An error will be returned if deferred updates end before the specified
 *    criteria are met (see CLError).
 */
- (void)locationManager:(CLLocationManager *)manager
didFinishDeferredUpdatesWithError:(NSError *)error {
    
    VWW_LOG_DEBUG(@"");
}


@end
