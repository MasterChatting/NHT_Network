//
//  Support_Common.m
//  FireCloudDataPush
//
//  Created by NHT on 2019/11/4.
//  Copyright © 2019 HYXF. All rights reserved.
//

#import "Support_Common.h"
#import <objc/runtime.h>

@implementation Support_Common

#pragma mark---计算图片大小
+ (NSDictionary *)calulateImageFileSize:(UIImage *)image{
    NSData *data = UIImagePNGRepresentation(image);
    if (!data) {
        data = UIImageJPEGRepresentation(image, 0.5);//需要改成0.5才接近原图片大小，原因请看下文
    }
    double dataLength = [data length] * 1.0;
    NSArray *typeArray = @[@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB",@"ZB",@"YB"];
    NSInteger index = 0;
    while (dataLength > 1024) {
        dataLength /= 1024.0;
        index ++;
    }
    NSString *desString = [NSString stringWithFormat:@"image = %.3f %@",dataLength,typeArray[index]];
    NSMutableDictionary *returnDic = [[typeArray[index] alloc] init];
    [returnDic setValue:@(dataLength) forKey:@"size"];
    //    [returnDic setValue:typeArray[index] forKey:@"unit"];
    [returnDic setValue:desString forKey:@"desString"];
    
    return returnDic;
}
#pragma mark---获取特殊字体的实际名称
+(NSString *)getSpecialTextFontRealName:(NSString *)lookName fontType:(NSString *)fontType{
    //    https://www.jianshu.com/p/a4935e6427ec
    //需要在info.plist中添加一下字体文件
    NSString *path = [[NSBundle mainBundle] pathForResource:lookName ofType:fontType];
    NSURL *fontUrl = [NSURL fileURLWithPath:path];
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
    return fontName;
}
#pragma mark---生成一个富文本
+(NSAttributedString *)returnAttributedStringByString:(NSString *)oldString wordSpacing:(NSInteger)wordSpacing lineSpacing:(NSInteger)lineSpacing{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:oldString];
    [attributedString addAttribute:NSKernAttributeName value:@(wordSpacing) range:NSMakeRange(0, oldString.length)];//设置文字之间的间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;//行间距
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingMiddle];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [oldString length])];
    
    return attributedString;
}
#pragma mark--- 生成一个纯色图片
+(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
#pragma mark--- 生成一个渐变色
+ (id)imageOrColor_colorGradientChangeWithSize:(CGSize)size
                                     direction:(IHGradientChangeDirection)direction
                                    startColor:(UIColor *)startcolor
                                      endColor:(UIColor *)endColor
                                     needImage:(BOOL)needImage{
    
    if (CGSizeEqualToSize(size, CGSizeZero) || !startcolor || !endColor) {
        return nil;
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    
    CGPoint startPoint = CGPointZero;
    if (direction == IHGradientChangeDirectionDownDiagonalLine) {
        startPoint = CGPointMake(0.0, 1.0);
    }
    gradientLayer.startPoint = startPoint;
    
    CGPoint endPoint = CGPointZero;
    switch (direction) {
        case IHGradientChangeDirectionLevel:
            endPoint = CGPointMake(1.0, 0.0);
            break;
        case IHGradientChangeDirectionVertical:
            endPoint = CGPointMake(0.0, 1.0);
            break;
        case IHGradientChangeDirectionUpwardDiagonalLine:
            endPoint = CGPointMake(1.0, 1.0);
            break;
        case IHGradientChangeDirectionDownDiagonalLine:
            endPoint = CGPointMake(1.0, 0.0);
            break;
        default:
            break;
    }
    gradientLayer.endPoint = endPoint;
    
    gradientLayer.colors = @[(__bridge id)startcolor.CGColor, (__bridge id)endColor.CGColor];
    UIGraphicsBeginImageContext(size);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (needImage) {
        return image;
    }else{
        return [UIColor colorWithPatternImage:image];
    }
}

#pragma mark---检查文件是否存在
+(BOOL)checkFileIsExit:(NSString *)fileName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fullPath;
    if (fileName.length>1 && [[fileName substringToIndex:1] isEqualToString:@"/"]) {
        fullPath = [filePath stringByAppendingString:fileName];
    }else{
        fullPath = [filePath stringByAppendingPathComponent:fileName];
    }
    
    if([fileManager fileExistsAtPath:fullPath]) {
        return YES;
    }
    return NO;
}

#pragma mark--- 根据Controller名称跳转到下一页
+(void)goNextControllerByName:(NSString *)vcName{
    UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
    [[self getCurrentVC].navigationController pushViewController:vc animated:YES];
}
#pragma mark--- 运行时 替换旧方法
+(void)changeSelector:(SEL)oldSelector newSelector:(SEL)newSelector selector_Original:(SEL)selector_Original className:(NSString *)className{
    
    // 获取到 类中 对应的method
    Method selector_Old = class_getInstanceMethod(NSClassFromString(className), oldSelector);
    Method selector_New =class_getInstanceMethod(NSClassFromString(className),newSelector);
    
    // 将目标函数的原实现绑定到selector_Original方法上
    IMP setTextImp = method_getImplementation(selector_Old);
    class_addMethod(NSClassFromString(className), selector_Original, setTextImp,method_getTypeEncoding(selector_Old));
    
    //然后用我们自己的函数的实现，替换目标函数对应的实现
    IMP setTextMySelfImp =method_getImplementation(selector_New);
    class_replaceMethod(NSClassFromString(className), oldSelector, setTextMySelfImp,method_getTypeEncoding(selector_Old));
}
#pragma mark---获取当前屏幕显示的viewcontroller
//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]){
        result = nextResponder;
    }else{
        result = window.rootViewController;
    }
    
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}

