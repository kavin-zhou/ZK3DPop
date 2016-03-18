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

@property (nonatomic, strong) ZKPopViewController *popVC;

@end

@implementation ZKMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.popVC = [[ZKPopViewController alloc] init];
}

- (IBAction)showBtnClick
{
    [[UIApplication sharedApplication].keyWindow addSubview:_popVC.view];
    
    CGRect frame = _popVC.view.frame;
    frame.origin.y = self.view.bounds.size.height - _popVC.view.frame.size.height;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [self.navigationController.view.layer setTransform:[self firstTransform]];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [self.navigationController.view.layer setTransform:[self secondTransform]];
            //popView上升
            _popVC.view.frame = frame;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
    
}

- (CATransform3D)firstTransform{
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-900;
    //带点缩小的效果
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    //绕x轴旋转
    t1 = CATransform3DRotate(t1, 15.0 * M_PI/180.0, 1, 0, 0);
    return t1;
    
}

- (CATransform3D)secondTransform{
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = [self firstTransform].m34;
    //向上移
    t2 = CATransform3DTranslate(t2, 0, self.view.frame.size.height * (-0.08), 0);
    //第二次缩小
    t2 = CATransform3DScale(t2, 0.8, 0.8, 1);
    return t2;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self close];
}

- (void)close
{
    CGRect frame = _popVC.view.frame;
    frame.origin.y += _popVC.view.frame.size.height;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //popView下降
        _popVC.view.frame = frame;
        
        //同时进行 感觉更丝滑
        [self.navigationController.view.layer setTransform:[self firstTransform]];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            //变为初始值
            [self.navigationController.view.layer setTransform:CATransform3DIdentity];
            
        } completion:^(BOOL finished) {
            
            //移除
            [_popVC.view removeFromSuperview];
        }];
        
    }];
    
    
    
}

@end
