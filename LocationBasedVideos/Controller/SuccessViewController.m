//
//  SuccessViewController.m
//  LocationBasedVideos
//
//  Created by Michael Berg on 21.09.14.
//  Copyright (c) 2014 Couchfunk GmbH. All rights reserved.
//

#import "SuccessViewController.h"

@interface SuccessViewController ()

@property (weak, nonatomic) IBOutlet UILabel *successLabel;

@end

@implementation SuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = TRUE;
    self.successLabel.text              = self.story.successText;
}

- (IBAction)didTapReturnButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
