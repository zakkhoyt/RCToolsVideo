//
//  VWWStatusVIewController.m
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 5/30/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

// Exampel image here: http://hobbywireless.com/images/STORM%20OSD%20kit_01.jpg

//accelerometers        current|max
//gyros                 current|max
//heading               true | magnetic
//altitude              agl | asl
//distance from home    meters | feet
//speed                 current|max
//coordinates           current

// HUD type
//accelerometers        graph
//gyros                 graph
//heading               graph
//compass indicator     arrow
//attitude indicator    graphics


#import "VWWStatusViewController.h"
#import "VWW.h"
#import "VWWStatusTableViewCell.h"

@import CoreMotion;
@import CoreLocation;


@interface VWWStatusViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) CMAltimeter *altimeter;

@property (nonatomic, strong) NSNumber *startAltitude;
@property (nonatomic, strong) NSNumber *currentAltitude;

@end


@interface VWWStatusViewController (UITableView) <UITableViewDataSource, UITableViewDelegate>

@end

@interface VWWStatusViewController (Altimeter)
-(void)startAltimeter;
@end


@implementation VWWStatusViewController
- (instancetype)init {
    self = [super init];
    if (self) {
        [self.tableView registerClass:[VWWStatusTableViewCell class] forCellReuseIdentifier:@"VWWStatusTableViewCell"];
        


    }
    return self;
}
@end


@implementation VWWStatusViewController (UITableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSUInteger count = 0;
    if([VWWUserDefaults renderCoordinates]){
        count++;
    }
    if([VWWUserDefaults renderSpeed]){
        count++;
    }
    if([VWWUserDefaults renderDistanceFromHome]){
        count++;
    }
    if([VWWUserDefaults renderHeading]){
        count++;
    }
    if([VWWUserDefaults renderAltitude]){
        count++;
    }
    if([VWWUserDefaults renderAccelerometers]){
        count++;
    }
    if([VWWUserDefaults renderGyroscopes]){
        count++;
    }
    if([VWWUserDefaults renderAccelerometerLimits]){
        count++;
    }
    if([VWWUserDefaults renderGyroscopeLimits]){
        count++;
    }

    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = @"hi";
    return cell;
}

@end

@implementation VWWStatusViewController (Altimeter)

-(void)startAltimeter{
    self.altimeter = [[CMAltimeter alloc]init];
    [self.altimeter startRelativeAltitudeUpdatesToQueue:[NSOperationQueue new] withHandler:^(CMAltitudeData *altitudeData, NSError *error) {
        if(self.startAltitude == nil){
            self.startAltitude = [altitudeData.relativeAltitude copy];
        }
        self.currentAltitude = [altitudeData.relativeAltitude copy];
    }];
}
@end