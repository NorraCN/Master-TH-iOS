//
//  LoginViewModel.m
//  cloud
//
//  Created by 崔远寿 on 16/1/5.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import "LoginViewModel.h"

@interface LoginViewModel()

@property (nonatomic,strong) SVRLoginOperator *netWorking;
@property (nonatomic,strong) NSString *jsessionid;

@end

@implementation LoginViewModel

- (SVRLoginOperator *)netWorking{
    if (_netWorking == nil) {
        _netWorking = [SVRLoginOperator new];
    }
    return _netWorking;
}

- (void)getJsessionIdString{
    [[self.netWorking getJsessionIdString] subscribeNext:^(id respose) {
        self.jsessionid = respose[@"jsessionid"];
     } error:^(NSError *error) {}
     ];
}

// [TODO] need to have more error handling code
- (void)login:(NSString *)userName PassW:(NSString *)passWord Code:(NSString *)codeString{
    if (StringNotEmpty(self.jsessionid)) {
        [[self.netWorking login:userName PassW:passWord Code:codeString jsessionid:self.jsessionid] subscribeNext:^(id respose) {
            NSNumber *code = respose[@"result"];
            if ([code integerValue] == 0) {
                NSString *token = respose[@"appToken"];
                if (StringNotEmpty(token)) {
                    AppConfigInstance.appToken = token;
                    [AppConfigInstance saveAll];
                    [self.vmHandler loginSucc];
                }
            }else if ([code integerValue] >= 100 && [code integerValue] < 200) {
                NSString *message = respose[@"message"];
                [self.vmHandler loginFail:(message)];
                DebugLog(@"login 失败,message:%@",message);
                
            }else {
                DebugLog(@"unknown Error");
            }
        } error:^(NSError *error) {
        }];
        
    }else{
    }
}

@end
