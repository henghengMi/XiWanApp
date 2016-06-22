//
//  UIColor+LJ.m
//  LJMall
//
//  Created by 袁妙恒 on 15/9/20.
//  Copyright (c) 2015年 蒋林. All rights reserved.
//

#import "UIColor+LJ.h"
#define RGB_Color(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBA_Color(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@implementation UIColor (LJ)

+ (UIColor *)LJUserManagerBgColor {
    return RGB_Color(240, 243, 246);
}

+ (UIColor *)LJUserManagerTextFilePlaceHolderColor {
    return [UIColor lightGrayColor];
}


+ (UIColor *)LJUserManagerDoneButtonNomalColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)LJUserManagerDoneButtonEnableColor
{
    return RGB_Color(28, 195, 210);
}

+ (UIColor *)LJSkyBlueColor
{
    return RGB_Color(0, 160, 180);
}
+ (UIColor *)LJSkyLightBlueColor
{
    return RGB_Color(0, 200, 220);
}

+ (UIColor *)LJNavBarBlackColor
{
    return  RGB_Color(20, 29, 35);
}

+ (UIColor *) LJDividerGrayColor{
    return  RGB_Color(200, 199, 204);
}

+ (UIColor *)LJCellBackColor {
    return RGB_Color(228, 228, 228);
}

+ (UIColor *)LJBackgroundColor {
    return RGB_Color(244, 246, 249);
}

+ (UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

+ (UIColor *)LJWriteOrderTextColor {
    return RGB_Color(87, 87, 87);
}

+ (UIColor *)LJGaryColor {
    return RGB_Color(238, 238, 238);
}

+ (UIColor *)LJLogoOrangeColor
{
    return RGB_Color(225, 125, 8);
}

// add to 12-17
+ (UIColor *)LJSubtitleColor
{
    return RGBA_Color(0, 0, 0, 0.5);
}

+ (UIColor *)LJGoodsBGColor
{
    return RGBA_Color(228, 228, 228, 0.5);
}

+ (UIColor *)LJTableViewBGColor
{
    return RGB_Color(239, 239, 244);
}

@end
