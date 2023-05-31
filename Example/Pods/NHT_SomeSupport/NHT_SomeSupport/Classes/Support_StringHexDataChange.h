//
//  Support_StringHexDataChange.h
//
//
//  Created by NHT on 2019/8/29.
//  Copyright © 2019 alex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Support_StringHexDataChange : NSObject


@property (nonatomic, assign) NSUInteger  whichPartData;//是第几部分的数据 上传或者下载文件使用

/**
 16进制转换10进制字符串
 */
+(NSString *)hexChangeToDecimal:(NSString *)hexString;

/**
 10进制字符串转成16进制字符串
 */
+(NSString *)decimalStringChangeToHex:(NSString *)decimalString;

/**
 16进制的NSData转化16进制的字符串
 */
+(NSString *)hexDataToHexStrig:(NSData *)data;

/**
 16进制字符串转data
 */
+(NSData *)convertHexStringToData:(NSString *)hexString;

/**
 10进制的字符串直接转成16进制的NSData
 */
+(NSData *)decimalStringToHexData:(NSString *)decimalString;

/**
 16进制data 直接转换成正常字符串
 */
+(NSString *)hexDataToDecimalString:(NSData *)hexData;



/**
 将16进制data 转换成 低字节在前的16进制data needLength 目标字节数
 */
+(NSData *)changeHexDataToLowBitFirst:(NSData *)oldHexData needLength:(NSInteger)needLength;


/**
 将16进制data 转换成 ***高高高***字节在前的16进制data 
 */
+(NSData *)changeHexDataToHighBitFirst:(NSData *)oldHexData;


/**
 直接将低字节在前的16进制data转换成10进制数字
 */
+(NSInteger )LowFirstHexDataChangeToDecimaString:(NSData *)lowHexData;

/*
 直接将10进制字符串转换成 **低字节在前**的16进制data
 */
+(NSData *)decimalStrignChangeToHexData_LowFirst:(NSString *)decimalString;



/**十进制转二进制*/
+(NSString *)decimaStringToBinarySystem:(NSString *)decimal;

/**
 十六进制转二进制
 */
+(NSString *)hexDataToBinarySystemData:(NSData *)hexData;
    
///二进制转16进制
+(NSString *)binarySystemToHexString:(NSString *)binaryStr;

/// 二进制转十进制
+ (NSString *)binarySystemToDecimaString:(NSString *)binary;

@end

NS_ASSUME_NONNULL_END
