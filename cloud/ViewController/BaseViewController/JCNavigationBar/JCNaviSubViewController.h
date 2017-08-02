//
//  JCNaviSubViewController.h
//  cloud
//
//  Created by 崔远寿 on 16/1/4.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCBaseNaviBarView;
@interface JCNaviSubViewController : UIViewController

- (void)defaultNaviBarShowTitle:(NSString *)title;
- (UIButton *)defaultNaviBarLeftBtn;
- (UIButton *)defaultNaviBarRightBtn;
- (void)defaultNaviBarSetLeftViewHidden:(BOOL)hidden;
- (void)defaultNaviBarSetRightViewHidden:(BOOL)hidden;

- (void)setNaviBarHide:(BOOL)hide withAnimation:(BOOL)animation;

- (JCBaseNaviBarView *)currentNaviBarView;
- (BOOL)isNaviBarHidden;
- (void)replaceNaviBarView:(JCBaseNaviBarView *)naviBarView;

- (void)bringNaviBarToTop;

#pragma mark - 重载
- (void)defaultNaviBarLeftBtnPressed;
- (void)defaultNaviBarRightBtnPressed;



@end
