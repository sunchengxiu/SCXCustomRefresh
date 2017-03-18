//
//  UIScrollView+Refresh.h
//  customRefresh
//
//  Created by 孙承秀 on 16/11/30.
//  Copyright © 2016年 孙先森丶. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPBaseRefreshView.h"
@class DPHeadereRefreshView;
@class DPFooterRefreshView;
@interface UIScrollView (Refresh)
- (DPHeadereRefreshView *)addRefreshHeaderView:(SCX_RefreshHandle)headerRefreshHandle;
- (DPFooterRefreshView *)addRefreshFooterView:(SCX_RefreshHandle)footerRefreshHandle;
@end
