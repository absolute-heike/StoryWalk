//
//  Pool.m
//  LocationBasedVideos
//
//  Created by Michael Berg on 20.09.14.
//  Copyright (c) 2014 Couchfunk GmbH. All rights reserved.
//

#import "Pool.h"
#import "Video.h"


@implementation Pool

- (void)setupFromData:(NSDictionary *)data videos:(NSDictionary *)videos {
    self.poolID          = data[@"pool_id"];
    self.sequenceNumber  = [data[@"pool_sequence_nr"] integerValue];
    self.transitionText  = data[@"transition_text"];
    self.unwatchedVideos = [NSMutableSet set];

    NSArray *videoIDs          = data[@"videos"];
    NSMutableArray *poolVideos = [NSMutableArray array];
    for (NSString *videoID in videoIDs) {
        Video *video = videos[videoID];
        video.pool   = self;
        
        [poolVideos addObject:video];
    }
    self.videos = poolVideos;
}

@end
