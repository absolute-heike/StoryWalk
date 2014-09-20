//
//  Story.m
//  LocationBasedVideos
//
//  Created by Michael Berg on 20.09.14.
//  Copyright (c) 2014 Couchfunk GmbH. All rights reserved.
//

#import "Story.h"


@implementation Story

+ (void)loadStories:(void (^)(NSArray *stories))completion {
    NSURL *url = [NSURL URLWithString:@"https://storywalk.azure-mobile.net/api/story/"];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
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

- (void)setupFromData:(NSDictionary *)data {
    self.storyID          = data[@"story_id"];
    self.storyDescription = data[@"story_description"];
    self.name             = data[@"story_name"];
    self.trailerURL       = [NSURL URLWithString:data[@"story_id"]];
    
    self.imageName        = @"Story-2.jpeg";
}

@end
