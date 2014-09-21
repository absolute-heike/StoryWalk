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
#import "TransitionViewController.h"


@interface StoryViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet SOLabel *descriptionLabel;

- (IBAction)didTapTrailerButton:(UIButton *)sender;

@end


@implementation StoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title                 = self.story.name;
    self.descriptionLabel.text = self.story.storyDescription;
    self.imageView.image       = [UIImage imageNamed:self.story.imageName];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [SVProgressHUD showWithStatus:@"Lade Daten"];
    [self.story loadStory:^(NSArray *pools) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - Navigation

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    return self.story.pools.count != 0;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.story reset];
    
    UINavigationController *navController = segue.destinationViewController;
    
    TransitionViewController *controller  = (TransitionViewController *)navController.topViewController;
    
    controller.pool = self.story.pools[0];
}

- (IBAction)didTapTrailerButton:(UIButton *)sender {
    NSArray *fileComponents = [self.story.trailerName componentsSeparatedByString:@"."];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:fileComponents[0] ofType:fileComponents[1]];
    NSURL *url     = [NSURL fileURLWithPath:path];
    
    MPMoviePlayerViewController *movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    
    [self presentMoviePlayerViewControllerAnimated:movieController];
}

@end
