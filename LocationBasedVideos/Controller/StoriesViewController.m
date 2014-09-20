//
//  StoriesViewController.m
//  LocationBasedVideos
//
//  Created by Michael Berg on 20.09.14.
//  Copyright (c) 2014 Couchfunk GmbH. All rights reserved.
//

#import "StoriesViewController.h"
#import "Story.h"
#import "StoryViewController.h"


@interface StoriesViewController ()<UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation StoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView.dataSourceManager registerCellReuseIdentifier:@"StoryCell"
                                                    forDataObject:[Story class]
                                                       setupBlock:^(UITableViewCell *cell, Story *story, NSIndexPath *indexPath) {
        cell.textLabel.text = story.name;
    }];
    
    [self loadStories:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadStories:)];
}

-(IBAction)loadStories:(id)sender {
    [SVProgressHUD showWithStatus:@"Lade Stories in deiner Nähe"];
    
    [Story loadStories:^(NSArray *stories) {
        [SVProgressHUD dismiss];
        self.tableView.dataSourceManager.data = @[ stories ];
    }];
}

#pragma mark - User Interaction

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    Story *story = [self.tableView.dataSourceManager dataForIndexPath:[self.tableView indexPathForCell:sender]];
    
    StoryViewController *storyViewController = segue.destinationViewController;
    storyViewController.story                = story;
}


@end
