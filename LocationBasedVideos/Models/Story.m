//
//  Story.m
//  LocationBasedVideos
//
//  Created by Michael Berg on 20.09.14.
//  Copyright (c) 2014 Couchfunk GmbH. All rights reserved.
//

#import "Story.h"


@implementation Story

+ (instancetype)dummyStory {
    Story *story = [Story new];
    
    static NSInteger storyID = 0;
    story.ID = ++storyID;
    story.name = [NSString stringWithFormat:@"Story %d",(int)storyID];
    story.storyDescription = [LoremIpsum paragraphsWithNumber:2];
    story.imageName = [NSString stringWithFormat:@"Story-%d.jpeg",(((int)storyID - 1) % 3) + 1];
    
    return story;
}

@end
