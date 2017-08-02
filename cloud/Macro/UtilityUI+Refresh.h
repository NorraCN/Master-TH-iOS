//
//  UtilityFunc+Refresh.h
//  yeemiao
//
//  Created by Ddread Li on 14/10/14.
//  Copyright (c) 2014 Threegene. All rights reserved.
//

#import "UtilityUI.h"
#import "MJRefresh.h"
#import "MJDIYAutoFooter.h"
#import "MJDIYHeader.h"

@interface UtilityUI (Refresh)

//TableView Refresh
+ (void)addHeaderRefreshViewAt:(UIScrollView *)scrollView withRefreshActionBolck:(void (^)())callback;
+ (void)addFooterRefreshViewAt:(UIScrollView *)scrollView withRefreshActionBolck:(void (^)())callback;
+ (void)endRefreshingAt:(UIScrollView *)scrollView;


+ (void)headerBeginRefreshingAt:(UIScrollView *)scrollView;
// 无更多数据
+ (void)showNoMoreViewAt:(UITableView*)table;
//重置 无数据状态
+ (void)resetNoMoreViewAt:(UITableView*)table;

@end
