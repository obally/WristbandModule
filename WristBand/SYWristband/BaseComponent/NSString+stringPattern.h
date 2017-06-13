//
//  NSString+stringPattern.h
//  正则表达式
//
//  Created by  周保勇 on 15/8/22.
//  Copyright (c) 2015年  周保勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (stringPattern)
- (BOOL)isPayNumber;
- (BOOL)isPhoneNumber;
- (BOOL)isQQ;
- (BOOL)isEmail;
- (BOOL)isIpAddress;


+(CGSize)sizeOfFontWithString:(NSString *)string maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight fontSize:(CGFloat)fontSize;


@end
