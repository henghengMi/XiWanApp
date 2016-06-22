//
//  Person.h
//  Just-Do-It
//
//  Created by YuanMiaoHeng on 16/1/27.
//  Copyright © 2016年 LianJiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Person : NSObject

@property(nonatomic, assign) int ID;

@property(nonatomic, copy) NSString * name;

@property(nonatomic, copy)NSString *soundPath;

@property(nonatomic,strong)UIImage *iconImg;

@property(nonatomic, assign,getter=isOfent) BOOL ofent;

@property(nonatomic, assign,getter=isDoneXW) BOOL doneXW;

@property(nonatomic, assign,getter=isInPlaying) BOOL inPlaying;


@end
