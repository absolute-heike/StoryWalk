//
//  Video.m
//  LocationBasedVideos
//
//  Created by Michael Berg on 20.09.14.
//  Copyright (c) 2014 Couchfunk GmbH. All rights reserved.
//

#import "Video.h"


@implementation Video

-(void)setupFromData:(NSDictionary *)data {
    self.videoID   = data[@"video_id"];
    self.name      = data[@"video_name"];
    self.videoName = data[@"video_url"];
}

@end
