//
//  SYAlarmClockCell.h
//  SYWristband
//
//  Created by obally on 17/5/31.
//  Copyright © 2017年 obally. All rights reserved.
// 闹钟

#import <UIKit/UIKit.h>
#import "AlarmColckModel+CoreDataClass.h"

@protocol SYAlarmClockCellDelegate <NSObject>

@optional
- (void)clockCellDidOpenClockWithModel:(AlarmColckModel *)model isOn:(BOOL)ison;

@end
@interface SYAlarmClockCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView indexPatch:(NSIndexPath *)indexPatch;
//@property(nonatomic,copy) NSArray *cycleArray;
@property(nonatomic,strong) AlarmColckModel *model;
@property(nonatomic,assign) id<SYAlarmClockCellDelegate> delegate;


@end
