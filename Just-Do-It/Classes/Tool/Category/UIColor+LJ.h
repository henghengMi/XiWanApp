//
//  UIColor+LJ.h
//  LJMall
//
//  Created by 袁妙恒 on 15/9/20.
//  Copyright (c) 2015年 蒋林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LJ)

// 背景颜色
+ (UIColor *)LJUserManagerBgColor;

// plceholder 颜色
+ (UIColor *)LJUserManagerTextFilePlaceHolderColor;

// 完成按钮的正常颜色
+ (UIColor *)LJUserManagerDoneButtonNomalColor;

// 完成按钮不能点击时候的颜色
+ (UIColor *)LJUserManagerDoneButtonEnableColor;

/** 浅蓝色 LJ色*/
+ (UIColor *)LJSkyBlueColor;

/** 浅蓝（亮） LJ色*/
+ (UIColor *)LJSkyLightBlueColor;

/** 导航栏颜色*/
+ (UIColor *) LJNavBarBlackColor;

/** 分割线 */
+ (UIColor *) LJDividerGrayColor;

/** 单元格背景浅色 */
+ (UIColor *)LJCellBackColor;

/** 背景浅色 */
+ (UIColor *)LJBackgroundColor;

/** 取随机色 */
+ (UIColor *)randomColor;


/** 文字浅灰色 */
+ (UIColor *)LJWriteOrderTextColor;

/** 238 */
+ (UIColor *)LJGaryColor;

/** Logo橙色**/
+ (UIColor *)LJLogoOrangeColor;

/** 说明的文字颜色 **/
+ (UIColor *)LJSubtitleColor;


/** 商品imgView的背景色 **/
+ (UIColor *)LJGoodsBGColor;

/** tableView的背景颜色 **/
+ (UIColor *)LJTableViewBGColor;

@end
