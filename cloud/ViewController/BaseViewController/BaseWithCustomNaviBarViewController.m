//
//  BaseWithCustomNaviBarViewController.m
//  cloud
//
//  Created by 崔远寿 on 16/1/4.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import "BaseWithCustomNaviBarViewController.h"
#import "MBProgressHUD.h"
#import "UtilityUI.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

@interface BaseWithCustomNaviBarViewController ()


@property (nonatomic, strong) MBProgressHUD *baseLoadingHUD;

@end

@implementation BaseWithCustomNaviBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBase];
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.wantsFullScreenLayout = YES;
}

// 友盟统计
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //使用自定义导航条后，防止系统的导航条显示出来
    [self.navigationController.navigationBar setHidden:YES];     // 隐藏导航条，但由于导航条有效，系统的返回按钮页有效，所以可以使用系统的右滑返回手势。
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

//重载此方法进行基本的初始化
- (void)setupBase{
//    @weakify(self);
//    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kNFProgressHUDDidShow object:nil] subscribeNext:^(NSNotification *x) {
//        @strongify(self);
//        if (x.object == self.view) {
//            [self bringNaviBarToTop];
//        }
//        
//    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Loading HUB
// 覆盖在window上的indicator
- (void)showLoadingIndicator {
    [UtilityUI showHUDLoading:[UIApplication sharedApplication].delegate.window];
}

- (void)hideLoadingIndicator {
    [UtilityUI dimissHUDView:[UIApplication sharedApplication].delegate.window];
}

- (void)showLoadingIndicatorWithMsg:(NSString *)msg {
    [UtilityUI showHUDLoading:[UIApplication sharedApplication].delegate.window text:msg];
}

// 覆盖在view上的indicator
- (void)showLoadingIndicatorInView {
    [UtilityUI showHUDLoading:self.view];
    [self bringNaviBarToTop];
}

- (void)showLoadingIndicatorInViewWithMsg:(NSString *)msg {
    [UtilityUI showHUDLoading:self.view text:msg];
    [self bringNaviBarToTop];
}

- (void)hideLoadingIndicatorInView {
    [UtilityUI dimissHUDView:self.view];
}


- (MBProgressHUD *)createHUD {
    MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:self.view];
    hub.removeFromSuperViewOnHide = YES;
    hub.detailsLabelText = @"";
    hub.mode = MBProgressHUDModeIndeterminate;
    hub.backgroundColor = [UIColor clearColor];
    [self.view addSubview:hub];
    
    [self bringNaviBarToTop];
    
    return hub;
}

- (void)showNoticeText:(NSString *)text{
    [UtilityUI showNoticeText:text];
}

- (void)loginFail{
    AppConfigInstance.appToken = @"";
    [AppConfigInstance saveAll];
    LoginViewController *loginVC = InstantiateVCFromStoryboard(@"Main", @"LoginViewController");
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    app.window.rootViewController = nav;
}


#pragma mark -



























@end
