//
//  UtilityUI+ProgressHUD.m
//  cloud
//
//  Created by 崔远寿 on 16/1/4.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import "UtilityUI+ProgressHUD.h"
#import "MBProgressHUD.h"

static NSInteger const HUDDefaultShowTime = 1.0f;
static NSInteger const HUDLongShowTime = 1.8f;

typedef NS_ENUM(NSInteger, HUDMaskType) {
    HUDMaskTypeNone = 1,
    HUDMaskTypeClear,
    HUDMaskTypeBlack,
    HUDMaskTypeGradient,
    HUDMaskTypeFullScreen
};

typedef NS_ENUM(NSInteger, HUDPosition) {
    HUDPositionCentre,
    HUDPositionTop
};

@implementation UtilityUI (ProgressHUD)

+ (void)showHUDLoading:(UIView *)baseView {
    [self showHUDLoading:baseView enabledUserInteraction:YES];
}

+ (void)showHUDLoading:(UIView *)baseView enabledUserInteraction:(BOOL)enabledUserInteraction {
    [self showHUDLoading:baseView text:nil enabledUserInteraction:enabledUserInteraction];
}

+ (void)showHUDLoading:(UIView *)baseView text:(NSString *)text {
    [self showHUDLoading:baseView text:text enabledUserInteraction:YES];
}

+ (void)showHUDLoading:(UIView *)baseView text:(NSString *)text enabledUserInteraction:(BOOL)enabledUserInteraction {
    [self showHUDLoading:YES text:text image:nil duration:0 position:HUDPositionCentre baseView:baseView maskType:enabledUserInteraction ? HUDMaskTypeClear : HUDMaskTypeFullScreen];
}

+ (void)showHUDWithText:(NSString *)text {
    [self showHUDWithImage:nil text:text];
}

+ (void)showHUDWithText:(NSString *)text duration:(NSTimeInterval)duration{
    [self showHUDWithImage:nil text:text duration:duration];
}

+ (void)showHUDWithText:(NSString *)text duration:(NSTimeInterval)duration inView:(UIView *)baseView {
    CGFloat mDuration = duration;
    if (mDuration <= 0) {
        mDuration = (text && text.length > 12) ? HUDLongShowTime : HUDDefaultShowTime;
    } else {}
    
    [self showHUDLoading:NO text:text image:nil duration:mDuration position:HUDPositionCentre baseView:baseView maskType:HUDMaskTypeClear];
}

+ (void)showHUDWithSuccessText:(NSString *)text {
    UIImage *successImage = [UIImage imageNamed:@"37x-Checkmark"];
    [self showHUDWithImage:successImage text:text];
}

+ (void)showHUDWithErrorText:(NSString *)text {
    UIImage *failureImage = [UIImage imageNamed:@"37x-Checkmark_temp"];
    [self showHUDWithImage:failureImage text:text];
}

+ (void)showHUDWithImage:(UIImage *)image text:(NSString *)text {
    [self showHUDWithImage:image text:text duration:0];
}

+ (void)showHUDWithImage:(UIImage *)image text:(NSString *)text duration:(NSTimeInterval)duration {
    CGFloat mDuration = duration;
    if (mDuration <= 0) {
        mDuration = (text && text.length > 12) ? HUDLongShowTime : HUDDefaultShowTime;
    }

    [self showHUDLoading:NO text:text image:image duration:mDuration position:HUDPositionCentre baseView:nil maskType:HUDMaskTypeClear];
}

+ (void)showHUDLoading:(BOOL)loading
                  text:(NSString *)text
                 image:(UIImage *)image
              duration:(NSTimeInterval)duration
              position:(HUDPosition)position
              baseView:(UIView *)baseView
              maskType:(HUDMaskType)maskType
{
    if (loading == NO && (!text || text.length == 0)) {
        return;
    }
    
    if (loading && !baseView) {
        return;
    }

    UIView *fatherView = loading ? baseView : [self getCurrentShowWindow];
    
    CGFloat offet = 0.0f;
    if (position == HUDPositionTop) offet = -150.f;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:fatherView animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.detailsLabelText = text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:16.0f];
    hud.yOffset = offet;
    
    if (loading) {
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.backgroundColor = RGBA(0.0f, 0.0f, 0.0f, 0.0f); // RGBA(0.0f, 0.0f, 0.0f, 0.25f);
    } else {
        NSTimeInterval mDuration = duration > 0 ? duration: HUDDefaultShowTime;
        if (image) {
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView = [[UIImageView alloc] initWithImage:image];
        } else {
            hud.cornerRadius = 5.0f;
            hud.mode = MBProgressHUDModeText;
        }
        hud.margin = 8.0f;
        [hud hide:YES afterDelay:mDuration];
    }
}