#pragma mark---数组转json json字符转对应类型
//数组转json
+(NSString *)arrayToJSONString:(NSMutableArray *)array
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}
///json字符转对应类型
+(id)JsonStringToNeedType:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                             options:NSJSONReadingMutableContainers
                                               error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
#pragma mark---数据转换成字符串 替换所有的空值
//类型识别:将所有的NSNull类型转化成@"<NSNull>
+(id)changeType:(id)myObj
{
    if ([myObj isKindOfClass:[NSDictionary class]])
    {
        return [self nullDic:myObj];
    }
    else if([myObj isKindOfClass:[NSArray class]])
    {
        return [self nullArr:myObj];
    }
    else if([myObj isKindOfClass:[NSString class]])
    {
        return [self stringToString:myObj];
    }
    else if([myObj isKindOfClass:[NSNull class]])
    {
        return [self nullToString];
    }
    else
    {
        return [self returnStringWith:myObj];
    }
}
//将NSDictionary中的Null类型的项目转化成@"<NSNull>
+(NSDictionary *)nullDic:(NSDictionary *)myDic
{
    NSArray *keyArr = [myDic allKeys];
    NSMutableDictionary *resDic = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < keyArr.count; i ++)
    {
        id obj = [myDic objectForKey:keyArr[i]];
        obj = [self changeType:obj];
        [resDic setObject:obj forKey:keyArr[i]];
    }
    return resDic;
}

//将NSArray中的Null类型的项目转化成@"<NSNull>
+(NSArray *)nullArr:(NSArray *)myArr
{
    NSMutableArray *resArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < myArr.count; i ++)
    {
        id obj = myArr[i];
        obj = [self changeType:obj];
        [resArr addObject:obj];
    }
    return resArr;
}

