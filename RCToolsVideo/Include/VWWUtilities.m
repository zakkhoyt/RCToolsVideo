//
//  VWWUtilities.m
//  RC Video
//
//  Created by Zakk Hoyt on 3/10/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWUtilities.h"
#import <CoreLocation/CoreLocation.h>
#import "VWWDefines.h"

const float kFeetInAMeter = 3.28084;
NSString *dateAndTimeFormatString = @"yyyy-MM-dd HH:mm:ss";

@implementation VWWUtilities

@end

@implementation  VWWUtilities (DateFormatter)
+(NSDate*)dateAndTimeFromString:(NSString*)string{
    NSDateFormatter* dateLocal = [[NSDateFormatter alloc] init];
    [dateLocal setTimeZone:[NSTimeZone defaultTimeZone]];
    [dateLocal setDateFormat:dateAndTimeFormatString];
    NSDate *date = [dateLocal dateFromString:string];
    return date;
}
+(NSString*)stringFromDateAndTime:(NSDate*)date{
    NSDateFormatter* dateLocal = [[NSDateFormatter alloc] init];
    [dateLocal setTimeZone:[NSTimeZone defaultTimeZone]];
    [dateLocal setDateFormat:dateAndTimeFormatString];
    NSString* dateString = [dateLocal stringFromDate:date];
    return dateString;
}
@end

@implementation VWWUtilities (Conversion)
+(float)metersToFeet:(float)meters{
    return meters * kFeetInAMeter;
}
+(float)metersBetweenPointA:(CLLocation*)pointA pointB:(CLLocation*)pointB{
    CLLocationDistance distance = [pointA distanceFromLocation:pointB];
    return fabs((float)distance);
}
+(float)feetBetweenPointA:(CLLocation*)pointA pointB:(CLLocation*)pointB{
    CLLocationDistance distance = [self metersBetweenPointA:pointA pointB:pointB];
    return ((float)(distance) * kFeetInAMeter);
}