+ (void)dimissHUDView:(UIView *)baseView {
    UIView *mFatherView = baseView ?: [self getCurrentShowWindow];
    for (UIView *subVIew in mFatherView.subviews) {
        if ([subVIew isKindOfClass:[MBProgressHUD class]]) {
            [((MBProgressHUD *)subVIew) hide:YES];
        }
    }
}

+ (void)dimissHUDView {
    UIView *mFatherView = [self getCurrentShowWindow];
    for (UIView *subVIew in mFatherView.subviews) {
        if ([subVIew isKindOfClass:[MBProgressHUD class]]) {
            [((MBProgressHUD *)subVIew) hide:YES];
        }
    }
}

#pragma mark -

+ (UIWindow *)getCurrentShowWindow {
    UIWindow *currentShowWindow = nil;
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows){
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        
        if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            currentShowWindow = window;
            break;
        }
    }
    return currentShowWindow;
}

#pragma mark -
+ (void)showSystemLoadingInView:(UIView *)inView
{
    if (!inView) return;
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.frame = CGRectMake(0, 0, 20.0f, 20.0f);
    activityIndicatorView.center = CGPointMake(inView.bounds.size.width / 2, inView.bounds.size.height / 2);
    activityIndicatorView.tag = 21221;
    [activityIndicatorView startAnimating];
    
    [inView addSubview:activityIndicatorView];
    [inView bringSubviewToFront:activityIndicatorView];
}

+ (void)dismissSystemLoadingInView:(UIView *)inView
{
    if (!inView) return;
    UIView *view = [inView viewWithTag:21221];
    if (view) {
        [view removeFromSuperview];
    }
}

+(void)showNoticeText:(NSString *)text
{
    //[SGInfoAlert showAlert:text inView:[[self class] appDelegate].window duration:1.0f];
    [[self class] showNoticeText:text loading:NO];
}

+(void)showNoticeText:(NSString *)text showSuccessView:(BOOL)show
{
    if (show) {
        [[self class] showNoticeText:text loading:NO duration:0 location:0 fatherView:nil image:[UIImage imageNamed:@"mb_checkmark.png"]];
    }else{
        [[self class] showNoticeText:text loading:NO duration:0 location:0 fatherView:nil image:nil];
    }
}

+(void)showNoticeText:(NSString *)text loading:(BOOL)loading
{
    [[self class] showNoticeText:text loading:loading duration:0 location:0 fatherView:nil image:nil];
}

+(void)showNoticeText:(NSString *)text loading:(BOOL)loading duration:(float)duration
{
    [[self class] showNoticeText:text loading:loading duration:duration location:0 fatherView:nil image:nil];
}


+(void)showNoticeText:(NSString *)text loading:(BOOL)loading fatherView:(UIView *)fatherView
{
    [[self class] showNoticeText:text loading:loading duration:0 location:0 fatherView:fatherView image:nil];
}

+(void)showNoticeText:(NSString *)text loading:(BOOL)loading duration:(float)duration location:(float)location fatherView:(UIView *)fatherView image:(UIImage *)image
{
    //    if ((!text || text.length == 0)&&loading == NO) {
    //        return;
    //    }
    //
    //    UIView *mFatherView = fatherView? fatherView : [[self class] appDelegate].window;
    //    float mDuration = duration>0?duration:kDefaultHUDShowInterval;
    //    float offet=0.0f;
    //    if (location==1) offet=-150.f;
    //    if (location==-1) offet=150.f;
    //
    //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:mFatherView animated:YES];
    //    hud.labelText = text;
    //
    //    hud.removeFromSuperViewOnHide = YES;
    //    hud.backgroundColor = RGBA(0.0f, 0.0f, 0.0f, 0.25f);
    //
    //    if (loading) {
    //        hud.mode = MBProgressHUDModeIndeterminate;
    //    }else{
    //        if (image){
    //            hud.mode = MBProgressHUDModeCustomView;
    //            hud.customView = [[UIImageView alloc] initWithImage:image];
    //        }else{
    //            hud.mode = MBProgressHUDModeText;
    //        }
    //
    //        hud.margin = 10.f;
    //        hud.yOffset = offet;
    //
    //        [hud hide:YES afterDelay:mDuration];
    //    }
    
    if (loading) {
        [UtilityUI showHUDLoading:fatherView text:text enabledUserInteraction:YES];
    } else {
        [UtilityUI showHUDWithText:text];
    }
    
}

+(void)hideLoadingHUBInView:(UIView *)view
{
    [UtilityUI dimissHUDView:view];
    
    //    UIView *mFatherView = view ?: [[self class] appDelegate].window;
    //
    //    for (UIView *subVIew in mFatherView.subviews) {
    //        if ([subVIew isKindOfClass:[MBProgressHUD class]]) {
    //            [((MBProgressHUD *)subVIew) hide:YES];
    //        }
    //    }
}

@end
