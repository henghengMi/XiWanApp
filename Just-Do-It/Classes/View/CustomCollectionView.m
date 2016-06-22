//
//  CustomCollectionView.m
//  Just-Do-It
//
//  Created by apple on 16/1/27.
//  Copyright © 2016年 LianJiang. All rights reserved.
//



#import "CustomCollectionView.h"

@implementation CustomCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    
    UICollectionViewFlowLayout  *ofentlayout = [[UICollectionViewFlowLayout alloc] init];
    ofentlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    ofentlayout.itemSize = CGSizeMake(80, 80);
    ofentlayout.sectionInset = UIEdgeInsetsMake(10, 10,  10, 10) ; // 边缘内边距
    
    if (self = [super initWithFrame:frame collectionViewLayout:ofentlayout]) {
        
        
        
    }
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame forPalycollectionViewLayout:(UICollectionViewLayout *)layout
{
    UICollectionViewFlowLayout  *ofentlayout = [[UICollectionViewFlowLayout alloc] init];
    ofentlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    ofentlayout.itemSize = CGSizeMake(60, 60);
    ofentlayout.sectionInset = UIEdgeInsetsMake(5, 5,  5, 5) ; // 边缘内边距
//    ofentlayout.minimumLineSpacing = 100;
    if (self = [super initWithFrame:frame collectionViewLayout:ofentlayout]) {
        
        
        
    }
    return self;
}

@end
