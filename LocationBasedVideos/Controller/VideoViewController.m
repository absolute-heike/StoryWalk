//
//  VideoViewController.m
//  LocationBasedVideos
//
//  Created by Michael Berg on 20.09.14.
//  Copyright (c) 2014 Couchfunk GmbH. All rights reserved.
//

#import "VideoViewController.h"

@interface VideoViewController ()

@property (nonatomic, weak) IBOutlet UIView *signalStrenghtView;

@end


@implementation VideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.signalStrenghtView.layer.cornerRadius = self.signalStrenghtView.frame.size.width / 2.0;
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
