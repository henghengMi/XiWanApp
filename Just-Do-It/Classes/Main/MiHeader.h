

#import "UIColor+LJ.h"
#import "UIView+Extension.h"
#import "Const.h"
#import "MiPop.h"
#import "UIView+BluerEffect.h"


#define BGimgCount 8

/**
 *  RGB颜色
 */
#define RGB_Color(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

/**
 * RGB颜色（可调透明度）
 */
#define RGBA_Color(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
/*
 *  数据本地化
 */

// 随机色
#define MiRandomColor RGB_Color(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
//#define MiRandomColorRGBA(a) RGBAColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), (a))

#define MiRandomColorRGBA(a)   [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:(a)];


#define USERDEFAULTS [NSUserDefaults standardUserDefaults]

/**
 *  DEBUG  模式下打印日志,当前行
 */
#ifdef DEBUG
#define NSLog(format, ...) do {                                                             \
fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");                                               \
} while (0)
#else
#define NSLog(...)
#endif


#define IMAGE(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]
#define self_W self.frame.size.width
#define self_H self.frame.size.height

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height




#define kTotalArrPath [ NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"totalArr"]

#define kOfentArrPath [ NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"OfentArr"]

#define kUnOfentArrPath [ NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"UnOfentArr"]


#define kPlayArrPath [ NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"PlayArr"]
