//
//  Support_Common.h
//  FireCloudDataPush
//
//  Created by NHT on 2019/11/4.
//  Copyright © 2019 HYXF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

/**
 渐变方式
 
 - IHGradientChangeDirectionLevel:              水平渐变
 - IHGradientChangeDirectionVertical:           竖直渐变
 - IHGradientChangeDirectionUpwardDiagonalLine: 向下对角线渐变
 - IHGradientChangeDirectionDownDiagonalLine:   向上对角线渐变
 */
typedef NS_ENUM(NSInteger, IHGradientChangeDirection) {
    IHGradientChangeDirectionLevel,
    IHGradientChangeDirectionVertical,
    IHGradientChangeDirectionUpwardDiagonalLine,
    IHGradientChangeDirectionDownDiagonalLine,
};

/**
 通用方法
 */
@interface Support_Common : NSObject

/**
 计算图片的大小
 @return 返回一个字典 size大小(直接是double类型) ，desString对大小的描述（比如10MB）
 */
+ (NSDictionary *)calulateImageFileSize:(UIImage *)image;

/// 获取特殊字体的实际名字 lookName 看见的名字 fontType文件后缀
/// @param lookName 看见的名字
+(NSString *)getSpecialTextFontRealName:(NSString *)lookName fontType:(NSString *)fontType;

/// 返回一个设置过行间距或者字间距的字符串 wordSpacing 字间距 大于0变大，小于0变小，等于0不变;lineSpacing 行间距 大于0变大
/// @param oldString 需要设置的文字
/// @param wordSpacing 字间距 大于0变大，小于0变小，等于0不变
/// @param lineSpacing 行间距 大于0变大
+(NSAttributedString *)returnAttributedStringByString:(NSString *)oldString wordSpacing:(NSInteger)wordSpacing lineSpacing:(NSInteger)lineSpacing;

///生成一个纯色图片
+(UIImage*)createImageWithColor:(UIColor*) color;

/// 绘制渐变色的矩形UIImage 或者返回一个颜色
/// @param size 绘制的size
/// @param direction 方向
/// @param startcolor 开始颜色
/// @param endColor 结束颜色
/// @param needImage 是否需要返回一个图片，默认返回一个颜色
+ (id)imageOrColor_colorGradientChangeWithSize:(CGSize)size
                                            direction:(IHGradientChangeDirection)direction
                                           startColor:(UIColor *)startcolor
                                             endColor:(UIColor *)endColor
                                            needImage:(BOOL)needImage;

/// 检查文件或者文件件是否存在
/// @param fileName 文件的名称 也可以是文件夹比如 xxx.txt 或者 /xxx/xxx
+(BOOL)checkFileIsExit:(NSString *)fileName;


///根据Controller名称跳转到下一页
+(void)goNextControllerByName:(NSString *)vcName;

/// 运行时 使用自己的方法替换类的旧方法。使用时，需要自己实现newSelector
/// @param oldSelector 旧方法
/// @param newSelector 新方法
/// @param selector_Original 和旧方法完全一致的方法
/// @param className 类名
+(void)changeSelector:(SEL)oldSelector newSelector:(SEL)newSelector selector_Original:(SEL)selector_Original className:(NSString *)className;

///获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC;


/**
 将数组转换成 json字符以上传服务器
 
 @param array 数组
 @return json字符
 */
+(NSString *)arrayToJSONString:(NSMutableArray *)array;
///json字符转对应类型
+(id)JsonStringToNeedType:(NSString *)jsonString;

//类型识别:将所有的NSNull类型转化成@"<NSNull>
+(id)changeType:(id)myObj;

/*将数据转换成NSString*/
+(NSString *)returnStringWith:(id)oldString;

/// 检查更新needAlert是否需要弹窗 ，如果不需要并且有新版本
/// 会发出一个通知-AppHaveNewVersion
/// @param appID 应用id
/// @param needAlert 是否需要弹窗提示，如果不需要并且有新版本
/// 会发出一个通知-AppHaveNewVersion
+(void)checkNeedUpdate:(NSString *)appID needAlert:(BOOL)needAlert;

/// 判断是否是整数或者小数
/// @param string 需要判断的字符串
/// @param isInt 是否判断 是否为整数
+ (BOOL)isPureFloat:(NSString *)string isInt:(BOOL)isInt;

#pragma mark---保存、获取、删除、编辑数据
///保存到本地 如果保存的数据过多，会造成卡顿现象
+(void)saveUserDefaulValue:(id)value Forkey:(NSString *)key;

///删除NSUserDefaults
+(void)deleteUserDefauKey:(NSString *)key;

/**
 获取本地UserDefaults 数据
 
 @param key 键
 @return 值 返回id类型
 */
+(id)getNSUerDefaultsByKey:(NSString *)key;

#pragma mark---常用字符串非空校验，int、float等转换string
///校验是否是非空字符串
+(BOOL)IsNOTEmptyStr:(id)checkValue;
///校验字符串为空
+(BOOL)IsEmptyStr:(id)checkValue;
///int转字符串
+(NSString *)ToString_Int:(int)value;
///NSInteger转字符串
+(NSString *)ToString_NSInteger:(NSInteger)value;
///float转字符串
+(NSString *)ToString_Float:(float)value;
#pragma mark---生成颜色
/// 生成颜色
/// - Parameter hex: hex值
+(UIColor *)ColorWithHex:(NSString *)hexString;

@end

NS_ASSUME_NONNULL_END
