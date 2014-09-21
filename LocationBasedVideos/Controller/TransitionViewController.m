//
//  TransitionViewController.m
//  LocationBasedVideos
//
//  Created by Michael Berg on 20.09.14.
//  Copyright (c) 2014 Couchfunk GmbH. All rights reserved.
//

#import "TransitionViewController.h"
#import <BlurImageProcessor/ALDBlurImageProcessor.h>
#import "SOLabel.h"
#import "Video.h"
#import "VideoViewController.h"


@interface TransitionViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *videoButtons;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end


@implementation TransitionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title                 = self.pool.story.name;
    self.descriptionLabel.text = self.pool.transitionText;
    
    UIImage *backgroundImage = [UIImage imageNamed:self.pool.story.imageName];
    if (backgroundImage) {
        [[[ALDBlurImageProcessor alloc] initWithImage:backgroundImage] asyncBlurWithRadius:40.0 iterations:4 successBlock:^(UIImage *blurredImage) {
            self.imageView.image = blurredImage;
        } errorBlock:^(NSNumber *errorCode) {
            
        }];
    }
    
    if(self.navigationController.viewControllers[0] == self){
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Schließen" style:UIBarButtonItemStyleBordered target:self action:@selector(didTapCloseButton:)];
    }
    
    if (self.pool.videos.count < 2) {
        UIButton *videoButton1 = self.videoButtons[0];
        UIButton *videoButton2 = self.videoButtons[1];
        
        videoButton1.frame	= ({
            CGRect frame     = videoButton1.frame;
            frame.size.width = CGRectGetMaxX(videoButton2.frame) - CGRectGetMinX(videoButton1.frame);
            frame;
        });
        [videoButton2 removeFromSuperview];
        
        self.videoButtons = @[self.videoButtons[0]];
    }
    
    for (NSInteger i=0;i<self.videoButtons.count;++i) {
        UIButton *button = self.videoButtons[i];
        Video *video = self.pool.videos[i];
        
        button.backgroundColor          = [UIColor colorWithWhite:1.0 alpha:0.2];
        button.layer.cornerRadius       = 4.0;
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.enabled = [self.pool.unwatchedVideos containsObject:video];
        button.alpha = button.enabled ? 1.0 : 0.3;
        
        [button setTitle:video.place.name forState:UIControlStateNormal];
    }
}

#pragma mark - User Interaction

-(IBAction)didTapCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    VideoViewController *controller = segue.destinationViewController;
    controller.video                = self.pool.videos[[self.videoButtons indexOfObject:sender]];;
}


@end
