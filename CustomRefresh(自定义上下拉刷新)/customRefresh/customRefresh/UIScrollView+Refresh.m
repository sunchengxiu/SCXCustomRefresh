//
//  UIScrollView+Refresh.m
//  customRefresh
//
//  Created by 孙承秀 on 16/11/30.
//  Copyright © 2016年 孙先森丶. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import "DPHeadereRefreshView.h"
#import "DPFooterRefreshView.h"
@implementation UIScrollView (Refresh)
#pragma mark - 添加下拉刷新

/**
 添加下拉刷新

 @param headerRefreshHandle 下拉刷新回调Block

 @return 下拉刷新view
 */
-(DPHeadereRefreshView *)addRefreshHeaderView:(SCX_RefreshHandle)headerRefreshHandle{

    DPHeadereRefreshView *headerRefreshView = [DPHeadereRefreshView headerWithRefreshhandle:headerRefreshHandle];
    headerRefreshView.scrollView = self;
    return headerRefreshView;
}
#pragma mark - 添加上拉刷新

/**
 添加上拉刷新

 @param footerRefreshHandle 上拉刷新回调Block

 @return 上拉刷新View
 */
-(DPFooterRefreshView *)addRefreshFooterView:(SCX_RefreshHandle)footerRefreshHandle{
    DPFooterRefreshView *footerView = [DPFooterRefreshView footerWithRefreshHandle:footerRefreshHandle];
    footerView.scrollView = self;
    return footerView;
}
@end
