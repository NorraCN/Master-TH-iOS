//
//  DevDetailsVMInterface.h
//  cloud
//
//  Created by 崔远寿 on 16/1/7.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailsDataModel.h"
#import "DetailsDeviceModel.h"

@protocol DevDetailsVMInterface <NSObject>

@optional
//获取设备分组
- (void)getDeviceDetails:(NSNumber *)deviceId;

- (void)enableAlarm:(BOOL)desision forDeviceID:(NSNumber *)deviceId;

//ViewController 回调
- (void)showErrorMsg:(NSString *)errorMsg;

- (void)showDetailsWithData:(DetailsDataModel *)dataModel device:(DetailsDeviceModel *)deviceModel;

//- (void)openAlertCode:(BOOL)open; /**< What hell */
- (void)switchToggleSucceed:(BOOL)succeed; 

//需要重新登录
- (void)loginFail;

@end