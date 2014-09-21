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
#import <Tweaks/FBTweakInline.h>


@implementation Story

+ (void)loadStories:(void (^)(NSArray *stories))completion {
    void(^completionHandler)(NSURLResponse *response, NSData *data, NSError *connectionError) = ^(NSURLResponse *response, NSData *data, NSError *connectionError){
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
    };
    
    if (FBTweakValue(@"Data", @"Use Dummy Data", @"Dummy Data", NO)) {
        NSData *data = [self.dummyStoriesJSON dataUsingEncoding:NSUTF8StringEncoding];
        completionHandler(nil,data,nil);
    }else{
        NSURL *url = [NSURL URLWithString:@"https://storywalk.azure-mobile.net/api/story/"];
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url]
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:completionHandler];
    }
}

- (void)loadStory:(void (^)(NSArray *pools))completion {
    if (self.pools.count != 0) {
        completion(self.pools);
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"https://storywalk.azure-mobile.net/api/story?id=%@",self.storyID];
    
    void(^completionHandler)(NSURLResponse *response, NSData *data, NSError *connectionError) = ^(NSURLResponse *response, NSData *data, NSError *connectionError){
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
    };
    
    if (FBTweakValue(@"Data", @"Use Dummy Data", @"Dummy Data", NO)) {
        NSData *data = [self.class.dummyPoolsJSON dataUsingEncoding:NSUTF8StringEncoding];
        completionHandler(nil,data,nil);
    }else {
        NSURL *url = [NSURL URLWithString:urlString];
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url]
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:completionHandler];
    }
}

- (void)setupFromData:(NSDictionary *)data {
    self.storyID          = data[@"story_id"];
    self.storyDescription = data[@"story_description"];
    self.name             = data[@"story_name"];
    self.trailerName      = data[@"story_trailer"];
    self.imageName        = data[@"story_img"];
    self.successText      = @"Danke Kommisar! Du hast Waldi gefunden! Möge er in Frieden Ruhen.";
}

- (void)reset {
    for (Pool *pool in self.pools) {
        [pool.unwatchedVideos addObjectsFromArray:pool.videos];
    }
}

+ (NSString *)dummyStoriesJSON {
    return @"{\"stories\":[{\"story_id\":\"EEB35275-91AF-49C3-80A5-7D2BE5B213D6\",\"story_name\":\"Waldi ist weg!\",\"story_description\":\"World's shortest crime story.\",\"story_trailer\":\"trailer.mp4\",\"story_img\":\"story-1.jpeg\"},{\"story_id\":\"1067156D-23DC-40E7-8371-EEBDF71ED266\",\"story_name\":\"25 Jahre Mauerfall\",\"story_description\":\"Seit 25 Jahren ist Berlin mauerfrei. Erforsche die Geschichte der Berliner Mauer direkt vor Ort.\",\"story_trailer\":\"history.mp4\",\"story_img\":\"history.jpeg\"},{\"story_id\":\"7CC52B11-5761-49BB-B9E5-D990F00A1A9E\",\"story_name\":\"TV Hackslay\",\"story_description\":\"Nach einer Zombie Apokalypse wurden die lokalen Rundfunkanstalten von hirnlosen Zombies übernommen. Besteht noch Hoffnung das Staffelfinale deiner Lieblingssoap zu sehen?\",\"story_trailer\":\"horror.mp4\",\"story_img\":\"horror.jpeg\"},{\"story_id\":\"9D5EDCE5-9B98-4935-A6C9-D76D3EA431C3\",\"story_name\":\"Meat Love\",\"story_description\":\"Alice liebt Bob, doch Bob scheint nur seinen Grill im Kopf zu haben. Liebt Bob sein Grillfleisch mehr als Alice? Finde es heraus, in einer brutzeligen Schnitzeljagd.\",\"story_trailer\":\"love.mp4\",\"story_img\":\"love.jpeg\"}]}";
}

+ (NSString *)dummyPoolsJSON{
    return @"{\"story_id\":\"EEB35275-91AF-49C3-80A5-7D2BE5B213D6\",\"story_name\":\"Waldi ist weg!\",\"story_description\":\"World's shortest crime story.\",\"story_trailer\":\"trailer.mp4\",\"story_img\":\"story-1.jpeg\",\"pools\":[{\"pool_id\":\"CEF32CC4-CDAF-4A29-8F92-F6DCF6FA9FAF\",\"pool_sequence_nr\":1,\"transition_text\":\"Waldi ist weg. Finde heraus, was mit ihm passiert ist. Waldi wurde auf der Arbeit zuletzt gesehen. Entscheide, welchen Ort du zuerst besuchst.\",\"videos\":[\"7F904B4B-A22E-45AD-BD06-333A57032F1D\",\"1370F345-0F82-4E88-8330-76D6B26F4735\"]},{\"pool_id\":\"B4816440-530A-4B6E-8DEC-5E799CC283E5\",\"pool_sequence_nr\":2,\"transition_text\":\"Waldi wird bereits vermisst. Und es gibt einen Verdächtigen. Von einem Augenzeugen hast du den Tipp bekommen, zur Brücke zu gehen. Dort soll es weitere Hinweise geben.\",\"videos\":[\"2CABD140-FC24-4B88-9640-4A9CF910A713\"]}],\"videos\":[{\"video_id\":\"7F904B4B-A22E-45AD-BD06-333A57032F1D\",\"video_name\":\"Storywalk1.mp4\",\"video_url\":\"Storywalk1.mp4\"},{\"video_id\":\"1370F345-0F82-4E88-8330-76D6B26F4735\",\"video_name\":\"Storywalk2.mp4\",\"video_url\":\"Storywalk2.mp4\"},{\"video_id\":\"2CABD140-FC24-4B88-9640-4A9CF910A713\",\"video_name\":\"Storywalk3.mp4\",\"video_url\":\"Storywalk3.mp4\"}],\"places\":[{\"place_id\":\"8BDF6643-726F-4D0B-BE32-06DE95C6670B\",\"place_name\":\"Weg nach Hause\",\"beacon_id\":\"12345\",\"video\":\"7F904B4B-A22E-45AD-BD06-333A57032F1D\"},{\"place_id\":\"A9F3DF29-6D52-4B5A-B0AA-77BC95C4EA8C\",\"place_name\":\"Arbeit\",\"beacon_id\":\"67890\",\"video\":\"1370F345-0F82-4E88-8330-76D6B26F4735\"},{\"place_id\":\"D17265C1-80E0-451D-AFAA-7F11DE478C72\",\"place_name\":\"Waldis Schicksal\",\"beacon_id\":\"98765\",\"video\":\"2CABD140-FC24-4B88-9640-4A9CF910A713\"}]}";
}

@end
