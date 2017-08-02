//
//  UtilityFunc+Refresh.m
//  yeemiao
//
//  Created by Ddread Li on 14/10/14.
//  Copyright (c) 2014 Threegene. All rights reserved.
//

#import "UtilityUI+Refresh.h"

@implementation UtilityUI (Refresh)

//TableView Refresh
+ (void)addHeaderRefreshViewAt:(UIScrollView *)scrollView withRefreshActionBolck:(void (^)())callback
{
    scrollView.mj_header = [MJDIYHeader headerWithRefreshingBlock:callback];
}

+ (void)addFooterRefreshViewAt:(UIScrollView *)scrollView withRefreshActionBolck:(void (^)())callback
{
    scrollView.mj_footer = [MJDIYAutoFooter footerWithRefreshingBlock:callback];
}

+ (void)endRefreshingAt:(UIScrollView *)scrollView
{
    [scrollView.mj_header endRefreshing];
    [scrollView.mj_footer endRefreshing];
}

+ (void)headerBeginRefreshingAt:(UIScrollView *)scrollView {
    [scrollView.mj_header beginRefreshing];
}

+ (void)showNoMoreViewAt:(UITableView*)table
{
//    table.footerHidden = YES;
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ScreenWidth, 30.0f)];
//    label.backgroundColor = [UIColor clearColor];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont systemFontOfSize:13];
//    label.textColor = [UIColor lightGrayColor];
//    label.text = NSLocalizedString(@"noMoreStuff", nil);
//    table.tableFooterView = label;
    
    MJRefreshLog(@"进入了showNoMoreViewAt:");
    [table.mj_footer endRefreshingWithNoMoreData];
    // 设置了底部inset
    table.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 忽略掉底部inset, 这里要和MJDIYAutoFooter中的self.mj_h保持一致。
    table.mj_footer.ignoredScrollViewContentInsetBottom = 50;
}
+ (void)resetNoMoreViewAt:(UITableView*)table
{
//    table.footerHidden = NO;
    [table.mj_footer endRefreshingWithNoMoreData];

    table.tableFooterView = nil;
}
@end
