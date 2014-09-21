//
//  VideoViewController.m
//  LocationBasedVideos
//
//  Created by Michael Berg on 20.09.14.
//  Copyright (c) 2014 Couchfunk GmbH. All rights reserved.
//

#import "VideoViewController.h"
#import <EstimoteSDK/ESTBeaconManager.h>
#import <pop/POP.h>
#import <MediaPlayer/MediaPlayer.h>
#import "TransitionViewController.h"
#import "SuccessViewController.h"


@interface VideoViewController ()<CLLocationManagerDelegate>

@property BOOL shouldContinueOnAppear;

@property (nonatomic, weak) IBOutlet UIView *signalStrenghtView;
@property (weak, nonatomic) IBOutlet UIView *successView;

@property (strong, nonatomic) CLBeaconRegion *myBeaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end


@implementation VideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.video.place.name;
    
    self.successView.hidden = TRUE;
    self.signalStrenghtView.layer.cornerRadius = self.signalStrenghtView.frame.size.width / 2.0;
    
    // iBeacon detection
    self.locationManager          = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    NSUUID *uuid        = [[NSUUID alloc] initWithUUIDString:self.video.place.beaconUDID];
    self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                  major:self.video.place.beaconMajor
                                                                  minor:self.video.place.beaconMinor
                                                             identifier:@"de.couchfunk.testregion"];
    
    [self.locationManager startRangingBeaconsInRegion:self.myBeaconRegion];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.locationManager stopRangingBeaconsInRegion:self.myBeaconRegion];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.shouldContinueOnAppear) {
        if (
            self.video.pool.unwatchedVideos.count == 0 &&
            self.video.pool.nextPool == nil
            ) {
            [self performSegueWithIdentifier:@"success" sender:self];
        }else{
            [self performSegueWithIdentifier:@"nextVideo" sender:self];
        }
    }
}

-(void)locationManager:(CLLocationManager*)manager
       didRangeBeacons:(NSArray*)beacons
              inRegion:(CLBeaconRegion*)region
{
    // Beacon found!
    CLBeacon *beacon = [beacons firstObject];
    
    CGFloat distance = 0.2;
    if (beacon.rssi != 0) {
        NSInteger rssi = ABS(beacon.rssi);
        
        distance = (100 - rssi) / 3.0;
    }
    
    if (distance > 7.0) {
        distance = 100.0;
        [manager stopRangingBeaconsInRegion:self.myBeaconRegion];
        
        self.successView.hidden = FALSE;
        POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        animation.springSpeed = 2.0;
        animation.fromValue   = [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)];
        animation.toValue     = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
        
        [self.successView pop_addAnimation:animation forKey:kPOPViewScaleXY];
        
        self.shouldContinueOnAppear = TRUE;
        [self.video.pool.unwatchedVideos removeObject:self.video];
    }
    
    POPSpringAnimation *animation = [self.signalStrenghtView pop_animationForKey:kPOPViewScaleXY];
    if (!animation) {
        animation             = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        animation.springSpeed = 2.0;
        [self.signalStrenghtView pop_addAnimation:animation forKey:kPOPViewScaleXY];
    }
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(distance, distance)];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"nextVideo"]) {
        TransitionViewController *controller = segue.destinationViewController;
        
        if (self.video.pool.unwatchedVideos.count == 0) {
            controller.pool = self.video.pool.nextPool;
        }else{
            controller.pool = self.video.pool;
        }
    }else {
        SuccessViewController *controller = segue.destinationViewController;
        controller.story                  = self.video.pool.story;
    }
}

- (IBAction)didTapPlayButton:(id)sender {
    NSArray *fileComponents = [self.video.videoName componentsSeparatedByString:@"."];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:fileComponents[0] ofType:fileComponents[1]];
    NSURL *url     = [NSURL fileURLWithPath:path];
    
    MPMoviePlayerViewController *movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    
    [self presentMoviePlayerViewControllerAnimated:movieController];
}

@end
