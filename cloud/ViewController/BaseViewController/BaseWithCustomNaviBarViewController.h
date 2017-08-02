//
//  BaseWithCustomNaviBarViewController.h
//  cloud
//
//  Created by 崔远寿 on 16/1/4.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import "JCNaviSubViewController.h"


@class MBProgressHUD;

@interface BaseWithCustomNaviBarViewController : JCNaviSubViewController

- (MBProgressHUD *)createHUD;

// 覆盖在window上的indicator
- (void)showLoadingIndicator;
- (void)showLoadingIndicatorWithMsg:(NSString *)msg;
- (void)hideLoadingIndicator;

// 覆盖在view上的indicator
- (void)showLoadingIndicatorInView;
- (void)showLoadingIndicatorInViewWithMsg:(NSString *)msg;
- (void)hideLoadingIndicatorInView;


//重载此方法进行基本的初始化
- (void)setupBase;

- (void)showNoticeText:(NSString *)text;

- (void)loginFail;

@end


