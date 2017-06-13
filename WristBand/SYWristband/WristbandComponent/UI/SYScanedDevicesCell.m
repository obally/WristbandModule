//
//  SYScanedDevicesCell.m
//  SYWristband
//
//  Created by obally on 17/5/16.
//  Copyright © 2017年 obally. All rights reserved.
//

#import "SYScanedDevicesCell.h"
#if TARGET_IPHONE_SIMULATOR
#else
@interface SYScanedDevicesCell ()
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *modelName; //对应设备名称
@property(nonatomic,strong)UILabel *statusLabel; //是否已连接
@property(nonatomic,strong)UIButton *selectedButton; //查看设备详情按钮
@property(nonatomic,strong)NSIndexPath *currentIndexPath;//


@end
@implementation SYScanedDevicesCell
+ (instancetype)cellWithTableView:(UITableView *)tableView indexPatch:(NSIndexPath *)indexPatch
{
    static NSString *Id = @"cellId";
    SYScanedDevicesCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell == nil) {
        cell = [[SYScanedDevicesCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    cell.currentIndexPath = indexPatch;
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
    [self.contentView addSubview:self.name];
    [self.contentView addSubview:self.activityView];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.selectedButton];
}
- (void)viewFrameSet
{
    self.name.frame = CGRectMake(kWidth(15), kHeight(22), kWidth(250), kHeight(22));
    self.activityView.frame = CGRectMake(kScreenWidth - kWidth(140), kHeight(22), kWidth(30), kHeight(30));
    self.statusLabel.frame = CGRectMake(kScreenWidth - kWidth(100), kHeight(22), kWidth(60), kHeight(22));
    self.modelName.frame = CGRectMake(self.name.left, self.name.bottom, self.name.width, self.name.height);
    self.selectedButton.frame = CGRectMake(kScreenWidth - kWidth(40),kHeight(12), kWidth(32), kHeight(32));
    self.selectedButton.centerY = self.name.centerY =self.activityView.centerY = self.statusLabel.centerY;
}
- (void)addAction
{
    [self.selectedButton addTarget:self action:@selector(detailAction) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - Actions
//
- (void)detailAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scanedCellDidSelectedInfoButtonWithIndexPath:)]) {
        [self.delegate scanedCellDidSelectedInfoButtonWithIndexPath:self.currentIndexPath];
    }
}
#pragma mark - getter && setter
- (void)setStrapModel:(WristStrapModel *)strapModel
{
    _strapModel = strapModel;
    self.name.text = strapModel.name;
    self.modelName.text = strapModel.modelName;
    self.statusLabel.hidden = !strapModel.isMineDevice;
    if (strapModel.isMineDevice) {
        self.statusLabel.text = strapModel.isConnected?@"已连接":@"未连接";
    }
    [self.activityView stopAnimating];
    
//    [OBDataManager shareManager].strapModel = model;
    
}
- (UILabel *)name
{
    if (_name == nil) {
        _name = [[UILabel alloc]init];
        _name.font = kFont(15.0);
        _name.textColor = [UIColor colorWithHexString:@"#565656"];
    }
    return _name;
}
- (UILabel *)statusLabel
{
    if (_statusLabel == nil) {
        _statusLabel = [[UILabel alloc]init];
        _statusLabel.font = kFont(15.0);
        _statusLabel.textColor = [UIColor colorWithHexString:@"#565656"];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.text = @"已连接";
        _statusLabel.hidden = YES;

    }
    return _statusLabel;
}
- (UILabel *)modelName
{
    if (_modelName == nil) {
        _modelName = [[UILabel alloc]init];
        _modelName.font = kFont(15.0);
        _modelName.textColor = [UIColor colorWithHexString:@"#565656"];
    }
    return _modelName;
}
- (UIButton *)selectedButton
{
    if (_selectedButton == nil) {
        _selectedButton = [[UIButton alloc]init];
        [_selectedButton setImage:[UIImage imageNamed:@"info"] forState:UIControlStateNormal];
    }
    return _selectedButton;
}
- (UIActivityIndicatorView *)activityView
{
    if (_activityView == nil) {
        _activityView = [[UIActivityIndicatorView alloc]init];
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
    return _activityView;
}

@end
#endif
