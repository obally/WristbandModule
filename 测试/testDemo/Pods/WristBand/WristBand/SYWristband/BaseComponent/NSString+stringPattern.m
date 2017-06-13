//
//  NSString+stringPattern.m
//  正则表达式
//
//  Created by  周保勇 on 15/8/22.
//  Copyright (c) 2015年  周保勇. All rights reserved.
//

#import "NSString+stringPattern.h"

@implementation NSString (stringPattern)
-(BOOL)matchesInString:(NSString *)pattern
{
    NSRegularExpression * regularExpression = [[NSRegularExpression alloc]initWithPattern:pattern options:0 error:nil];
    NSArray * resultArray = [regularExpression matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    return (resultArray.count > 0);
}
- (BOOL)isQQ
{
    /**QQ号码规则：
     1.开头数字不为0
     2.5-11的数字
     */
    
    
    //1.创建规则对象：NSRegularExpression
    //创建字符串规则：pattern
//    NSString * pattern = @"[]";
//    NSRegularExpression * regularExpression = [[NSRegularExpression alloc]initWithPattern:pattern options:0 error:nil];
//    NSArray * resultArray = [regularExpression matchesInString:pattern options:0 range:NSMakeRange(0, self.length)];
//    return (resultArray.count == 1);
    NSString * pattern = @"^[1-9]\\d{4,10}$";
    return [self matchesInString:pattern];
    //注意JavaScrip的正则表达式前后都有\，使用时将前后\去掉就行了
}
- (BOOL)isPhoneNumber
{
    
    /**手机号码规则：
     1.开头数字为13、15、18、17
     2.11位的数字
     */
    return [self matchesInString:@"^1[3578]\\d{9}$"];
}
- (BOOL)isIpAddress
{
    return [self matchesInString:@"\\d+\\.\\d+\\.\\d+\\.\\d+"];
}
- (BOOL)isPayNumber
{
    NSString * pattern = @"^[1-9]\\d+(\\.\\d{2})?$|^0\\.\\d{2}$";
    return [self matchesInString:pattern];
}
- (BOOL)isEmail
{
    NSString *pattern = @"^\\s*\\w+(?:\\.{0,1}[\\w-]+)*@[a-zA-Z0-9]+(?:[-.][a-zA-Z0-9]+)*\\.[a-zA-Z]+\\s*$";;
//    @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
//    @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
//    "^\\s*\\w+(?:\\.{0,1}[\\w-]+)*@[a-zA-Z0-9]+(?:[-.][a-zA-Z0-9]+)*\\.[a-zA-Z]+\\s*$";
    return [self matchesInString:pattern];
}

+(CGSize)sizeOfFontWithString:(NSString *)string maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight fontSize:(CGFloat)fontSize{
    return [string boundingRectWithSize:CGSizeMake(maxWidth, maxHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
}

@end
