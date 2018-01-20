//
//  ILIBaseController.m
//  sc
//
//  Created by fx on 2018/1/19.
//  Copyright © 2018年 fxtest. All rights reserved.
//

#import "ILIBaseController.h"
#import "ILIHAVRollingView.h"
#import "CustomView.h"



@implementation ILIBaseController


- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CustomView *s0 =  [[CustomView alloc] init];
    CustomView *s1 =  [[CustomView alloc] init];
    CustomView *s2 =  [[CustomView alloc] init];
    ILIHAVRollingHeaderView *header =  [[ILIHAVRollingHeaderView alloc] init];
    ILIHAVRollingView *view = [ILIHAVRollingView rollingWithViews:@[s0,s1,s2] headerView:header headerHeight:200 heightMinHeight:64];
    [self.view addSubview:view];

}
@end