+(NSString*)jsonRepresentationOfDictionary:(NSDictionary*)dictionary prettyPrint:(BOOL)prettyPrint{
    if([NSJSONSerialization isValidJSONObject:dictionary] == NO){
        VWW_LOG_WARNING(@"Cannot convert object to json");
        return nil;
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    if (! jsonData) {
        VWW_LOG_ERROR(@"%@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}


+(NSString*)jsonRepresentationOfArray:(NSArray*)array prettyPrint:(BOOL)prettyPrint{
    if([NSJSONSerialization isValidJSONObject:array] == NO){
        VWW_LOG_WARNING(@"Cannot convert object to json");
        return nil;
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    if (! jsonData) {
        VWW_LOG_ERROR(@"%@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}


// TODO: Convert this code so that it iterates recursively though all values and removed anythign class types that not allowed (NSData for example)
+(NSString*)jsonStringFromDictionary:(NSDictionary*)dictionary prettyPrint:(BOOL)prettyPrint{
    NSMutableDictionary *mutableDictionary = [dictionary mutableCopy];
    
    if([NSJSONSerialization isValidJSONObject:mutableDictionary] == NO){
        VWW_LOG_WARNING(@"Cannot convert object to json");
        return nil;
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mutableDictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    if (! jsonData) {
        VWW_LOG_ERROR(@"%@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}





@end

@implementation VWWUtilities (Location)

+(void)stringFromLatitude:(double)latitude longitude:(double)longitude completionBlock:(VWWStringBlock)completionBlock{
    
    CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude
                                                     longitude:longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if(placemarks.count){
                           CLPlacemark *placemark = placemarks[0];
                           if(placemark.name)
                               return completionBlock(placemark.name);
                           if(placemark.thoroughfare)
                               return completionBlock(placemark.thoroughfare);
                           //                           if(placemark.subThoroughfare)
                           //                               return completionBlock(placemark.subThoroughfare);
                           if(placemark.locality)
                               return completionBlock(placemark.locality);
                           if(placemark.subLocality)
                               return completionBlock(placemark.subLocality);
                           if(placemark.administrativeArea)
                               return completionBlock(placemark.administrativeArea);
                           if(placemark.subAdministrativeArea)
                               return completionBlock(placemark.subAdministrativeArea);
                           if(placemark.postalCode)
                               return completionBlock(placemark.postalCode);
                           if(placemark.ISOcountryCode)
                               return completionBlock(placemark.ISOcountryCode);
                           if(placemark.country)
                               return completionBlock(placemark.country);
                           if(placemark.inlandWater)
                               return completionBlock(placemark.inlandWater);
                           if(placemark.ocean)
                               return completionBlock(placemark.ocean);
                           if(placemark.areasOfInterest.count){
                               return completionBlock(placemark.areasOfInterest[0]);
                           }
                       }
                   }];
}


+(void)stringLocalityFromLatitude:(double)latitude longitude:(double)longitude completionBlock:(VWWStringBlock)completionBlock{
    
    CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude
                                                     longitude:longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if(placemarks.count){
                           CLPlacemark *placemark = placemarks[0];
                           if(placemark.locality && placemark.subLocality)
                               return completionBlock([NSString stringWithFormat:@"%@ %@", placemark.subLocality, placemark.locality]);
                           if(placemark.subLocality)
                               return completionBlock(placemark.subLocality);
                           if(placemark.locality)
                               return completionBlock(placemark.locality);
                           if(placemark.subAdministrativeArea)
                               return completionBlock(placemark.subAdministrativeArea);
                           if(placemark.name)
                               return completionBlock(placemark.name);
                           if(placemark.thoroughfare)
                               return completionBlock(placemark.thoroughfare);
                           if(placemark.subThoroughfare)
                               return completionBlock(placemark.subThoroughfare);
                           if(placemark.administrativeArea)
                               return completionBlock(placemark.administrativeArea);
                           if(placemark.postalCode)
                               return completionBlock(placemark.postalCode);
                           if(placemark.ISOcountryCode)
                               return completionBlock(placemark.ISOcountryCode);
                           if(placemark.country)
                               return completionBlock(placemark.country);
                           if(placemark.inlandWater)
                               return completionBlock(placemark.inlandWater);
                           if(placemark.ocean)
                               return completionBlock(placemark.ocean);
                           if(placemark.areasOfInterest.count){
                               return completionBlock(placemark.areasOfInterest[0]);
                           }
                       }
                   }];
}

+(void)stringThoroughfareFromLatitude:(double)latitude longitude:(double)longitude completionBlock:(VWWStringBlock)completionBlock{
    
    CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude
                                                     longitude:longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if(placemarks.count){
                           CLPlacemark *placemark = placemarks[0];
                           if(placemark.thoroughfare && placemark.subThoroughfare)
                               return completionBlock([NSString stringWithFormat:@"%@ %@", placemark.subThoroughfare, placemark.thoroughfare]);
                           if(placemark.thoroughfare)
                               return completionBlock(placemark.thoroughfare);
                           if(placemark.subLocality)
                               return completionBlock(placemark.subLocality);
                           if(placemark.locality)
                               return completionBlock(placemark.locality);
                           if(placemark.subAdministrativeArea)
                               return completionBlock(placemark.subAdministrativeArea);
                           if(placemark.name)
                               return completionBlock(placemark.name);
                           if(placemark.subThoroughfare)
                               return completionBlock(placemark.subThoroughfare);
                           if(placemark.administrativeArea)
                               return completionBlock(placemark.administrativeArea);
                           if(placemark.postalCode)
                               return completionBlock(placemark.postalCode);
                           if(placemark.ISOcountryCode)
                               return completionBlock(placemark.ISOcountryCode);
                           if(placemark.country)
                               return completionBlock(placemark.country);
                           if(placemark.inlandWater)
                               return completionBlock(placemark.inlandWater);
                           if(placemark.ocean)
                               return completionBlock(placemark.ocean);
                           if(placemark.areasOfInterest.count){
                               return completionBlock(placemark.areasOfInterest[0]);
                           }
                       }
                   }];
}
@end
