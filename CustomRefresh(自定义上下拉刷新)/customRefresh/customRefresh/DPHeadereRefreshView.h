//
//  DPHeadereRefreshView.h
//  customRefresh
//
//  Created by 孙承秀 on 16/11/30.
//  Copyright © 2016年 孙先森丶. All rights reserved.
//

#import "DPBaseRefreshView.h"

@interface DPHeadereRefreshView : DPBaseRefreshView

/******  状态label *****/
@property(nonatomic,strong)UILabel *statusLabel;

/******  时间label *****/
@property(nonatomic,strong)UILabel *timeLabel;

/******  刷新动画 *****/
@property(nonatomic,strong)UIImageView *imageView;

/******  红点1 *****/
@property(nonatomic,strong)UIImageView *portImageViewOne;

/******  红点2 *****/
@property(nonatomic,strong)UIImageView *portImageViewTwo;

+ (instancetype)headerWithRefreshhandle:(SCX_RefreshHandle)refreshHandle;
@end
