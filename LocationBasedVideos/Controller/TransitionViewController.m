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

@interface TransitionViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *videoButtons;
@property (weak, nonatomic) IBOutlet SOLabel *descriptionLabel;

@end


@implementation TransitionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title                 = self.story.name;
    self.descriptionLabel.text = self.story.storyDescription;
    
    UIImage *backgroundImage = [UIImage imageNamed:self.story.imageName];
    [[[ALDBlurImageProcessor alloc] initWithImage:backgroundImage] asyncBlurWithRadius:40.0 iterations:4 successBlock:^(UIImage *blurredImage) {
        self.imageView.image = blurredImage;
    } errorBlock:^(NSNumber *errorCode) {
        
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Schließen" style:UIBarButtonItemStyleBordered target:self action:@selector(didTapCloseButton:)];
    
    for (UIButton *button in self.videoButtons) {
        button.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
        button.layer.cornerRadius = 4.0;
    }
}

#pragma mark - User Interaction

-(IBAction)didTapCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
