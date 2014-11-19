//
//  OLOneViewController.m
//  OLOverlay
//
//  Created by Ryo Kikuchi on 2014/11/19.
//  Copyright (c) 2014年 halmakey. All rights reserved.
//

#import "OLOneViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface OLOneViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation OLOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    _contentView.layer.shadowRadius = 10;
    _contentView.layer.shadowOpacity = 0.4;
    _contentView.layer.cornerRadius = 6;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)dismissTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
