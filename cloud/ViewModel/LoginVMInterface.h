//
//  LoginVMInterface.h
//  cloud
//
//  Created by 崔远寿 on 16/1/5.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol LoginVMInterface <NSObject>

@optional
//获取验证的串
- (void)getJsessionIdString;
//登陆
- (void)login:(NSString *)userName PassW:(NSString *)passWord Code:(NSString *)codeString;

//ViewController 回调
- (void)loginSucc;
- (void)loginFail:(NSString *)message;

@end