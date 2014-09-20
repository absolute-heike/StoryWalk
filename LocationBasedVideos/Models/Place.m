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
    self.placeID    = data[@"place_id"];
    self.beaconUDID = data[@"beacon_id"];
    self.name       = data[@"place_name"];
    self.videoID    = data[@"video"];
}

@end
