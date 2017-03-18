//
//  DPBaseRefreshView.h
//  customRefresh
//
//  Created by 孙承秀 on 16/11/30.
//  Copyright © 2016年 孙先森丶. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DPBaseRefreshView;
// 刷新的高度
static CGFloat const refreshHeight = 80;
/**
 回调Block
 */
typedef void (^SCX_RefreshHandle)(DPBaseRefreshView *refreshView);

/**
 刷新状态
 */
typedef NS_ENUM(NSInteger , SCX_RefreshState) {

    SCX_RefreshStateNormal = 0,
    SCX_RefreshStatePulling,
    SCX_RefreshStateLoading,
    SCX_RefreshStateNoMore

};
/**
 刷新的种类
 */
typedef NS_ENUM(NSInteger , SCX_RefreshType) {

    SCX_RefreshTypeHeader = 0,
    SCX_RefreshTypeFooter
};
@interface DPBaseRefreshView : UIView
/******  刷新所在的scrollView *****/
@property(nonatomic,strong)UIScrollView *scrollView;

/******  回调Block *****/
@property(nonatomic,copy)SCX_RefreshHandle refreshBlock;

/******  原始偏移量 *****/
@property(nonatomic,assign)UIEdgeInsets originEdgeInset;

/******  刷新的种类 *****/
@property(nonatomic,assign)SCX_RefreshType refreshType;

/******  刷新的状态 *****/
@property(nonatomic,assign)SCX_RefreshState refreshState;

/******  正常状态刷新文字 *****/
@property(nonatomic,copy)NSString *normalText;

/******  pulling状态下的文字 *****/
@property(nonatomic,copy)NSString *pullingText;

/******  loading状态下的文字 *****/
@property(nonatomic,copy)NSString *loadingText;

/******  noMore状态下的文字 *****/
@property(nonatomic,copy)NSString *noMoreText;


/**
 设置状态文字
 */
- (void)setStateText;


/**
 添加刷新的视图
 */
-(void)addRefreshContentView;


/**
 开始刷新
 */
- (void)startRefresh;

/**
 结束刷新
 */
- (void)endRefresh;

/**************  监听scrollView滑动  ***************/
-(void)scrollViewContentSizeDidChange;
- (void)scrollViewContentOffsetDidChange;
@end
