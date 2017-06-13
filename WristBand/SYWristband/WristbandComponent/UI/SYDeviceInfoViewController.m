//
//  SYDeviceInfoViewController.m
//  SYWristband
//
//  Created by obally on 17/5/17.
//  Copyright © 2017年 obally. All rights reserved.
//

#import "SYDeviceInfoViewController.h"

@interface SYDeviceInfoViewController ()
@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UILabel *modelName; //型号
@property(nonatomic,strong) UILabel *identityName; //序列号
@property(nonatomic,strong) UIView *nameView; //名称
@property(nonatomic,strong) UIView *versionView; //版本号
@property(nonatomic,strong) UIView *updateView; //固件更新
@property(nonatomic,strong) UIView *statusView; //状态

@end

@implementation SYDeviceInfoViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加相关视图
    [self addView];
    //相关视图事件添加
    [self addAction];
    self.title = @"手环管理";
    self.view.backgroundColor = [UIColor whiteColor];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //视图frame设置及相关约束
    [self viewframeSet];
    
}
#pragma mark - 视图、action 添加  frame设置
- (void)addView
{
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.imageView];
    [self.topView addSubview:self.modelName];
    [self.topView addSubview:self.identityName];
    self.nameView = [self viewWithName:@"名称" subName:self.model.name];
    self.versionView = [self viewWithName:@"版本号" subName:self.model.firmwareVerison];
    self.updateView = [self viewWithName:@"设备固件更新" subName:@""];
    NSString *status = self.model.isConnected?@"已连接":@"未连接";
    self.statusView = [self viewWithName:@"状态" subName:status];
    [self.view addSubview:self.nameView];
    [self.view addSubview:self.versionView];
    [self.view addSubview:self.updateView];
    [self.view addSubview:self.statusView];
}
- (void)addAction
{
    
}
- (void)viewframeSet
{
    self.topView.frame = CGRectMake(0, 0, kScreenWidth, kHeight(125));
    self.imageView.frame = CGRectMake(kWidth(38), kHeight(21), kWidth(55), kHeight(84));
    self.modelName.frame = CGRectMake(self.imageView.right + kWidth(18), kHeight(35), kScreenWidth- self.imageView.right - kWidth(20), kHeight(25));
    self.identityName.frame = CGRectMake(self.modelName.left, self.modelName.bottom + kHeight(8), self.modelName.width, self.modelName.height);
    self.nameView.frame = CGRectMake(0, self.topView.bottom, kScreenWidth, kHeight(58));
    self.versionView.frame = CGRectMake(0, self.nameView.bottom, kScreenWidth, kHeight(58));
    self.updateView.frame = CGRectMake(0, self.versionView.bottom, kScreenWidth, kHeight(58));
    self.statusView.frame = CGRectMake(0, self.updateView.bottom, kScreenWidth, kHeight(58));
    
}
- (UIView *)viewWithName:(NSString *)name subName:(NSString *)subName
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeight(58))];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth(15), 0, kWidth(150), view.height)];
    nameLabel.font = kFont(17);
    nameLabel.textColor = [UIColor colorWithHexString:@"#565656"];
    nameLabel.text = name;
    [view addSubview:nameLabel];
    
    UILabel *subNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.right + kWidth(10), 0, kScreenWidth - nameLabel.right - kWidth(30), view.height)];
    subNameLabel.font = kFont(17);
    subNameLabel.textColor = [UIColor colorWithHexString:@"#A7A7A7"];
    subNameLabel.text = subName;
    subNameLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:subNameLabel];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(kWidth(10), view.height - 1, kScreenWidth - kWidth(10) * 2, kHeight(1))];
    line.backgroundColor = [UIColor colorWithHexString:@"#A7A7A7"];
    line.alpha = 0.15;
    [view addSubview:line];
    return view;
}
#pragma mark -Actions

#pragma mark - getter and setter
- (UIView *)topView
{
    if (_topView == nil) {
        _topView = [[UIView alloc]init];
    }
    return _topView;
}
- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]init];
        _imageView.image = [UIImage imageNamed:@"shouhuan-small"];
    }
    return _imageView;
}
- (UILabel *)modelName
{
    if (_modelName == nil) {
        _modelName = [[UILabel alloc]init];
        _modelName.font = kFont(17);
        _modelName.textColor = [UIColor colorWithHexString:@"#6FC3DB"];
        _modelName.text = [NSString stringWithFormat:@"型号：%@",self.model.name];
    }
    return _modelName;
}
- (UILabel *)identityName
{
    if (_identityName == nil) {
        _identityName = [[UILabel alloc]init];
        _identityName.font = kFont(17);
        _identityName.textColor = [UIColor colorWithHexString:@"#6FC3DB"];
        _identityName.text = [NSString stringWithFormat:@"序列号：%@",self.model.serialNumber];
    }
    return _identityName;
}

@end
