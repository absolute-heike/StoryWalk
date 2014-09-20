//
//  Video.h
//  LocationBasedVideos
//
//  Created by Michael Berg on 20.09.14.
//  Copyright (c) 2014 Couchfunk GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Place.h"


@interface Video : NSObject

@property (nonatomic, strong) Place *place;

@property (nonatomic, strong) NSString *videoID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSURL    *videoURL;

@end
