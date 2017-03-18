//
//  DPBaseRefreshView.m
//  customRefresh
//
//  Created by 孙承秀 on 16/11/30.
//  Copyright © 2016年 孙先森丶. All rights reserved.
//

#import "DPBaseRefreshView.h"

@implementation DPBaseRefreshView
- (void)removeFromSuperview
{
    [self.superview removeObserver:self forKeyPath:@"contentOffset" context:nil];
    [self.superview removeObserver:self forKeyPath:@"contentSize" context:nil];
    
    [super removeFromSuperview];
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
}
-(instancetype)init{

    if (self = [super init]) {
        [self setStateText];
        [self addRefreshContentView];
        self.refreshState = SCX_RefreshStateNormal;
    }
    return self;
}
-(void)addRefreshContentView{

    self.frame = CGRectMake(0, -refreshHeight, [UIScreen mainScreen].bounds.size.width, refreshHeight);
    self.backgroundColor = [UIColor whiteColor];
    //[self.scrollView addSubview:self];
}
-(void)setScrollView:(UIScrollView *)scrollView{

    if (_scrollView != scrollView) {
        
        _originEdgeInset = scrollView.contentInset;
        [_scrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
        [_scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
        [scrollView addSubview:self];
        _scrollView = scrollView;
        // 监听偏移量
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    
}
#pragma mark - KVO监听
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {

    if ([keyPath isEqualToString:@"contentSize"]) {
        [self scrollViewContentSizeDidChange];
    }
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollViewContentOffsetDidChange];
    }

}
-(void)scrollViewContentOffsetDidChange{

}
-(void)scrollViewContentSizeDidChange{

}
-(void)startRefresh {

}
-(void)endRefresh{

    self.refreshState = SCX_RefreshStateNormal;
}
@end