//将NSString类型的原路返回
+(NSString *)stringToString:(NSString *)string
{
    if ([string isEqualToString:@"<NSNull>"]) {
        return @"";
    }
    if([self IsNOTEmptyStr:[self returnStringWith:string]]){
        return string;
    }else{
        return @"";
    }
}
/*将数据转换成NSString*/
+(NSString *)returnStringWith:(id)oldString
{
    if([oldString isKindOfClass:[NSNull class]] || oldString == nil || oldString == NULL){
        return @"";
    }
    if ([oldString isKindOfClass:[NSString class]]) {
        if([self IsEmptyStr:oldString]){
            return @"";//将为空的字符返回为@“”
        }
    }
    return [NSString stringWithFormat:@"%@",oldString];
}
//将Null类型的项目转化成@"<NSNull>
+(NSString *)nullToString
{
    //    return @"<NSNull>";
    return @"";
}
#pragma mark---检查更新
+(void)checkNeedUpdate:(NSString *)appID needAlert:(BOOL)needAlert{
    NSString *urlString= [@"https://itunes.apple.com/cn/lookup?id=" stringByAppendingString:appID];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    //任务默认是挂起
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *array = json[@"results"];
            NSString *newVersion ;
            BOOL needUpdate = NO;
            for (NSDictionary *dic in array) {
                newVersion = [dic valueForKey:@"version"]; // appStore 的版本号
            }
            
            if ([self IsNOTEmptyStr:newVersion]) {
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                if (newVersion.length > appCurVersionNum.length) {
                    //App Store上的长度大于本地的 就更新
                    needUpdate = YES;
                }else {
                    newVersion = [newVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
                    appCurVersionNum = [appCurVersionNum stringByReplacingOccurrencesOfString:@"." withString:@""];
                    
                    /*保证长度一致*/
                    while (newVersion.length < appCurVersionNum.length) {
                        newVersion =  [newVersion stringByAppendingString:@"0"];
                    }
                    while (appCurVersionNum.length < newVersion.length) {
                        appCurVersionNum =  [appCurVersionNum stringByAppendingString:@"0"];
                    }
                    
                    NSInteger appStoreV = [newVersion  integerValue];
                    NSInteger localV = [appCurVersionNum integerValue];
                    if (appStoreV > localV) {
                        needUpdate = YES;
                    }
                }
                
            }
            
            if (needUpdate) {
                if (!needAlert) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"AppHaveNewVersion" object:nil];
                    return;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"检查到应用有新版本，请前去升级!" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"itms-apps://itunes.apple.com/app/id" stringByAppendingString:appID]]];
                        abort();
                    }]];
                    [[Support_Common getCurrentVC] presentViewController:alert animated:YES completion:nil];
                });
            }
        }
    }];
    //开始任务
    [dataTask resume];
}
#pragma mark--- 判断是否是整数或者小数
+ (BOOL)isPureFloat:(NSString *)string isInt:(BOOL)isInt{
    if ([self IsEmptyStr:string]) {
        return NO;
    }
    NSScanner* scan = [NSScanner scannerWithString:string];
    if (isInt) {
        int val;
        return [scan scanInt:&val] && [scan isAtEnd];
    }else{
        float val;
        return [scan scanFloat:&val] && [scan isAtEnd];
    }
}
#pragma mark---保存、获取、删除、编辑数据
+(void)saveUserDefaulValue:(id)value Forkey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    //避免存的是nsnull 等
    //    [[NSUserDefaults standardUserDefaults] setObject:[Support_NetWork changeType:value] forKey:key];
}
+(void)deleteUserDefauKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}
+(id)getNSUerDefaultsByKey:(NSString *)key{
    id returnMes =  [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return  returnMes;
}

#pragma mark---常用字符串非空校验，int、float等转换string
///校验是否是非空字符串
+(BOOL)IsNOTEmptyStr:(id)checkValue{
    if((checkValue == nil || checkValue == NULL || [checkValue isKindOfClass:[NSNull class]] || [[checkValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] ==0 )){
        return NO;
    }
    return YES;
}
+(BOOL)IsEmptyStr:(id)checkValue{
    return ! [self IsNOTEmptyStr:checkValue];
}
+(NSString *)ToString_Int:(int)value{
    return [NSString stringWithFormat:@"%d",value];
}
+(NSString *)ToString_NSInteger:(NSInteger)value{
    return [NSString stringWithFormat:@"%ld",value];
}
+(NSString *)ToString_Float:(float)value{
    return [NSString stringWithFormat:@"%f",value];
}
#pragma mark---生成颜色
+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger) length {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}
+ (UIColor *)ColorWithHex:(NSString *)hexString {
    CGFloat alpha, red, blue, green;
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    switch ([colorString length]) {
        case 3: // #RGB
        {
            alpha = 1.0f;
            red = [self colorComponentFrom:colorString start:0 length:1];
            green = [self colorComponentFrom:colorString start:1 length:1];
            blue = [self colorComponentFrom:colorString start:2 length:1];
        }
            break;
            
        case 4: // #ARGB
        {
            alpha = [self colorComponentFrom:colorString start:0 length:1];
            red   = [self colorComponentFrom:colorString start:1 length:1];
            green = [self colorComponentFrom:colorString start:2 length:1];
            blue  = [self colorComponentFrom:colorString start:3 length:1];
        }
            break;
            
        case 6: // #RRGGBB
        {
            alpha = 1.0f;
            red = [self colorComponentFrom:colorString start:0 length:2];
            green = [self colorComponentFrom:colorString start:2 length:2];
            blue  = [self colorComponentFrom:colorString start:4 length:2];
        }
            break;
            
        case 8: // #AARRGGBB
        {
            alpha = [self colorComponentFrom:colorString start:0 length:2];
            red = [self colorComponentFrom:colorString start:2 length:2];
            green = [self colorComponentFrom:colorString start:4 length:2];
            blue  = [self colorComponentFrom:colorString start:6 length:2];
        }
            break;
        default:
            return nil;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
