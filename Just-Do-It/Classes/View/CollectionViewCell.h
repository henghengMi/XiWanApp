//
//  CollectionViewCell.h
//  Just-Do-It
//
//  Created by YuanMiaoHeng on 16/1/27.
//  Copyright © 2016年 LianJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface CollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *doneImgView;


@property(strong,nonatomic) Person *p;
@end
