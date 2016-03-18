//
//  ZKPopViewController.m
//  ZK3DPop
//
//  Created by ZK on 16/3/17.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKPopViewController.h"
#import "ZKConfig.h"

@interface ZKPopViewController ()

@end

@implementation ZKPopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = self.view.frame;
    frame.size.height = ScreenHeight * 0.5;
    frame.origin.y = ScreenHeight;
    self.view.frame = frame;
}

@end
