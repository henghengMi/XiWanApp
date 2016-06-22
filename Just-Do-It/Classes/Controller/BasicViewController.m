//
//  BasicViewController.m
//  Just-Do-It
//
//  Created by YuanMiaoHeng on 16/1/30.
//  Copyright © 2016年 LianJiang. All rights reserved.
//

#import "BasicViewController.h"

#import "MiHeader.h"

#import "UIView+BluerEffect.h"

@interface BasicViewController ()
@property(nonatomic,strong) UIImageView *bgimgView;
@end

@implementation BasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *bgimgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgimgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"bg%d",arc4random_uniform(9)]];
    [self.view insertSubview:bgimgView atIndex:0];
    [bgimgView BluerEffect];
    self.bgimgView = bgimgView;

        // 增加拖拽
        self.view.userInteractionEnabled = YES;
        UIPanGestureRecognizer *panG = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidpan:)];
        [self.view addGestureRecognizer:panG];
  
    
}

- (void)viewDidpan:(UIPanGestureRecognizer*)pan
{
    if (self.canDrag) {
    
    if(pan.state == UIGestureRecognizerStateBegan)
    {
    }
    else if (pan.state == UIGestureRecognizerStateChanged || pan.state == UIGestureRecognizerStateEnded)
    {
        CGPoint translatePoint = [pan translationInView:pan.view];
        
        if (translatePoint.y >50) {
            [self down];
        }
    }

        
    }
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.bgimgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"bg%d",arc4random_uniform(9)]];
}



@end
