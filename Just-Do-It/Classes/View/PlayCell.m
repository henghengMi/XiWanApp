//
//  PlayCell.m
//  Just-Do-It
//
//  Created by apple on 16/1/27.
//  Copyright © 2016年 LianJiang. All rights reserved.
//

#import "PlayCell.h"

@interface PlayCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@end
@implementation PlayCell

- (void)awakeFromNib {


}

- (void)setP:(Person *)p
{
    _p = p;
    
    self.imgView.image = p.iconImg;
}

@end
