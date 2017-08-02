//
//  LoginViewModel.h
//  cloud
//
//  Created by 崔远寿 on 16/1/5.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import "LoginVMInterface.h"
#import "SVRLoginOperator.h"

@interface LoginViewModel : NSObject
<
    LoginVMInterface
>

@property (nonatomic,strong) id<LoginVMInterface> vmHandler;

@end
