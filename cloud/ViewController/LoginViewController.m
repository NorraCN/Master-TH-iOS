//
//  LoginViewController.m
//  cloud
//
//  Created by 崔远寿 on 16/1/5.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginViewModel.h"
#import "DevGroupViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()
<
    UITextFieldDelegate,
    LoginVMInterface
>

@property (nonatomic,weak) IBOutlet UITextField *userNameTextField;
@property (nonatomic,weak) IBOutlet UITextField *passWordTextField;
//@property (nonatomic,weak) IBOutlet UITextField *verifyCodeTextField;

@property (nonatomic,weak) IBOutlet UIButton *confirmBtn;

//@property (nonatomic,weak) IBOutlet UIImageView *verifyCodeImageView;

@property (nonatomic,strong) LoginViewModel *viewModel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    if (StringNotEmpty(AppConfigInstance.appToken)) {
        [self loginSucc];
    }else{
        self.viewModel = [LoginViewModel new];
        self.viewModel.vmHandler = self;
        [self.viewModel getJsessionIdString];
    }
    UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMyTapGesture:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)initUI{
    [self defaultNaviBarShowTitle:NSLocalizedString(@"login", nil)];

    self.confirmBtn.layer.cornerRadius = 8;
    self.confirmBtn.layer.borderWidth = 1;
    self.confirmBtn.layer.borderColor = [UIColor colorWithRed:225/255. green:225/255. blue:225/255. alpha:1].CGColor;
    self.confirmBtn.layer.masksToBounds = YES;
}

- (void)handleMyTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.view endEditing:YES];
}

#pragma mark --Action

- (IBAction)confirmBtnClick:(id)sender{
    if (!StringNotEmpty(self.userNameTextField.text)) {
        
        [self showNoticeText:NSLocalizedString(@"input_username", nil)];
        return;
    }else if(!StringNotEmpty(self.passWordTextField.text)){
        [self showNoticeText:NSLocalizedString(@"input_password", nil)];
        return;
    }
    [self showLoadingIndicator];
    [self.viewModel login:self.userNameTextField.text PassW:self.passWordTextField.text Code:@"app"];
//    [self.viewModel login:self.userNameTextField.text PassW:self.passWordTextField.text Code:self.verifyCodeTextField.text];
}

- (IBAction)refreshCodeClick:(id)sender{
    [self.viewModel getJsessionIdString];
}

#pragma mark --TextDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

#pragma mark --VMDelegate

- (void)refreshPicSuccess:(BOOL)success errorMessage:(NSString *)errorMessage{
    [self hideLoadingIndicator];
    if (!success) {
        [self showNoticeText:errorMessage];
    }
}

- (void)refreshPicUrl:(NSURL *)url{
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:url];
    result = [UIImage imageWithData:data];
//    self.verifyCodeImageView.image = result;

}

- (void)loginSucc{
    //登陆成功
    [self hideLoadingIndicator];
    
    DevGroupViewController *devGroupVC = InstantiateVCFromStoryboard(@"Main",@"DevGroupViewController");
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:devGroupVC];
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    app.window.rootViewController = nav;
}

- (void)loginFail:(NSString *)message {
    //登陆失败
    [self hideLoadingIndicator];
    if ([message isEqual: @"ticketError"]) {
//        [self showNoticeText: NSLocalizedString(@"incorrectUserOrPass", nil)];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: nil
                                                       message: NSLocalizedString(@"incorrectUserOrPass", nil)
                                                      delegate: self
                                             cancelButtonTitle: nil
                                             otherButtonTitles: nil,nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:2.0];
    }else {
        [self showNoticeText: [NSString stringWithFormat:@"Error:%@", message]];
    }
}

- (void) dismissAlert:(UIAlertView *)x {
    [x dismissWithClickedButtonIndex:-1 animated:YES];
}

@end
