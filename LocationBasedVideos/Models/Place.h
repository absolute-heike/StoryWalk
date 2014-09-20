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
@property (nonatomic, strong) NSString  *name;

@end
