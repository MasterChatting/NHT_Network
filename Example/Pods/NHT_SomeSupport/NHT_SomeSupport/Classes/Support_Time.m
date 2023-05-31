//
//  Support_Time.m
//  FireCloudDataPush
//
//  Created by liangyuan on 2019/5/21.
//  Copyright © 2019 HYXF. All rights reserved.
//

#import "Support_Time.h"


NSString * const DateFormatModeDate = @"yyyy-MM-dd";
NSString * const DateFormatModeDateHourMinuteSecond  = @"yyyy-MM-dd HH:mm:ss";
NSString * const DateFormatModeYearAndMonth = @"yyyy-MM";

@implementation Support_Time


#pragma mark - 获取几个月前的时间
/// 获取几个月前的时间
+(NSString *)getPriousorLaterDateWithMonth:(int)month dateFormat:(DateFormatMode)formatMode{
    return [self getPriousorLaterDate:month style:1 dateFormat:formatMode];
}
+(NSString *)getPriousorLaterDateFromDateWithDay:(int)day dateFormat:(DateFormatMode)formatMode{
    return [self getPriousorLaterDate:day style:2 dateFormat:formatMode];
}
/// 获取几年（月、日、时、分、秒）前（后）的时间
+(NSString *)getPriousorLaterDate:(int)number style:(NSInteger)style dateFormat:(DateFormatMode)formatMode{
    NSDateFormatter *formatter = [self createFormate:formatMode];
    
    NSDate *currentDate = [formatter dateFromString:[self getNowTimeDateFormat:formatMode]];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    switch (style) {
        case 0:
            [comps setYear:number];
            break;
        case 1:
            [comps setMonth:number];
            break;
        case 2:
            [comps setDay:number];
            break;
        case 3:
            [comps setHour:number];
            break;
        case 4:
            [comps setMinute:number];
            break;
        case 5:
            [comps setSecond:number];
            break;
        default:
            break;
    }
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:currentDate options:0];
    NSString *agoString = [formatter stringFromDate:mDate];
    return agoString;
}
#pragma mark---时间戳和日期的转换
/// 时间戳（秒值）转换成日期格式
+(NSString *)timeStampToDate:(NSString *)timeStamp dateFormat:(DateFormatMode)formatMode{
    NSTimeInterval interval = [timeStamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [self createFormate:formatMode];
    NSString *dateString = [formatter stringFromDate: date];
    return dateString;
}
+(NSString *)timeStampToDate:(NSString *)timeStamp{
    return [self timeStampToDate:timeStamp dateFormat:DateFormatModeDateHourMinuteSecond];
}
+(NSString *)dateToTimeStamp:(NSString *)dateString dateFormat:(DateFormatMode)formatMode{
    NSDateFormatter *formatter = [self createFormate:formatMode];
    NSDate *date = [formatter dateFromString:dateString]; 
    NSTimeInterval timeStamp = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%.0f", timeStamp];
}
+(NSString *)dateToTimeStamp:(NSString *)dateString{
    return [self dateToTimeStamp:dateString dateFormat:DateFormatModeDateHourMinuteSecond];
}
#pragma mark---获取当前时间
+(NSString *)getNowTimeTimeStampIsMillisecond:(BOOL)isMillisecond{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString;//转为字符型
    if (isMillisecond) {
        timeString = [NSString stringWithFormat:@"%.0f", a*1000];
    }else{
        timeString = [NSString stringWithFormat:@"%.0f", a];
    }
    return timeString;
}

+(NSString *)getNowTimeDateFormat:(DateFormatMode)formatMode{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [self createFormate:formatMode];
    NSString *dateString = [formatter stringFromDate: date];
    return dateString;
}

+(NSDictionary *)getNowTimeDetail{
    NSArray *formatterArr = @[@"yyyy",@"MM",@"dd",@"HH",@"mm",@"ss",DateFormatModeDateHourMinuteSecond,DateFormatModeDate];
    NSArray *formatterArr_Key = @[@"year",@"month",@"day",@"hour",@"minute",@"second",@"date",@"ymd"];
    NSMutableDictionary *timeDetailDic  = [[NSMutableDictionary alloc] init];
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *dateString = @"";
    for (int i = 0 ; i < formatterArr.count; i ++) {
        [formatter setDateFormat:formatterArr[i]];
        dateString = [formatter stringFromDate: date];
        [timeDetailDic setValue:dateString forKey:formatterArr_Key[i]];
    }
    return timeDetailDic;
}

//#pragma mark---其它时间操作
//+(NSString *)compareTimeIntervalWithTimeEarly:(NSString *)timeEarly timeLater:(NSString *)timeLater dateFormat:(DateFormatMode)formatMode{
//    NSInteger timeStampEarly = [[self dateToTimeStamp:timeEarly dateFormat:formatMode] integerValue];
//    NSInteger timeStampLater = [[self dateToTimeStamp:timeLater dateFormat:formatMode] integerValue];
//    return NSIntegerToString(timeStampLater - timeStampEarly);
//}

///判断时间是今天、昨天、更早
+(NSString *)judgeTheDateIsTodayYesterdayOrEarlierWithString:(NSString *)date{
    if (date.length < 10) {
        return @"时间格式必须包含年月日";
    }
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    
    NSString * dateString = [date substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }else
    {
        return @"更早";
    }
}

///获取给定日期是周几
+(NSString *)getTimeWeek:(NSString *)timeString dateFormat:(DateFormatMode)formatMode{
    NSDateFormatter *formatter = [self createFormate:formatMode];
    NSDate *date = [formatter dateFromString:timeString];
    //计算week数
    NSCalendar * myCalendar = [NSCalendar currentCalendar];
    myCalendar.timeZone = [NSTimeZone systemTimeZone];
    NSInteger week = [[myCalendar components:NSCalendarUnitWeekday fromDate:date] weekday];
    if (week == 0) {
        NSLog(@"日期格式有误");
    }
    switch (week) {
        case 1:
        {
            return @"周日";
        }
        case 2:
        {
            return @"周一";
        }
        case 3:
        {
            return @"周二";
        }
        case 4:
        {
            return @"周三";
        }
        case 5:
        {
            return @"周四";
        }
        case 6:
        {
            return @"周五";
        }
        case 7:
        {
            return @"周六";
        }
    }
    return @"";
}
/// 获取指定时间的月份的天数
+(NSInteger)getTimeMonthDay:(NSString *)timeString dateFormat:(DateFormatMode)formatMode{
    NSDateFormatter *formatter = [self createFormate:formatMode];
    NSDate *date = [formatter dateFromString:timeString];
    //获取当月的总天数
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    NSUInteger numberOfDaysInMonth = range.length;
    return numberOfDaysInMonth;
}
///创建NSDateFormatter
+(NSDateFormatter *)createFormate:(DateFormatMode)formatMode{
    NSArray *formatMode_Arr = @[DateFormatModeDate,DateFormatModeYearAndMonth,DateFormatModeDateHourMinuteSecond];
    if (![formatMode_Arr containsObject:formatMode]) {
        NSLog(@"⚠️⚠️⚠️⚠️⚠️⚠️⚠️\n日期格式不对，需要传固定的格式\n⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️");
        formatMode = DateFormatModeDateHourMinuteSecond;
    }
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatMode];
    return formatter;
}

@end
