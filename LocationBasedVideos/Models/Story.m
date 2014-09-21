//
//  Story.m
//  LocationBasedVideos
//
//  Created by Michael Berg on 20.09.14.
//  Copyright (c) 2014 Couchfunk GmbH. All rights reserved.
//

#import "Story.h"
#import "Pool.h"
#import "Video.h"
#import "Place.h"


@implementation Story

+ (void)loadStories:(void (^)(NSArray *stories))completion {
    NSURL *url = [NSURL URLWithString:@"https://storywalk.azure-mobile.net/api/story/"];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError) {
                                   completion( @[] );
                                   return;
                               }
                               
                               NSError *error = nil;
                               NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                               
                               if(!error){
                                   NSArray *storiesDict = dict[@"stories"];
                                   NSMutableArray *stories = [NSMutableArray array];
                                   
                                   for (NSDictionary *storyDict in storiesDict) {
                                       Story *story = [Story new];
                                       [story setupFromData:storyDict];
                                       
                                       [stories addObject:story];
                                   }
                                   
                                   completion(stories);
                               }else {
                                   completion( @[] );
                               }
    }];
}

- (void)loadStory:(void (^)(NSArray *pools))completion {
    NSString *urlString = [NSString stringWithFormat:@"https://storywalk.azure-mobile.net/api/story?id=%@",self.storyID];
    NSURL *url = [NSURL URLWithString:urlString];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSError *error = nil;
                               NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                               
                               if(!error){
                                   //Parse Videos
                                   NSArray *videosArray        = dict[@"videos"];
                                   if (!videosArray) {
                                       completion( @[] );
                                       return;
                                   }
                                   
                                   NSMutableDictionary *videos = [NSMutableDictionary dictionary];
                                   
                                   for (NSDictionary *videoDict in videosArray) {
                                       Video *video = [Video new];
                                       
                                       [video setupFromData:videoDict];
                                       [videos setObject:video forKey:video.videoID];
                                   }
                                   
                                   //Parse Places
                                   NSArray *placesArray        = dict[@"places"];
                                   
                                   for (NSDictionary *placeDict in placesArray) {
                                       Place *place = [Place new];
                                       
                                       [place setupFromData:placeDict];
                                       
                                       Video *video = videos[place.videoID];
                                       video.place = place;
                                   }
                                   
                                   //Parse Pools
                                   NSArray *poolsArray = dict[@"pools"];
                                   NSMutableArray *pools = [NSMutableArray array];
                                   
                                   for (NSDictionary *poolDict in poolsArray) {
                                       Pool *pool = [Pool new];
                                       pool.story = self;
                                       [pool setupFromData:poolDict videos:videos];
                                       
                                       [pools addObject:pool];
                                   }
                                   
                                   //connect Pools
                                   for (NSInteger i=0; i<pools.count -1; ++i) {
                                       Pool *pool    = pools[i];
                                       pool.nextPool = pools[i+1];
                                   }
                                   
                                   self.pools = pools;
                                   completion(pools);
                               }else {
                                   completion( @[] );
                               }
                           }];
}

- (void)setupFromData:(NSDictionary *)data {
    self.storyID          = data[@"story_id"];
    self.storyDescription = data[@"story_description"];
    self.name             = data[@"story_name"];
    self.trailerName      = data[@"story_trailer"];
    
    self.imageName        = data[@"story_img"];
}

@end
