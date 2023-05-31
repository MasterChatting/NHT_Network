//
//  Support_StringHexDataChange.m
//  
//
//  Created by NHT on 2019/8/29.
//  Copyright © 2019 alex. All rights reserved.
//

#import "Support_StringHexDataChange.h"
#import "NHT_SomeSupport.h"

@implementation Support_StringHexDataChange


+(NSString *)hexChangeToDecimal:(NSString *)hexString{
    //16进制转换10进制字符串
//       NSLog(@"第%d字节%@转成的10进制字符串:%lu",i,sixString,strtoul(sixString.UTF8String, 0, 16));
    NSString *decimalString =  [[NSString alloc] initWithFormat:@"%lu",strtoul(hexString.UTF8String, 0, 16)];
    return decimalString;
}

+(NSString *)decimalStringChangeToHex:(NSString *)decimalString{
    //10进制字符串转成16进制字符串
//    %x" 就是十六进制输出，如果换成大写"%X"，相应的字符串结果也会换成大写
    NSString *hexString =  [[NSString alloc] initWithFormat:@"%x",[decimalString intValue]];
    return hexString;
}


+(NSString *)hexDataToHexStrig:(NSData *)data{
    //16进制的NSData转化16进制的字符串
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
//     NSLog(@"转化的16进制%@",string);
    return string;
}

+(NSData *)convertHexStringToData:(NSString *)hexString{
    //16进制字符串转data
    if (!hexString || [hexString length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:20];
    NSRange range;
    if ([hexString length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [hexString length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [hexString substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}


//+(Byte)stringToByte:(NSString*)string {
//    Byte bytes[16] = {0};
//    NSString *hexString=[[string uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
//    if ([hexString length]%2!=0) {
//        return bytes;
//    }
//
//    int j=0;
//    for(int i=0;i<[hexString length];i++) {
//        int int_ch;
//        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
//        int int_ch1;
//        if(hex_char1 >= '0' && hex_char1 <='9')
//            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
//        else if(hex_char1 >= 'A' && hex_char1 <='F')
//            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
//        else
//            return bytes;
//        i++;
//
//        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
//        int int_ch2;
//        if(hex_char2 >= '0' && hex_char2 <='9')
//            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
//        else if(hex_char2 >= 'A' && hex_char2 <='F')
//            int_ch2 = hex_char2-55; //// A 的Ascll - 65
//        else
//            return bytes;
//
//        int_ch = int_ch1+int_ch2;  ///将转化后的数放入Byte数组里
//        NSLog(@"int_ch=%d",int_ch);
//        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
//        j++;
//
//    }
//    return bytes;
//}

+(NSData *)decimalStringToHexData:(NSString *)decimalString{
//     10进制的字符串直接转成16进制的NSData
    return  [self convertHexStringToData:[self decimalStringChangeToHex:decimalString]];
}
+(NSString *)hexDataToDecimalString:(NSData *)hexData{
    //   16进制data 直接转换成正常字符串
    return  [self hexChangeToDecimal:[self hexDataToHexStrig:hexData]];
}


+(NSData *)changeHexDataToLowBitFirst:(NSData *)oldHexData needLength:(NSInteger)needLength{
    NSMutableData *newHexData = [[NSMutableData alloc] init];
    NSInteger maxNumber = oldHexData.length -1;
    for (NSInteger i = maxNumber; i >= 0 ; i --) {
        NSData *realData = [[oldHexData subdataWithRange:NSMakeRange(i, 1)] copy];
        [newHexData appendData:realData];
    }
//    while ( needLength > oldHexData.length + newHexData.length ) {
//        [newHexData appendData:[self decimalStringToHexData:@"0"]];
//    }
    return newHexData;
}


+(NSData *)changeHexDataToHighBitFirst:(NSData *)oldHexData{
    /*将低字节在前的16进制转成 高字节在前 */
    NSMutableData *newHexData = [[NSMutableData alloc] init];
    NSInteger maxNumber = oldHexData.length -1;
    for (NSInteger i = maxNumber; i >= 0 ; i --) {
        NSData *realData = [[oldHexData subdataWithRange:NSMakeRange(i, 1)] copy];
            [newHexData appendData:realData];
    }
    return newHexData;
}
+(NSInteger )LowFirstHexDataChangeToDecimaString:(NSData *)lowHexData{
    //直接将低字节在前的16进制data转换成10进制字符串
    NSString *decimaString = @"";
    NSData *highData = [self changeHexDataToHighBitFirst:lowHexData];
    decimaString = [self hexDataToDecimalString:highData];

    if ([Support_Common IsEmptyStr:decimaString]) {
        return 0;
    }
    return [decimaString integerValue];
}

+(NSData *)decimalStrignChangeToHexData_LowFirst:(NSString *)decimalString{
    return  [self changeHexDataToLowBitFirst:[self decimalStringToHexData:decimalString] needLength:0];
}


#pragma mark 十进制转二进制
+(NSString *)decimaStringToBinarySystem:(NSString *)decimal{
    //十进制转二进制
    NSInteger num = [decimal intValue];
    long int remainder = 0;      //余数
    long int divisor = 0;        //除数
    
    NSString * prepare = @"";
    
    while (true){
        
        remainder = num%2;
        divisor = num/2;
        num = divisor;
        prepare = [prepare stringByAppendingFormat:@"%ld",remainder];
        
        if (divisor == 0){
            
            break;
        }
    }
    
    NSString * result = @"";
    
    for (long int i = prepare.length - 1; i >= 0; i --){
        
        result = [result stringByAppendingFormat:@"%@",
                  [prepare substringWithRange:NSMakeRange(i , 1)]];
    }
    
    return result;
}

+(NSString *)hexDataToBinarySystemData:(NSData *)hexData{
    //十六进制转二进制
    NSString *decimString = [self hexDataToDecimalString:hexData];
    return [self decimaStringToBinarySystem:decimString];
}

/**
 转化为十进制

 @param binary 二进制的数据
 @return 数据结果
 */
+ (NSString *)binarySystemToDecimaString:(NSString *)binary
{
    long int ll = 0 ;
    NSInteger  temp = 0 ;
    for (NSInteger i = 0; i < binary.length; i ++){
        
        temp = [[binary substringWithRange:NSMakeRange(i, 1)] intValue];
        temp = temp * powf(2, binary.length - i - 1);
        ll += temp;
    }
    
    NSString * result = [NSString stringWithFormat:@"%ld",ll];
    
    return result;
}

+(NSString *)binarySystemToHexString:(NSString *)binaryStr{
    return [self decimalStringChangeToHex:[self binarySystemToDecimaString:binaryStr]];
}



@end
