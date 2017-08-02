//
//  JCBaseNaviBarView.m
//  cloud
//
//  Created by 崔远寿 on 16/1/4.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import "JCBaseNaviBarView.h"


@implementation JCBaseNaviBarView


+ (instancetype)createNaviBarViewFromXIB
{
    id view;
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:self options:nil];
    NSAssert((nib && (nib.count > 0)), @" ! can not find nib file.\n\nxib file name is not the same as class name?\n");
    view = [nib objectAtIndex:0];
    
    return view;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
