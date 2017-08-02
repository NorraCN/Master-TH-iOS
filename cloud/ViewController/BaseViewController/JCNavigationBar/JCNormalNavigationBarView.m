//
//  JCNormalNavigationBarView.m
//  cloud
//
//  Created by 崔远寿 on 16/1/4.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import "JCNormalNavigationBarView.h"



@implementation JCNormalNavigationBarView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self commonInit];
}

#pragma mark - Common Init
- (void)commonInit
{
    self.leftView.backgroundColor = [UIColor clearColor];
    self.centerView.backgroundColor = [UIColor clearColor];
    self.rightView.backgroundColor = [UIColor clearColor];
    
    self.rightView.hidden = YES;
}

#pragma mark - Action
- (IBAction)leftBtn:(id)sender
{
    if (self.leftBtnPressedHandler)
    {
        self.leftBtnPressedHandler();
    }else{}
}

- (IBAction)rightBtn:(id)sender
{
    if (self.rightBtnPressedHandler)
    {
        self.rightBtnPressedHandler();
    }else{}
}



























@end
