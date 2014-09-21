//
//  Pool.h
//  LocationBasedVideos
//
//  Created by Michael Berg on 20.09.14.
//  Copyright (c) 2014 Couchfunk GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Story.h"


@interface Pool : NSObject

@property (nonatomic, strong) Pool    *nextPool;
@property (nonatomic, strong) Story   *story;
@property (nonatomic, strong) NSArray *videos;

@property (nonatomic, strong) NSMutableSet *unwatchedVideos;

@property (nonatomic, strong) NSString *poolID;
@property                     NSInteger sequenceNumber;
@property (nonatomic, strong) NSString *transitionText;

- (void)setupFromData:(NSDictionary *)data videos:(NSDictionary *)videos;

@end
