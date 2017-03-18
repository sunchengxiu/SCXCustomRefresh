//
//  DPHeadereRefreshView.m
//  customRefresh
//
//  Created by 孙承秀 on 16/11/30.
//  Copyright © 2016年 孙先森丶. All rights reserved.
//

#import "DPHeadereRefreshView.h"
#define SCREEN_WEIGHT [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@implementation DPHeadereRefreshView
@synthesize refreshState = _refreshState;
+(instancetype)headerWithRefreshhandle:(SCX_RefreshHandle)refreshHandle
{

    DPHeadereRefreshView *headerRefreshView = [[DPHeadereRefreshView alloc]init];
    headerRefreshView.refreshBlock = refreshHandle;
    return headerRefreshView;
}
-(void)setStateText{

    self.normalText = @"下拉即可刷新";
    self.pullingText = @"松开即可刷新";
    self.normalText = @"没有更多了";
    self.loadingText = @"正在刷新";
}
-(void)addRefreshContentView {
    [super addRefreshContentView];
    
    //  添加刷新动画imageview
    [self addSubview:self.imageView];
    
    //刷新状态
    [self addSubview:self.statusLabel];
    
    // 时间label
    [self addSubview:self.timeLabel ];
    
    // 更新最后刷新时间
    [self updateStatusLabelTextAndTimeLabelTextWithDate:[NSDate date]];

}
#pragma mark - 偏移量改变的时候
-(void)scrollViewContentOffsetDidChange{

    // 正在拖拽
    if (self.scrollView.isDragging) {
        
        // 拖拽的长度大于header高度
        if (self.scrollView.contentOffset.y < -refreshHeight) {
            self.refreshState = SCX_RefreshStatePulling;
            
            
            
            // 实现拉伸效果
            [self toPullLineWhenPulling];
            
        }
        else {
        
            self.refreshState = SCX_RefreshStateNormal;
        }
    }
    else{
    
        //  当松开手指的时候，如果是pulling状态，那么就让他刷新
        if (self.refreshState == SCX_RefreshStatePulling) {
            self.refreshState = SCX_RefreshStateLoading;
        }
        else if (self.scrollView.contentOffset.y > -refreshHeight){
        
            self.refreshState = SCX_RefreshStateNormal;
        }
    }

}
#pragma mark - 实现拉伸效果动画
- (void)toPullLineWhenPulling{
    CGPoint lineStartPoint=CGPointMake(self.frame.size.width/2-75, 360+self.scrollView.contentOffset.y+3);
    CGPoint lineEndPoint=CGPointMake(self.frame.size.width/2-20, 330);
    
    CGPoint lineStartPoint1=CGPointMake(75, 360+self.scrollView.contentOffset.y+3);
    CGPoint lineEndPoint1=CGPointMake(20, 330);
   
    self.portImageViewOne.image = [self drawLineWithImage:nil andLineWidth:1 andColor:[UIColor orangeColor] andStartPoint:lineStartPoint andEndPoint:lineEndPoint];
    self.portImageViewTwo.image = [self drawLineWithImage:nil andLineWidth:1 andColor:[UIColor orangeColor] andStartPoint:lineStartPoint1 andEndPoint:lineEndPoint1];;
    

}
#pragma mark - 划线
- (UIImage *)drawLineWithImage:(UIImage *)image andLineWidth:(CGFloat)width andColor:(UIColor *)color andStartPoint:(CGPoint)startPoint andEndPoint:(CGPoint)endPoint{

    UIImage *drawImage = nil;
    UIGraphicsBeginImageContext(CGSizeMake(SCREEN_WEIGHT/2, 360 ));
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ref, width);
    CGContextSetStrokeColorWithColor(ref, color.CGColor);
    CGContextMoveToPoint(ref, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(ref, endPoint.x, endPoint.y);
    CGContextStrokePath(ref);
    drawImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return drawImage;
}
#pragma mark - 刷新状态
-(void)setRefreshState:(SCX_RefreshState)refreshState {
    SCX_RefreshState lastRefreshState = self.refreshState;
    if (_refreshState != refreshState) {
        _refreshState = refreshState;
        __weak typeof(self)weakSelf = self;
        switch (refreshState) {
            case SCX_RefreshStateNormal:
            {
                if (lastRefreshState == SCX_RefreshStateLoading) {
                    [self updateStatusLabelTextAndTimeLabelTextWithDate:[NSDate date]];
                }
                self.portImageViewTwo.image = nil;
                self.portImageViewOne.image = nil;
                self.statusLabel.text = self.normalText;
                [self.imageView stopAnimating];
                self.imageView.image=[UIImage imageNamed:@"img_sorry"];
                [UIView animateWithDuration:0.2 animations:^{
                    NSLog(@"%@",NSStringFromUIEdgeInsets(self.originEdgeInset));
                    self.scrollView.contentInset = self.originEdgeInset;
                }];
            }
                break;
            case SCX_RefreshStateLoading:{
                self.portImageViewTwo.image = nil;
                self.portImageViewOne.image = nil;
                self.statusLabel.text = self.loadingText;
                CGRect frame = self.imageView.frame;
                // 刷新的过程中动画
                [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    
                    
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        weakSelf.imageView.frame = CGRectMake(frame.origin.x, frame.origin.y - 50, frame.size.width, frame.size.height);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            weakSelf.imageView.frame = frame;
                        } completion:^(BOOL finished) {
                            
                            //开始动画
                            weakSelf.imageView.animationDuration = 2;
                            weakSelf.imageView.animationRepeatCount =CGFLOAT_MAX;
                            [weakSelf.imageView startAnimating];
                        }];
                        
                    }];
                }];
                // 让scrollView也对应响应的偏移量
                UIEdgeInsets inset = self.originEdgeInset;
                inset.top = inset.top + refreshHeight;
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.scrollView.contentInset = inset;
                } completion:^(BOOL finished) {
                    
                }];
                
                
                // 刷新回调
                if (self.refreshBlock) {
                    self.refreshBlock(self);
                }
            }
                break;
            case SCX_RefreshStatePulling:{
            self.statusLabel.text = self.pullingText;
            self.imageView.image=[UIImage imageNamed:@"ic_coin_face"];
            }
                break;
                
            default:
                break;
        }
    }
}
#pragma mark - 更新刷新时间
- (void)updateStatusLabelTextAndTimeLabelTextWithDate:(NSDate *)date{

    // 获取日历
    NSCalendar *calendar= [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:date];
    NSDateComponents *currentCmp = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];

    if ([cmp1 day] == [currentCmp day]) {
        [formater setDateFormat:@"今天 HH:mm"];
    } else if ([cmp1 year] == [currentCmp year]) {
    
        [formater setDateFormat:@"MM-dd HH:mm"];
    }
    else {
    
        [formater setDateFormat:@"yyyy-MM-dd MM:mm"];
    }
    NSString *dateText = [formater stringFromDate:date];
    self.timeLabel.text = dateText;
}
#pragma mark - 懒加载 
-(UIImageView *)imageView {

    if (!_imageView) {
        
        self.portImageViewOne=[[UIImageView alloc] initWithFrame:CGRectMake(0, -300, self.frame.size.width/2, 380)];
        self.portImageViewOne.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
        
        self.portImageViewTwo=[[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2, -300, self.frame.size.width/2, 380)];
        self.portImageViewTwo.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
//        [self.portImageViewOne setBackgroundColor:[UIColor redColor]];
//        [self.portImageViewTwo setBackgroundColor:[UIColor redColor]];
        [self addSubview:self.portImageViewTwo];
        [self addSubview:self.portImageViewOne];
        _imageView=[[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2.0-22.5, (refreshHeight - 45)/2.0 + 5, 45, 45)];
        _imageView.image=[UIImage imageNamed:@"img_sorry"];
        _imageView.animationImages=[NSArray arrayWithObjects: [UIImage imageNamed:@"load_more_1"],
                                   [UIImage imageNamed:@"load_more_2"],
                                   [UIImage imageNamed:@"load_more_3"],
                                   [UIImage imageNamed:@"load_more_4"],
                                   [UIImage imageNamed:@"load_more_5"],
                                   [UIImage imageNamed:@"load_more_6"],
                                   [UIImage imageNamed:@"load_more_7"],
                                   [UIImage imageNamed:@"load_more_8"],
                                   [UIImage imageNamed:@"load_more_9"],
                                   [UIImage imageNamed:@"load_more_10"],
                                   [UIImage imageNamed:@"load_more_11"],
                                   [UIImage imageNamed:@"load_more_12"],
                                   [UIImage imageNamed:@"load_more_13"],
                                   [UIImage imageNamed:@"load_more_14"],
                                   [UIImage imageNamed:@"load_more_15"],
                                   [UIImage imageNamed:@"load_more_16"],
                                   [UIImage imageNamed:@"load_more_17"],
                                   [UIImage imageNamed:@"load_more_18"],
                                   [UIImage imageNamed:@"load_more_19"],
                                   [UIImage imageNamed:@"load_more_20"],
                                   [UIImage imageNamed:@"load_more_21"],
                                   [UIImage imageNamed:@"load_more_22"],
                                   [UIImage imageNamed:@"load_more_23"],
                                   [UIImage imageNamed:@"load_more_24"],
                                   [UIImage imageNamed:@"load_more_25"],
                                   [UIImage imageNamed:@"load_more_26"],
                                   [UIImage imageNamed:@"load_more_27"],
                                   [UIImage imageNamed:@"load_more_28"],
                                   [UIImage imageNamed:@"load_more_29"],
                                   [UIImage imageNamed:@"load_more_30"],
                                   [UIImage imageNamed:@"load_more_31"],
                                   [UIImage imageNamed:@"load_more_32"],
                                   nil ];
        
       

    }
    return _imageView;
}
-(UILabel *)statesLable{

    if (!_statusLabel) {
       
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.frame = CGRectMake(0, 55, [UIScreen mainScreen].bounds.size.width, 20);
        _statusLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        _statusLabel.textColor = [UIColor lightGrayColor];
        _statusLabel.backgroundColor = [UIColor whiteColor];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.text = self.normalText;
    }
    return _statusLabel;
    
}
-(UILabel *)timeLabel {

    if (!_timeLabel) {
        //更新时间
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.frame = CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, 20);
        _timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        _timeLabel.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_timeLabel];
    }
    return _timeLabel;
}
@end
