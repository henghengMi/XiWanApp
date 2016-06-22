//
//  UIView+BluerEffect.m
//  Esc_iOS8毛玻璃模糊
//
//  Created by YuanMiaoHeng on 15/9/8.
//  Copyright (c) 2015年 LianJiang. All rights reserved.
//

#import "UIView+BluerEffect.h"

@implementation UIView (BluerEffect)

- (void)BluerEffect
{
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    effectView.alpha = 0.5;
    effectView.frame = self.bounds;//CGRectMake(0, 0, self.view.frame.size.width, 200);
    [self addSubview:effectView];
    effectView.tag = 10000;
}

- (void)removeBluEffct
{
    UIVisualEffectView *effectView = [self viewWithTag:10000];
    [effectView removeFromSuperview];
}

@end
