//
//  Support_Time.h
//  FireCloudDataPush
//
//  Created by liangyuan on 2019/5/21.
//  Copyright © 2019 HYXF. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 一些时间相关的方法
 YYYY 是按照周来计算时间，今天是12月29号周天，从今天开始就是进入了2020年了，这个时间计算方式是，一年当中的时间，不足一周的(年末那一周)，就要计算到下一年中去，就变成了2020年了，月份也是12月这个对的，天也是对的。
 yyyy是按照天来计算的，今天是12月29号，也是2019年
 
 y      将年份 (0-9) 显示为不带前导零的数字。如果这是用户定义的数字格式中的唯一字符，请使用 %y。
 yy     以带前导零的两位数字格式显示年份（如果适用）。
 yyy    以四位数字格式显示年份。
 yyyy   以四位数字格式显示年份。
 
 M     将月份显示为不带前导零的数字（如一月表示为1）。如果这是用户定义的数字格式中的唯一字符，请使用 %M。
 MM     将月份显示为带前导零的数字（例如 01/12/01）。
 MMM    将月份显示为缩写形式（例如 Jan）。
 MMMM       将月份显示为完整月份名（例如 January）。
 
 d  将日显示为不带前导零的数字（如 1）。如果这是用户定义的数字格式中的唯一字符，请使用 %d。
 dd    将日显示为带前导零的数字（如 01）。
 
 h  使用 12 小时制将小时显示为不带前导零的数字（例如 1:15:15 PM）。如果这是用户定义的数字格式中的唯一字符，请使用 %h。
 hh 使用 12 小时制将小时显示为带前导零的数字（例如 01:15:15 PM）。
 H  使用 24 小时制将小时显示为不带前导零的数字（例如 1:15:15）。如果这是用户定义的数字格式中的唯一字符，请使用 %H。
 HH     使用 24 小时制将小时显示为带前导零的数字（例如 01:15:15）。

 m      将分钟显示为不带前导零的数字（例如 12:1:15）。如果这是用户定义的数字格式中的唯一字符，请使用 %m。
 mm     将分钟显示为带前导零的数字（例如 12:01:15）。

 s      将秒显示为不带前导零的数字（例如 12:15:5）。如果这是用户定义的数字格式中的唯一字符，请使用 %s。
 ss     将秒显示为带前导零的数字（例如 12:15:05）。
 
 (:)
 时间分隔符。在某些区域设置中，可以使用其他字符表示时间分隔符。时间分隔符在格式化时间值时分隔小时、分钟和秒。格式化输出中用作时间分隔符的实际字符由您的应用程序的当前区域性值确定。

 (/)
 日期分隔符。在某些区域设置中，可以使用其他字符表示日期分隔符。日期分隔符在格式化日期值时分隔日、月和年。格式化输出中用作日期分隔符的实际字符由您的应用程序的当前区域性确定。

 (%)
 用于表明不论尾随什么字母，随后字符都应该以单字母格式读取。也用于表明单字母格式应以用户定义格式读取。有关更多详细信息，请参见下面的内容。

 EEE 将日显示为缩写形式（例如 Sun）。
 EEEE   将日显示为全名（例如 Sunday）。

 gg     显示时代/纪元字符串（例如 A.D.）

 f      显示秒的小数部分。例如，ff 将精确显示到百分之一秒，而 ffff 将精确显示到万分之一秒。用户定义格式中最多可使用七个 f 符号。如果这是用户定义的数字格式中的唯一字符，请使用 %f。

 t      使用 12 小时制，并对中午之前的任一小时显示大写的 A，对中午到 11:59 P.M 之间的任一小时显示大写的 P。如果这是用户定义的数字格式中的唯一字符，请使用 %t。
 tt     对于使用 12 小时制的区域设置，对中午之前任一小时显示大写的 AM，对中午到 11:59 P.M 之间的任一小时显示大写的 PM。
    对于使用 24 小时制的区域设置，不显示任何字符。

 z      显示不带前导零的时区偏移量（如 -8）。如果这是用户定义的数字格式中的唯一字符，请使用 %z。
 zz     显示带前导零的时区偏移量（例如 -08）
 zzz    显示完整的时区偏移量（例如 -08:00）

 
 */

