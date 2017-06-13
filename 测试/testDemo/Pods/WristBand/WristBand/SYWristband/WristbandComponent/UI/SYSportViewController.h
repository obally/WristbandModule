//
//  SYSportViewController.h
//  SYWristband
//
//  Created by obally on 17/5/18.
//  Copyright © 2017年 obally. All rights reserved.
//

#import "SYBaseViewController.h"

@interface SYSportViewController : SYBaseViewController
//-(void)requestCurrentStepDataFormWrist; //从手环请求步数数据
@property(nonatomic,strong)NSMutableArray *stepArray; //步数
@property(nonatomic,strong)NSMutableArray *distantArray; //公里数
@property(nonatomic,strong)NSMutableArray *calorieArray; //卡路里数
@end
