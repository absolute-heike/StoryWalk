//
//  Pool.m
//  LocationBasedVideos
//
//  Created by Michael Berg on 20.09.14.
//  Copyright (c) 2014 Couchfunk GmbH. All rights reserved.
//

#import "Pool.h"

@implementation Pool

- (void)setupFromData:(NSDictionary *)data videos:(NSDictionary *)videos {
    self.poolID         = data[@"pool_id"];
    self.sequenceNumber = [data[@"pool_sequence_nr"] integerValue];
    self.transitionText = data[@"transition_text"];
    
    NSArray *videoIDs          = data[@"videos"];
    NSMutableArray *poolVideos = [NSMutableArray array];
    for (NSString *videoID in videoIDs) {
        [poolVideos addObject:videos[videoID]];
    }
    self.videos = poolVideos;
}

@end
