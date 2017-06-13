//
//  SYScanedDevicesCell.h
//  SYWristband
//
//  Created by obally on 17/5/16.
//  Copyright © 2017年 obally. All rights reserved.
//  扫描到的手环列表cell

#import <UIKit/UIKit.h>
#import "WristStrapModel.h"

@protocol SYScanedDevicesCellDelegate <NSObject>

@optional
- (void)scanedCellDidSelectedInfoButtonWithIndexPath:(NSIndexPath *)indexPath;

@end
@interface SYScanedDevicesCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView indexPatch:(NSIndexPath *)indexPatch;
@property(nonatomic,strong) WristStrapModel *strapModel; //
@property(nonatomic,assign) id<SYScanedDevicesCellDelegate> delegate;
@property(nonatomic,strong)UIActivityIndicatorView *activityView;

@end
