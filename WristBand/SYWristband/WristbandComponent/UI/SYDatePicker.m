//
//  SYDatePicker.m
//  SYWristband
//
//  Created by obally on 17/5/31.
//  Copyright © 2017年 obally. All rights reserved.
//

#import "SYDatePicker.h"

@interface SYDatePicker()

@end
@implementation SYDatePicker
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.datePickerMode = UIDatePickerModeTime;
        self.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    }
    return self;
}

@end
