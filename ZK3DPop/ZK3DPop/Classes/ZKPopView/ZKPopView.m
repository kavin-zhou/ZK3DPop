//
//  ZKPopView.m
//  ZK3DPop
//
//  Created by ZK on 16/7/17.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKPopView.h"
#import "ZKConfig.h"

@interface ZKPopView()

@property (nonatomic, strong) UIButton    *maskView; //遮罩
@property (nonatomic, strong) UIImageView *snapedImageView;

@end

static NSTimeInterval const kAnimateDuration = 0.28;

@implementation ZKPopView

#pragma mark *** init ***
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor blackColor];
    
    _maskView = [[UIButton alloc] init];
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = 0.f;
    [_maskView addTarget:self action:@selector(maskViewDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_maskView];
    
    _snapedImageView = [[UIImageView alloc] init];
    _snapedImageView.image = [self snapshotWithWindow];
    [self addSubview:_snapedImageView];
    
    _modalView = [[UIView alloc] init];
    _modalView.backgroundColor = [UIColor redColor];
    _modalView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight*0.5);
    [self addSubview:_modalView];
}

#pragma mark *** show ***
+ (void)show
{
    ZKPopView *popView = [[ZKPopView alloc] initWithFrame:ScreenBounds];
    [KeyWindow addSubview:popView];
    
    CGRect modalViewNewFrame = popView.modalView.frame;
    modalViewNewFrame.origin.y = ScreenHeight*0.5;
    
    [UIView animateWithDuration:kAnimateDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [popView.snapedImageView.layer setTransform:[self firstTransform]];
        popView.snapedImageView.layer.zPosition = -1000;
        popView.maskView.alpha = 0.2;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:kAnimateDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [popView.snapedImageView.layer setTransform:[self secondTransform]];
            popView.modalView.frame = modalViewNewFrame;
            popView.maskView.alpha = 0.4;
            
        } completion:nil];
    }];
}

#pragma mark *** hide ***
- (void)hide
{
    CGRect frame = _modalView.frame;
    frame.origin.y += _modalView.frame.size.height;
    
    [UIView animateWithDuration:kAnimateDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //popView下降
        _modalView.frame = frame;
        _maskView.alpha = 0.2;
        
        [_snapedImageView.layer setTransform:[ZKPopView firstTransform]];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:kAnimateDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            //变为初始值
            [_snapedImageView.layer setTransform:CATransform3DIdentity];
            _maskView.alpha = 0.f;
            
        } completion:^(BOOL finished) {
            
            [self removeFromSuperview];
        }];
    }];
}

+ (CATransform3D)firstTransform{
    CATransform3D t1 = CATransform3DIdentity;
    
    t1.m34 = 1.0/-900;
    
    //带点缩小的效果
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    //绕x轴旋转
    t1 = CATransform3DRotate(t1, 15.0 * M_PI/180.0, 1, 0, 0);
    return t1;
    
}

+ (CATransform3D)secondTransform{
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = [self firstTransform].m34;
    //向上移
    t2 = CATransform3DTranslate(t2, 0, ScreenHeight * (-0.08), 0);
    //第二次缩小
    t2 = CATransform3DScale(t2, 0.8, 0.8, 1);
    return t2;
}

#pragma mark *** Private ***
- (UIImage *)snapshotWithWindow
{
    @autoreleasepool
    {
        UIGraphicsBeginImageContextWithOptions(KeyWindow.bounds.size, YES, [UIScreen mainScreen].scale);
        [KeyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
}

- (void)maskViewDidClick
{
    [self hide];
}

#pragma mark *** Layout ***
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _maskView.frame = ScreenBounds;
    _snapedImageView.frame = ScreenBounds;
}

@end
