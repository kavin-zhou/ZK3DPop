//
//  ZKMainViewController.m
//  ZK3DPop
//
//  Created by ZK on 16/3/17.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKMainViewController.h"
#import "ZKPopViewController.h"

@interface ZKMainViewController ()

@end

@implementation ZKMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (IBAction)showBtnClick
{
    ZKPopViewController *popVC = [[ZKPopViewController alloc] init];
    [self addChildViewController:popVC];
    [self.view addSubview:popVC.view];
}

@end
