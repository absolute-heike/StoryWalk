//
//  StoryViewController.m
//  LocationBasedVideos
//
//  Created by Michael Berg on 20.09.14.
//  Copyright (c) 2014 Couchfunk GmbH. All rights reserved.
//

#import "StoryViewController.h"
#import "SOLabel.h"
#import <MediaPlayer/MediaPlayer.h>


@interface StoryViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet SOLabel *descriptionLabel;

- (IBAction)didTapTrailerButton:(UIButton *)sender;

@end


@implementation StoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.story.name;
    self.descriptionLabel.text = self.story.storyDescription;
    self.imageView.image = [UIImage imageNamed:self.story.imageName];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

- (IBAction)didTapTrailerButton:(UIButton *)sender {
    NSLog(@"Start Trailer");
    NSString *path = [[NSBundle mainBundle]pathForResource:@"trailer" ofType:@"mp4"];
    MPMoviePlayerViewController *movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:path]];
    
    [self presentViewController:movieController animated:YES completion:nil];
}

- (IBAction)didTapStartButton:(UIButton *)sender {
    NSLog(@"Start Story");
}

@end
