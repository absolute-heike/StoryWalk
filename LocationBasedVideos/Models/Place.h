//
//  Place.h
//  LocationBasedVideos
//
//  Created by Michael Berg on 20.09.14.
//  Copyright (c) 2014 Couchfunk GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Comment.h"

@interface Place : NSObject

@property (nonatomic, strong) NSArray   *comments;

//properties
@property (nonatomic, strong) NSString  *placeID;

@property (nonatomic, strong) NSString  *beaconUDID;
@property NSInteger                     beaconMajor;
@property NSInteger                     beaconMinor;
@property CGFloat                       beaconFactor;

@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) NSString  *videoID;

-(void)setupFromData:(NSDictionary *)data;

@end
