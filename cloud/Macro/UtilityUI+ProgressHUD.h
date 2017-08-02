//
//  UtilityUI+ProgressHUD.h
//  cloud
//
//  Created by 崔远寿 on 16/1/4.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import "UtilityUI.h"

@interface UtilityUI (ProgressHUD)

// 菊花加文字，可以enabledUserInteraction是否锁定当前View的操作(没做)
+ (void)showHUDLoading:(UIView *)baseView;
+ (void)showHUDLoading:(UIView *)baseView enabledUserInteraction:(BOOL)enabledUserInteraction;
+ (void)showHUDLoading:(UIView *)baseView text:(NSString *)text;
+ (void)showHUDLoading:(UIView *)baseView text:(NSString *)text enabledUserInteraction:(BOOL)enabledUserInteraction;

// 提示性文字
+ (void)showHUDWithText:(NSString *)text;
+ (void)showHUDWithText:(NSString *)text duration:(NSTimeInterval)duration;
+ (void)showHUDWithText:(NSString *)text duration:(NSTimeInterval)duration inView:(UIView *)baseView;
+ (void)showHUDWithImage:(UIImage *)image text:(NSString *)text;
+ (void)showHUDWithImage:(UIImage *)image text:(NSString *)text duration:(NSTimeInterval)duration;
+ (void)showHUDWithSuccessText:(NSString *)text;
+ (void)showHUDWithErrorText:(NSString *)text;

// 隐藏
+ (void)dimissHUDView:(UIView *)baseView;   // 针对菊花
+ (void)dimissHUDView; // 针对提示性文字

// 显示系统菊花，居中现实
+ (void)showSystemLoadingInView:(UIView *)inView;
+ (void)dismissSystemLoadingInView:(UIView *)inView;

+(void)showNoticeText:(NSString *)text;
+(void)showNoticeText:(NSString *)text showSuccessView:(BOOL)show;
+(void)showNoticeText:(NSString *)text loading:(BOOL)loading;
+(void)showNoticeText:(NSString *)text loading:(BOOL)loading duration:(float)duration;
+(void)showNoticeText:(NSString *)text loading:(BOOL)loading fatherView:(UIView *)fatherView;
+(void)showNoticeText:(NSString *)text loading:(BOOL)loading duration:(float)duration location:(float)location fatherView:(UIView *)fatherView image:(UIImage *)image;
+(void)hideLoadingHUBInView:(UIView *)view;


@end
