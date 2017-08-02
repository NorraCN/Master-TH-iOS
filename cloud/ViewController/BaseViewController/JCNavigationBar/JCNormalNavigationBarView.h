//
//  JCNormalNavigationBarView.h
//  cloud
//
//  Created by 崔远寿 on 16/1/4.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import "JCBaseNaviBarView.h"

typedef void(^JCNaviBarLeftBtnPressed)();
typedef void(^JCNaviBarRightBtnPressed)();


@interface JCNormalNavigationBarView : JCBaseNaviBarView

@property (nonatomic, weak) IBOutlet UIView *leftView;
@property (nonatomic, weak) IBOutlet UIView *centerView;
@property (nonatomic, weak) IBOutlet UIView *rightView;

@property (nonatomic, weak) IBOutlet UIButton *leftBtn;
@property (nonatomic, weak) IBOutlet UIButton *rightBtn;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (nonatomic, copy) JCNaviBarLeftBtnPressed leftBtnPressedHandler;
@property (nonatomic, copy) JCNaviBarRightBtnPressed rightBtnPressedHandler;






@end
