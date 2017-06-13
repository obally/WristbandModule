//
//  SYAlarmClockCell.m
//  SYWristband
//
//  Created by obally on 17/5/31.
//  Copyright © 2017年 obally. All rights reserved.
//

#import "SYAlarmClockCell.h"

@interface SYAlarmClockCell ()

@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UILabel *timeLabel1;
@property(nonatomic,strong) UILabel *cycleLabel; //循环周期
@property(nonatomic,strong) UISwitch *switchA; //循环周期

@end
@implementation SYAlarmClockCell

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPatch:(NSIndexPath *)indexPatch
{
    static NSString *Id = @"cellId";
    SYAlarmClockCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell == nil) {
        cell = [[SYAlarmClockCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addView];
        [self viewFrameSet];
        [self addAction];
    }
    return self;
}
- (void)addView
{
    //上午 下午
    UILabel *timelabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth(15), kHeight(15), kWidth(40), kHeight(25))];
    timelabel.font = kFont(16);
    timelabel.textColor = [UIColor colorWithHexString:@"#4D4D4D"];
    self.timeLabel = timelabel;
    [self.contentView addSubview:timelabel];
    //时间
    UILabel *timelabel1 = [[UILabel alloc]initWithFrame:CGRectMake(timelabel.right, kHeight(10), kWidth(200), kHeight(30))];
    timelabel1.font = kFont(26);
    timelabel1.textColor = [UIColor colorWithHexString:@"#4D4D4D"];
    self.timeLabel1 = timelabel1;
    [self.contentView addSubview:timelabel1];
    //循环周期
    UILabel *cycleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth(15), timelabel.bottom, kWidth(300), kHeight(25))];
    self.cycleLabel = cycleLabel;
    cycleLabel.font = kFont(15);
    cycleLabel.textColor = [UIColor colorWithHexString:@"#A7A7A7"];
    [self.contentView addSubview:cycleLabel];
    
    UISwitch *switchButton = [[UISwitch alloc]initWithFrame:CGRectMake(kScreenWidth - kWidth(70) , 0, kWidth(51), kHeight(40))];
    switchButton.centerY = kHeight(32);
    self.switchA = switchButton;
    [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:switchButton];
    
}
- (void)viewFrameSet
{
    
}
- (void)addAction
{
    
}
- (void)switchAction:(UISwitch *)switchA
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clockCellDidOpenClockWithModel:isOn:)]) {
        [self.delegate clockCellDidOpenClockWithModel:self.model isOn:switchA.isOn];
    }
}
- (void)setModel:(AlarmColckModel *)model
{
    _model = model;
    NSArray *array = [model.dateString componentsSeparatedByString:@":"];
    if (array.count > 1) {
        NSInteger hour = [array[0] integerValue];
//        NSString *minute = array[1];
        if (hour >= 12) {
            self.timeLabel.text = @"下午";
            hour -= 12;
            self.timeLabel1.text = [NSString stringWithFormat:@"%ld:%@",(long)hour,array[1]];
        } else {
            self.timeLabel.text = @"上午";
            self.timeLabel1.text = [NSString stringWithFormat:@"%@",model.dateString];
        }
        
    }
    self.switchA.on = model.isOn;
    NSString *cycleStr = [model.cycleDate stringByReplacingOccurrencesOfString:@":" withString:@" "];
    self.cycleLabel.text = [NSString stringWithFormat:@"%@",cycleStr];
}
@end
