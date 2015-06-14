//
//  VWWHUDHomeView.m
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 5/31/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "VWWHUDHomeView.h"
double headingInRadians(double lat1, double lon1, double lat2, double lon2)
{
    //-------------------------------------------------------------------------
    // Algorithm found at http://www.movable-type.co.uk/scripts/latlong.html
    //
    // Spherical Law of Cosines
    //
    // Formula: θ = atan2( 	sin(Δlon) * cos(lat2),
    //						cos(lat1) * sin(lat2) − sin(lat1) * cos(lat2) * cos(Δlon) )
    // JavaScript:
    //
    //	var y = Math.sin(dLon) * Math.cos(lat2);
    //	var x = Math.cos(lat1) * Math.sin(lat2) - Math.sin(lat1) * Math.cos(lat2) * Math.cos(dLon);
    //	var brng = Math.atan2(y, x).toDeg();
    //-------------------------------------------------------------------------
    double dLon = lon2 - lon1;
    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    
    return atan2(y, x);
}


@interface VWWHUDHomeView ()
@property (nonatomic, strong) UILabel *homeLabel;
@property (nonatomic, strong) UIImageView *homeImageView;
@end

@implementation VWWHUDHomeView

-(void)setCurrentLocation:(CLLocation *)currentLocation{
    _currentLocation = currentLocation;
    
    [self setLabel];
    [self setArrow];

    
}

-(CGFloat)angleHome{
    return headingInRadians(self.currentLocation.coordinate.latitude,
                                       self.currentLocation.coordinate.longitude,
                                       self.homeLocation.coordinate.latitude,
                                       self.homeLocation.coordinate.longitude);
}

-(CGFloat)distanceHome{
    return [self.currentLocation distanceFromLocation:self.homeLocation];
}

-(BOOL)hasTraveledSignificantDistance{
    return [self distanceHome] > 15;
}

-(void)setLabel{
    if(self.homeLabel == nil){
        const CGFloat kHeight = 42;
        const CGFloat kBorder = 8;
        CGRect frame = CGRectMake(kBorder, self.bounds.size.height - kHeight, self.bounds.size.width - 2*kBorder, kHeight);
        self.homeLabel = [[UILabel alloc]initWithFrame:frame];
        self.homeLabel.textColor = [UIColor whiteColor];
        self.homeLabel.textAlignment = NSTextAlignmentLeft;
        self.homeLabel.numberOfLines = 0;
        self.homeLabel.shadowOffset = CGSizeMake(1, 1);
        self.homeLabel.shadowColor = [UIColor blackColor];
        [self addSubview:self.homeLabel];
    }
    
    if([self hasTraveledSignificantDistance]){
        self.homeLabel.text = [NSString stringWithFormat:@"Home: %.2fm",
                               [self distanceHome]];
        
    } else {
        self.homeLabel.text = [NSString stringWithFormat:@"At Home +/-5m"];
    }
}

-(void)setArrow{
    if(self.homeImageView == nil){
        self.homeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home"]];
        const CGFloat kWidth = 44;
        self.homeImageView.frame = CGRectMake((self.bounds.size.width - kWidth)/2.0,
                                              (self.bounds.size.height - kWidth) / 2.0,
                                              kWidth,
                                              kWidth);

        [self addSubview:self.homeImageView];
    }
    if([self hasTraveledSignificantDistance]){
        self.homeImageView.hidden = NO;
        self.homeImageView.transform = CGAffineTransformMakeRotation([self angleHome]);
    } else {
        self.homeImageView.hidden = YES;
    }
}


@end
