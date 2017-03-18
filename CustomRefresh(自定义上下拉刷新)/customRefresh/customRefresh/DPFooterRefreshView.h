//
//  DPFooterRefreshView.h
//  customRefresh
//
//  Created by 孙承秀 on 16/11/30.
//  Copyright © 2016年 孙先森丶. All rights reserved.
//

#import "DPBaseRefreshView.h"

@interface DPFooterRefreshView : DPBaseRefreshView
/******  状态label *****/
@property(nonatomic,strong)UILabel *statusLabel;
/******  arrowImage *****/
@property(nonatomic,strong)UIImageView *arrowImage;
/******  _activityView *****/
@property(nonatomic,strong)UIActivityIndicatorView *activityView;
/******  自动加载更多 *****/
@property(nonatomic,assign)BOOL *autoLoadMore;
+ (instancetype)footerWithRefreshHandle:(SCX_RefreshHandle)refreshHandle;
@end
