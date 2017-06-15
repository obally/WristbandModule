//
//  SYConnectReminderView.m
//  SYWristband
//
//  Created by obally on 17/5/17.
//  Copyright © 2017年 obally. All rights reserved.
//

#import "SYConnectReminderView.h"

@interface SYConnectReminderView ()
@property(nonatomic,strong)UIView *reminderView; //总的
@property(nonatomic,strong)UIView *topView; //上面蓝色背景视图
@property(nonatomic,strong)UIImageView *topImageView;//图片视图
@property(nonatomic,strong)UILabel *topDeviceName; //设备名称
@property(nonatomic,strong)UILabel *topReminder; //上面提示语句
@property(nonatomic,strong)UIView *bottomView;//下面白色背景视图
@property(nonatomic,strong)UILabel *bottomReminderLabel1;//下面提示语句
@property(nonatomic,strong)UILabel *bottomReminderLabel2;//下面提示语句
@property(nonatomic,strong)UIButton *deleButton; //删除按钮

@end
@implementation SYConnectReminderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = RGBAlphaColor(223, 223, 223, 0.3);
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = RGBAlphaColor(223, 223, 223, 0.3);
        [self addView];
        [self viewFrameSet];
        [self addActions];
    }
    return self;
}
- (void)addView
{
    [self addSubview:self.reminderView];
    [self.reminderView addSubview:self.topView];
    [self.topView addSubview:self.topImageView];
    [self.topView addSubview:self.topDeviceName];
    [self.topView addSubview:self.topReminder];
    [self.topView addSubview:self.deleButton];
    [self.reminderView addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomReminderLabel1];
    [self.bottomView addSubview:self.bottomReminderLabel2];
    
}
- (void)viewFrameSet
{
    self.reminderView.frame = CGRectMake((kScreenWidth - kWidth(323))/2.0, kHeight(113) - NaviHeitht, kWidth(323), kHeight(439));
    self.topView.frame = CGRectMake(0, 0, self.reminderView.width, kHeight(295));
    self.deleButton.frame = CGRectMake(self.topView.width - kWidth(40), kHeight(10), kWidth(30), kHeight(30));
    self.topDeviceName.frame = CGRectMake(0, kHeight(20), self.reminderView.width, kHeight(30));
    self.topReminder.frame = CGRectMake(0, self.topDeviceName.bottom, self.reminderView.width, kHeight(25));
    self.topImageView.frame = CGRectMake((self.topView.width - kWidth(207))/2.0, self.topReminder.bottom + kHeight(10), kWidth(207), kHeight(152));
    self.bottomView.frame = CGRectMake(0, self.topView.bottom, self.reminderView.width, kHeight(144));
    self.bottomReminderLabel1.frame = CGRectMake(kWidth(20), kHeight(32), self.reminderView.width - kWidth(20) * 2 , kHeight(45));
    self.bottomReminderLabel2.frame = CGRectMake(kWidth(20), self.bottomReminderLabel1.bottom, self.bottomReminderLabel1.width, kHeight(22));
}
- (void)addActions
{
    [self.deleButton addTarget:self action:@selector(deleAction) forControlEvents:UIControlEventTouchUpInside];
}
- (void)deleAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(connectReminderViewDidSelectedDeleteButton)]) {
        [self.delegate connectReminderViewDidSelectedDeleteButton];
    }
}
#pragma mark - getter && setter

- (UIView *)reminderView
{
    if (_reminderView == nil) {
        _reminderView = [[UIView alloc]init];
        _reminderView.layer.masksToBounds = YES;
        _reminderView.layer.cornerRadius = 14;
    }
    return _reminderView;
}
- (UIView *)topView
{
    if (_topView == nil) {
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = [UIColor colorWithHexString:@"#6fc3db"];
    }
    return _topView;
}
- (UIImageView *)topImageView
{
    if (_topImageView == nil) {
        _topImageView = [[UIImageView alloc]init];
        _topImageView.image = [UIImage imageNamed:@"tips_shouhuan"];
    }
    return _topImageView;
}
- (UILabel *)topDeviceName
{
    if (_topDeviceName == nil) {
        _topDeviceName = [[UILabel alloc]init];
        _topDeviceName.font = kFont(22);
        _topDeviceName.textColor = [UIColor whiteColor];
        _topDeviceName.textAlignment = NSTextAlignmentCenter;
        _topDeviceName.text = @"SharkyB1";
    }
    return _topDeviceName;
}
- (UILabel *)topReminder
{
    if (_topReminder == nil) {
        _topReminder = [[UILabel alloc]init];
        _topReminder.font = kFont(18);
        _topReminder.textColor = [UIColor whiteColor];
        _topReminder.textAlignment = NSTextAlignmentCenter;
        _topReminder.text = @"已成功匹配";

    }
    return _topReminder;
}
- (UIView *)bottomView
{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
    }
    return _bottomView;
}
- (UIButton *)deleButton
{
    if (_deleButton == nil) {
        _deleButton = [[UIButton alloc]init];
        [_deleButton setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
    }
    return _deleButton;
}
- (UILabel *)bottomReminderLabel1
{
    if (_bottomReminderLabel1 == nil) {
        _bottomReminderLabel1 = [[UILabel alloc]init];
        _bottomReminderLabel1.numberOfLines = 0;
        _bottomReminderLabel1.font = kFont(16);
        _bottomReminderLabel1.textAlignment = NSTextAlignmentCenter;
        _bottomReminderLabel1.textColor = [UIColor colorWithHexString:@"#939393"];
        _bottomReminderLabel1.text = @"请用你的手指敲击2次已匹配成功的手环进行连接";
    }
    return _bottomReminderLabel1;
}
- (UILabel *)bottomReminderLabel2
{
    if (_bottomReminderLabel2 == nil) {
        _bottomReminderLabel2 = [[UILabel alloc]init];
        _bottomReminderLabel2.font = kFont(16);
        _bottomReminderLabel2.textAlignment = NSTextAlignmentCenter;
        _bottomReminderLabel2.textColor = [UIColor colorWithHexString:@"#939393"];
        _bottomReminderLabel2.text = @"成功连接后，下次则自动连接";
    }
    return _bottomReminderLabel2;
}
@end
