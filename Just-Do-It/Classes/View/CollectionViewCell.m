//
//  CollectionViewCell.m
//  Just-Do-It
//
//  Created by YuanMiaoHeng on 16/1/27.
//  Copyright © 2016年 LianJiang. All rights reserved.
//

#import "CollectionViewCell.h"

#import "UIView+BluerEffect.h"

#import "MiHeader.h"

@interface CollectionViewCell()

@property (weak, nonatomic) IBOutlet UIView *coverView;


@end

@implementation CollectionViewCell

- (void)awakeFromNib {
    
//    self.coverView.backgroundColor = MiRandomColorRGBA(0.6);
}

- (void)setP:(Person *)p
{
    _p = p;
    
    self.imgView.image = p.iconImg;
    self.nameLabel.text = p.name;
    self.doneImgView.hidden = !p.isDoneXW;
    self.coverView.hidden = !p.isInPlaying;
    self.nameLabel.textColor = (p.isDoneXW) ? [UIColor redColor] : [UIColor whiteColor];
    
//    NSLog(@"playing ：%d",p.isInPlaying);
}

@end
