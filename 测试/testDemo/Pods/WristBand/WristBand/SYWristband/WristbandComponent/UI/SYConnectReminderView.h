//
//  SYConnectReminderView.h
//  SYWristband
//
//  Created by obally on 17/5/17.
//  Copyright © 2017年 obally. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYConnectReminderViewDelegate <NSObject>

@optional
- (void)connectReminderViewDidSelectedDeleteButton;

@end
@interface SYConnectReminderView : UIView
@property(nonatomic,weak) id<SYConnectReminderViewDelegate> delegate;

@end