//typedef NS_ENUM(NSInteger,DateFormatModeMine) {
//   DateFormatModeYear, //年
//   DateFormatModeYearAndMonth, //年月
//   DateFormatModeDate, //年月日
//   DateFormatModeDateHour, //年月日时
//   DateFormatModeDateHourMinute, //年月日时分
//   DateFormatModeDateHourMinuteSecond, //年月日时分秒
//   DateFormatModeMonthDay, //月日
//   DateFormatModeMonthDayHour, //月日时
//   DateFormatModeMonthDayHourMinute, //月日时分
//   DateFormatModeMonthDayHourMinuteSecond, //月日时分秒
//   DateFormatModeTime, //时分
//   DateFormatModeTimeAndSecond, //时分秒
//   DateFormatModeMinuteAndSecond, //分秒
//   DateFormatModeDateAndTime //月日周 时分
//};

/// 定义一个DateFormatMode的字符串类型作为枚举类型
typedef NSString *DateFormatMode NS_STRING_ENUM;
/// 声明以下三个枚举值

/// 年月
FOUNDATION_EXPORT DateFormatMode const DateFormatModeYearAndMonth;
/// 年月日
FOUNDATION_EXPORT DateFormatMode const DateFormatModeDate;
/// 年月日时分秒
FOUNDATION_EXPORT DateFormatMode const DateFormatModeDateHourMinuteSecond;

@interface Support_Time : NSObject

#pragma mark---获取几年（月、日、时、分、秒）前（后）的时间

/// 获取几个月前或后的时间
/// @param month 几个月前的，传成负数就是几个月后的
/// @param formatMode 返回的时间格式 比如 yyyy-MM-dd HH:mm:ss
+(NSString *)getPriousorLaterDateWithMonth:(int)month dateFormat:(DateFormatMode)formatMode;

/// 获取当前时间几天前或后的时间
/// @param day 几天前，负数为几天后
/// @param formatMode 返回的时间格式  比如 yyyy-MM-dd HH:mm:ss
+(NSString *)getPriousorLaterDateFromDateWithDay:(int)day dateFormat:(DateFormatMode)formatMode;

/// 获取几年（月、日、时、分、秒）前（后）的时间
/// @param number 相差数量，正数为当前时间前，负数为后
/// @param style 0年 1月 2日 3时 4分 5秒
/// @param formatMode 返回的时间格式 yyyy-MM-dd HH:mm:ss
+(NSString *)getPriousorLaterDate:(int)number style:(NSInteger)style dateFormat:(DateFormatMode)formatMode;


#pragma mark---时间戳和日期的转换

/// 时间戳（秒值）转换成日期格式
/// @param timeStamp 时间戳
/// @param formatMode 日期格式
+(NSString *)timeStampToDate:(NSString *)timeStamp dateFormat:(DateFormatMode)formatMode;

/// 时间戳（秒值）转换成日期格式（yyyy-MM-dd HH:mm:ss）
/// @param timeStamp 时间戳
+(NSString *)timeStampToDate:(NSString *)timeStamp;

/// 日期转换成时间戳（秒值）
/// @param dateString 日期时间
/// @param formatMode 时间格式
+(NSString *)dateToTimeStamp:(NSString *)dateString dateFormat:(DateFormatMode)formatMode;
/// 日期（yyyy-MM-dd HH:mm:ss）转换成时间戳（秒值）
/// @param dateString 日期时间
+(NSString *)dateToTimeStamp:(NSString *)dateString;

#pragma mark---获取当前时间

/// 获取当前时间戳，可以选择是否是毫秒值
/// @param isMillisecond 是否是毫秒值
+(NSString *)getNowTimeTimeStampIsMillisecond:(BOOL)isMillisecond;

/// 获取当前时间
/// @param formatMode 时间格式 yyyy-MM-dd HH:mm:ss
+(NSString *)getNowTimeDateFormat:(DateFormatMode)formatMode;

/// 获取当前时间的 年、月、日、时、分、秒
+(NSDictionary *)getNowTimeDetail;


#pragma mark---其它时间操作

///// 对比两个时间之差：秒
///// @param timeEarly 较早时间
///// @param timeLater 较晚时间
///// @param formatMode 时间格式
//+ (NSString *)compareTimeIntervalWithTimeEarly:(NSString *)timeEarly timeLater:(NSString *)timeLater dateFormat:(DateFormatMode)formatMode;

/**  判断时间是今天、昨天、更早  时间格式必须包含年月日*/
+(NSString *)judgeTheDateIsTodayYesterdayOrEarlierWithString:(NSString *)date;

/// 获取给定日期是周几
/// @param timeString 时间
/// @param formatMode 时间格式
+(NSString *)getTimeWeek:(NSString *)timeString dateFormat:(DateFormatMode)formatMode;

/// 获取指定时间的月份的天数
/// @param timeString 时间
/// @param formatMode 时间格式
+(NSInteger)getTimeMonthDay:(NSString *)timeString dateFormat:(DateFormatMode)formatMode;



@end

NS_ASSUME_NONNULL_END
