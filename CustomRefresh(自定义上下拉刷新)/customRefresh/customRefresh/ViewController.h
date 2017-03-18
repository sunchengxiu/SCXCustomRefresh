//
//  ViewController.h
//  customRefresh
//
//  Created by 孙承秀 on 16/11/30.
//  Copyright © 2016年 孙先森丶. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+Refresh.h"
#import "DPBaseRefreshView.h"
#import "DPHeadereRefreshView.h"
#import "DPFooterRefreshView.h"
@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

/******  tableView *****/
@property(nonatomic,strong)UITableView *tableView;

@end

