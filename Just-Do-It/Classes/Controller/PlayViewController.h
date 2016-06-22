//
//  PlayViewController.h
//  Just-Do-It
//
//  Created by YuanMiaoHeng on 16/1/28.
//  Copyright © 2016年 LianJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"

@class PlayViewController;
@class Person;
@protocol PlayViewControllerDelegate <NSObject>

- (void)playDoneByController:(PlayViewController *)controller mainPerson:(Person *)mainPerson subPerson:(Person *)subPerson presonCount:(int)personCount;
//- (void)playDoneByController:(PlayViewController *)controller mainPerson:(Person *)mainPerson ;

@end


@interface PlayViewController : BasicViewController

@property(nonatomic, strong) NSArray * playArray ;

@property(nonatomic, weak) id <PlayViewControllerDelegate> delegate;

@property(nonatomic,assign,getter=isSingle) BOOL single;

@end
