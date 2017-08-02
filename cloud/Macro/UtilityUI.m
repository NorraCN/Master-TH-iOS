//
//  UtilityUI.m
//  cloud
//
//  Created by 崔远寿 on 16/1/4.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import "UtilityUI.h"

@implementation UtilityUI

+ (void)setBorderOnView:(UIView *)view borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius {
    if (!view) {
        return;
    }
    
    borderColor = borderColor ? borderColor : [UIColor redColor];
    borderWidth = borderWidth >= 0 ? borderWidth : kUtilityUIDefaultBorderWidth;
    cornerRadius = cornerRadius >= 0 ? cornerRadius : kUtilityUIDefaultBorderCornerRadius;
    
    view.layer.borderColor = borderColor.CGColor;
    view.layer.borderWidth = borderWidth;
    view.layer.cornerRadius = cornerRadius;
    if (cornerRadius >= 0) {
        view.clipsToBounds = YES;
    }
}

+ (void)setBorderOnView:(UIView *)view {
    [self setBorderOnView:view borderColor:view.backgroundColor borderWidth:kUtilityUIDefaultBorderWidth cornerRadius:kUtilityUIDefaultBorderCornerRadius];
}

+ (void)setBorderOnView:(UIView *)view borderColor:(UIColor *)borderColor{
    [self setBorderOnView:view borderColor:borderColor borderWidth:kUtilityUIDefaultBorderWidth cornerRadius:kUtilityUIDefaultBorderCornerRadius];
}


@end
