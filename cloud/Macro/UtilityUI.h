//
//  UtilityUI.h
//  cloud
//
//  Created by 崔远寿 on 16/1/4.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import <Foundation/Foundation.h>

#define  kUtilityUIDefaultBorderWidth                    1.0f
#define  kUtilityUIDefaultBorderCornerRadius             5.0f

@interface UtilityUI : NSObject

// 代码设置设置边界和圆角，默认是view的背景色,1.0f borderWidth,5.0f cornerRadius
+ (void)setBorderOnView:(UIView *)view;
+ (void)setBorderOnView:(UIView *)view borderColor:(UIColor *)borderColor;
+ (void)setBorderOnView:(UIView *)view borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius;



@end
