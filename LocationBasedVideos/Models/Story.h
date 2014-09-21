//
//  Story.h
//  LocationBasedVideos
//
//  Created by Michael Berg on 20.09.14.
//  Copyright (c) 2014 Couchfunk GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Story : NSObject

@property (nonatomic, strong) NSArray  *pools;

@property (nonatomic, strong) NSString *storyID;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *storyDescription;
@property (nonatomic, strong) NSString *trailerName;
@property (nonatomic, strong) NSString *successText;

+ (void)loadStories:(void (^)(NSArray *stories))completion;

- (void)loadStory:(void (^)(NSArray *pools))completion;
- (void)reset;

+ (NSString *)dummyStoriesJSON;
+ (NSString *)dummyPoolsJSON;

@end
