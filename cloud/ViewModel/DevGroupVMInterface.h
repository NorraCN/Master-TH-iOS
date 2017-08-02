//
//  DevGroupVMInterface.h
//  cloud
//
//  Created by 崔远寿 on 16/1/6.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//


#import <Foundation/Foundation.h>


@protocol DevGroupVMInterface <NSObject>

@optional
//获取设备分组
- (void)getDeviceList;
- (void)loginOut;


//ViewController 回调
- (void)showErrorMsg:(NSString *)errorMsg;

- (void)showGroupList:(NSArray *)list;


//需要重新登录
- (void)loginFail;

@end