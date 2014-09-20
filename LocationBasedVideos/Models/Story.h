//
//  Story.h
//  LocationBasedVideos
//
//  Created by Michael Berg on 20.09.14.
//  Copyright (c) 2014 Couchfunk GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Story : NSObject

@property (nonatomic, assign)   NSInteger ID;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *storyDescription;

+ (instancetype)dummyStory;

@end
