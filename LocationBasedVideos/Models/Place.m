//
//  Place.m
//  LocationBasedVideos
//
//  Created by Michael Berg on 20.09.14.
//  Copyright (c) 2014 Couchfunk GmbH. All rights reserved.
//

#import "Place.h"

@implementation Place

-(void)setupFromData:(NSDictionary *)data {
    static NSDictionary *uuidMap = nil;
    static NSDictionary *majorMap = nil;
    static NSDictionary *minorMap = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uuidMap = @{
                    @"8BDF6643-726F-4D0B-BE32-06DE95C6670B": @"B9407F30-F5F8-466E-AFF9-25556B57FE6D",
                    @"A9F3DF29-6D52-4B5A-B0AA-77BC95C4EA8C": @"B9407F30-F5F8-466E-AFF9-25556B57FE6D",
                    //@"D17265C1-80E0-451D-AFAA-7F11DE478C72": @"8492E75F-4FD6-469D-B132-043FE94921D8",
                    @"D17265C1-80E0-451D-AFAA-7F11DE478C72": @"8492E75F-4FD6-469D-B132-043FE94921D8",
                    };
        majorMap = @{
                     @"8BDF6643-726F-4D0B-BE32-06DE95C6670B": @(7168),
                     @"A9F3DF29-6D52-4B5A-B0AA-77BC95C4EA8C": @(52038),
                     //@"D17265C1-80E0-451D-AFAA-7F11DE478C72": @(10906),
                     @"D17265C1-80E0-451D-AFAA-7F11DE478C72": @(1862),
                     };
        minorMap = @{
                     @"8BDF6643-726F-4D0B-BE32-06DE95C6670B": @(62820),
                     @"A9F3DF29-6D52-4B5A-B0AA-77BC95C4EA8C": @(11119),
                     //@"D17265C1-80E0-451D-AFAA-7F11DE478C72": @(22011),
                     @"D17265C1-80E0-451D-AFAA-7F11DE478C72": @(1265),
                     };
    });
    
    self.placeID    = data[@"place_id"];
    self.name       = data[@"place_name"];
    self.videoID    = data[@"video"];
    
    self.beaconUDID  = uuidMap[self.placeID];
    self.beaconMajor = [majorMap[self.placeID] integerValue];
    self.beaconMinor = [minorMap[self.placeID] integerValue];
}

@end
