//
//  PlayViewController.m
//  Just-Do-It
//
//  Created by YuanMiaoHeng on 16/1/28.
//  Copyright © 2016年 LianJiang. All rights reserved.
//

#import "PlayViewController.h"

#import "MiHeader.h"

#import "Person.h"

#import "UIView+BluerEffect.h"

@interface PlayViewController ()

{
    Person * _mainPerson;
    Person * _subPerson;
}


@property (weak, nonatomic) IBOutlet UIImageView *mainImgView;

@property (weak, nonatomic) IBOutlet UIImageView *subImgView;

@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;

@property (weak, nonatomic) IBOutlet UILabel *titileLabel;

@property (weak, nonatomic) IBOutlet UIImageView *centerImg;

@property (weak, nonatomic) IBOutlet UILabel *centerLabel;



@end

@implementation PlayViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.doneBtn setBackgroundImage:[self imageWithColor:MiRandomColor] forState:(UIControlStateNormal)];
    [self.doneBtn setBackgroundImage:[self imageWithColor:MiRandomColor] forState:(UIControlStateHighlighted)];
}



- (IBAction)show {

    if ([self.doneBtn.currentTitle isEqualToString:@"Show"]) {

        if (self.single) { // 单人
            int mainIndex =  arc4random_uniform((UInt32)self.playArray.count );
            Person *mainP = self.playArray[mainIndex];
            _mainPerson = mainP;
            [self showTwoIconWithMainPerson:mainP subPerson:nil];

            [self btnDidClickAnimationHanddle];
        }
        
        else // 双人
        {
            // 不能点击
            self.doneBtn.enabled = NO;
            
            int mainIndex =  arc4random_uniform((UInt32)self.playArray.count );
            int subIndex = 0;
            while (subIndex == mainIndex )  subIndex = arc4random_uniform((UInt32)self.playArray.count);
            
            /* 算法2
             int subIndex = 0;
             do {
             subIndex = arc4random_uniform((UInt32)self.playArray.count);
             } while (subIndex == mainIndex);
             */
            
            NSLog(@"主下标%d -副下标 %d",mainIndex,subIndex);
            
            Person *mainP = self.playArray[mainIndex];
            Person *subP = self.playArray[subIndex];
            [self showTwoIconWithMainPerson:mainP subPerson:subP];
            
            // 记录2个对象
            _mainPerson = mainP;
            _subPerson = subP;
            
            [self btnDidClickAnimationHanddle];
    }
}
    else if ([self.doneBtn.currentTitle isEqualToString:@"回去吧，散了"])
    {
        int count = (self.single) ? 1 : 2;
        // 通知代理
        [self.delegate playDoneByController:self mainPerson:_mainPerson subPerson:_subPerson presonCount:count];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)btnDidClickAnimationHanddle
{
    // 按钮转变动画
    [UIView animateWithDuration:2.5f animations:^{
        self.doneBtn.alpha = 0;
    } completion:^(BOOL finished) {
        [self.doneBtn setTitle:@"回去吧，散了" forState:(UIControlStateNormal)];
        [UIView animateWithDuration:1.25f animations:^{
            self.doneBtn.alpha = 0.8;
        } completion:^(BOOL finished) {
            self.doneBtn.enabled = YES;
        }];
    }];
}



#pragma mark 展示图片
- (void)showTwoIconWithMainPerson:(Person *)mainPerson subPerson:(Person *)subPerson
{
    // 先慢慢模糊 切换图片再变回正常
    UIVisualEffectView *effectView1 = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    effectView1.alpha = 0;
    UIVisualEffectView *effectView2= [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    effectView2.alpha = 0;
    
 
    if (self.single) {
        [self.centerImg addSubview:effectView1];
        effectView1.frame = self.centerImg.bounds;
    }
    else
    {
        [self.mainImgView addSubview:effectView1];
        [self.subImgView addSubview:effectView2];
        effectView1.frame = self.mainImgView.bounds;
        effectView2.frame = self.subImgView.bounds;

    }
    CGFloat animaitionDuration = 2.5f;
    
    [UIView animateWithDuration:animaitionDuration animations:^{
        effectView1.alpha = 1.5;
        effectView2.alpha = 1.5;
    } completion:^(BOOL finished) {
        if (self.single) {
            self.centerImg.image = mainPerson.iconImg;
        }
        else
        {
            self.mainImgView.image = mainPerson.iconImg;
            self.subImgView.image = subPerson.iconImg;
        }
        [UIView animateWithDuration:animaitionDuration - 1.5 animations:^{
            effectView1.alpha = 0;
            effectView2.alpha = 0;
        } completion:^(BOOL finished) {
//            [effectView1 removeFromSuperview];
//            [effectView2 removeFromSuperview];
            
            if (self.single) {
                self.centerLabel.text = [NSString stringWithFormat:@"幸运儿:%@", mainPerson.name];
            }
            else
            {
                self.mainLabel.text = [NSString stringWithFormat:@"洗碗儿:%@", mainPerson.name];
                self.subLabel.text = [NSString stringWithFormat:@"收拾儿:%@",subPerson.name];
            }
        }];
    }];


    
}


- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.canDrag = YES;
    
    // 基础设置
    self.mainImgView.clipsToBounds = YES;
    self.mainImgView.layer.cornerRadius = 4;
    self.subImgView.clipsToBounds = YES;
    self.subImgView.layer.cornerRadius = 4;
    self.centerImg.clipsToBounds = YES;
    self.centerImg.layer.cornerRadius = 4;
    self.doneBtn.showsTouchWhenHighlighted = YES;
    self.doneBtn.clipsToBounds = YES;
    self.doneBtn.layer.cornerRadius = 4;
    self.doneBtn.alpha = 0.8;
    // 单人处理
    if (self.single) {
        self.centerImg.hidden = NO;
        self.centerLabel.hidden = NO;
        self.subImgView.hidden = YES;
        self.subLabel.hidden = YES;
        self.mainImgView.hidden = YES;
        self.mainLabel.hidden = YES;

        self.titileLabel.text  = @"单人模式";
    }

}

- (void)down
{
    [self back];
}

- (IBAction)back {
    
    if ([self.doneBtn.currentTitle isEqualToString:@"Show"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else // 选人选了出来了
    {
        int count = (self.single) ? 1 : 2;
        // 通知代理
        [self.delegate playDoneByController:self mainPerson:_mainPerson subPerson:_subPerson presonCount:count];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}



@end
