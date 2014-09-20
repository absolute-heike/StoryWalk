//
//  Comment.h
//  LocationBasedVideos
//
//  Created by Michael Berg on 20.09.14.
//  Copyright (c) 2014 Couchfunk GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property (nonatomic, strong) NSString *commentID;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *text;

@end
