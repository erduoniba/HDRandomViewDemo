//
//  HDRadarViewController.m
//  HDRandomViewDemo
//
//  Created by denglibing on 2017/1/22.
//  Copyright © 2017年 denglibing. All rights reserved.
//

#import "HDRadarViewController.h"

#import "HDRadarView.h"

@interface HDRadarViewController ()

@property (nonatomic, strong) HDRadarView *radarView;
@property (weak, nonatomic) IBOutlet UIButton *dismissBt;

@end

@implementation HDRadarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:35 / 255.0 green:39 / 255.0 blue:63 / 255.0 alpha:1.0];
    
    _radarView = [[HDRadarView alloc] initWithFrame:self.view.frame];
    _radarView.radarSolid = YES;
    _radarView.radarCount = 15;
    [self.view addSubview:_radarView];
    
    [self.view bringSubviewToFront:_dismissBt];
}

- (IBAction)dismissAction {
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end
