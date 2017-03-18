//
//  DPFooterRefreshView.m
//  customRefresh
//
//  Created by 孙承秀 on 16/11/30.
//  Copyright © 2016年 孙先森丶. All rights reserved.
//

#import "DPFooterRefreshView.h"

@implementation DPFooterRefreshView
@synthesize refreshState = _refreshState;
+ (instancetype)footerWithRefreshHandle:(SCX_RefreshHandle)refreshHandle{
    
    DPFooterRefreshView *footerRefreshView = [[DPFooterRefreshView alloc] init];
    footerRefreshView.refreshBlock = refreshHandle;
    return footerRefreshView;
    
}
-(void)setStateText{

    self.normalText = @"上拉加载更多...";
    self.pullingText = @"松开加载更多...";
    self.loadingText = @"正在加载更多...";
    self.noMoreText = @"没有更多内容...";
}
-(void)addRefreshContentView{
    [super addRefreshContentView];
    //转圈动画
    
    
    [self addSubview:self.statusLabel];
    [self addSubview:self.arrowImage];
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityView.frame = _arrowImage.frame;
    [self addSubview:_activityView];
    
}
-(void)setAutoLoadMore:(BOOL *)autoLoadMore{

    _autoLoadMore = autoLoadMore;
    if (_autoLoadMore) {//自动加载更多不显示箭头
        [_arrowImage removeFromSuperview];
        _arrowImage = nil;
        self.normalText = @"正在加载更多...";
        self.pullingText = @"正在加载更多...";
        self.loadingText = @"正在加载更多...";
    }
    
}
-(void)scrollViewContentSizeDidChange{
    CGRect frame = self.scrollView.frame;
    frame.origin.y = MAX(self.scrollView.frame.size.height, self.scrollView.contentSize.height);
    self.frame = frame;
}
-(void)scrollViewContentOffsetDidChange{
    if (self.refreshState == SCX_RefreshStateNoMore   ) {
        return;
    }
    if (self.autoLoadMore) {
        if ([self getBeyondScrollViewHeight]>1) {
            self.refreshState = SCX_RefreshStateLoading;
        }
        return;
    }
    if (self.scrollView.isDragging) {
        if ([self getBeyondScrollViewHeight]>refreshHeight) {
            self.refreshState = SCX_RefreshStatePulling;
        }
        else {
        
            self.refreshState = SCX_RefreshStateNormal;
        }
    }
    else {
    
        if (self.refreshState == SCX_RefreshStatePulling) {
            self.refreshState = SCX_RefreshStateLoading;
        }
        else if ([self getBeyondScrollViewHeight]<refreshHeight){
        
            self.refreshState = SCX_RefreshStateNormal;
        }
    }

}
-(void)setRefreshState:(SCX_RefreshState)refreshState{

    SCX_RefreshState lastRefreshState = self.refreshState;
    if (_refreshState != refreshState) {
        _refreshState = refreshState;
        switch (refreshState) {
            case SCX_RefreshStateNormal:
            {
                self.statusLabel.text = self.normalText;
                if (lastRefreshState == SCX_RefreshStateLoading) {
                    
                    self.arrowImage.hidden = YES;
                }
                else {
                
                    self.arrowImage.hidden = NO;
                }
                self.arrowImage.hidden = NO;
                [self.activityView stopAnimating];
                [UIView animateWithDuration:0.5 animations:^{
                    self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
                    self.scrollView.contentInset = self.originEdgeInset;
                }];
            }
                break;
            case SCX_RefreshStateLoading:{
                self.arrowImage.hidden = YES;
                self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
                self.statusLabel.text = self.loadingText;
                self.activityView.hidden = NO;
                [self.activityView startAnimating];
                [UIView animateWithDuration:0.5 animations:^{
                    UIEdgeInsets edgeinset = self.scrollView.contentInset;
                    edgeinset.bottom += refreshHeight;
                    self.scrollView.contentInset = edgeinset;
                    
                }];
                if (self.refreshBlock) {
                    self.refreshBlock(self);
                }
            }
                break;
            case SCX_RefreshStatePulling:{
                self.statusLabel.text = self.pullingText;
                
                [UIView animateWithDuration:0.2 animations:^{
                    self.arrowImage.transform = CGAffineTransformIdentity;
                }];
            }
                break;
            default:
                break;
        }
    }
    
    
}
-(CGFloat)getBeyondScrollViewHeight{

    // scrollView内容高度
    CGFloat scrollViewHeight = self.scrollView.frame.size.height - self.originEdgeInset.bottom - self.originEdgeInset.top;
    // 获取超出的范围
    return self.scrollView.contentOffset.y - (self.scrollView.contentSize.height-scrollViewHeight);

}

-(UILabel *)statusLabel{
    
    if (!_statusLabel) {
        
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.frame = CGRectMake(0, 25, [UIScreen mainScreen].bounds.size.width, 20);
        _statusLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        _statusLabel.textColor = [UIColor lightGrayColor];
        _statusLabel.backgroundColor = [UIColor whiteColor];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.text = self.normalText;
    }
    return _statusLabel;
    
}
-(UIImageView *)arrowImage{
    if (!_arrowImage) {
        //箭头图片
        _arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueArrow"]];
        _arrowImage.frame = CGRectMake(self.frame.size.width/2.0 - 100, 12.5, 15, 40);
        [self addSubview:_arrowImage];
        
       
    }
    return _arrowImage;
}
- (void)endRefresh {
    [self scrollViewContentSizeDidChange];
    [super endRefresh];
}



@end
