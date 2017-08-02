//
//  DevHistoryVMInterface.h
//  cloud
//
//  Created by 崔远寿 on 16/1/7.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

@protocol DevHistoryVMInterface <NSObject>

@optional
//获取设备分组
- (void)getDeviceHistory:(NSNumber *)deviceId
                 pageNum:(NSNumber *)pageNum
                pageSize:(NSNumber *)pageSize
               startTime:(NSString *)startTime
                 endTime:(NSString *)endTime;


//ViewController 回调

- (void)showHistoryList:(NSArray *)list count:(NSNumber *)count hasNext:(BOOL)hasNext;

- (void)showErrorMsg:(NSString *)errorMsg;

//需要重新登录
- (void)loginFail;

@end