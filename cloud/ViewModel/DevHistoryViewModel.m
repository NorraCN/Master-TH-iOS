//
//  DevHistoryViewModel.m
//  cloud
//
//  Created by 崔远寿 on 16/1/7.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import "DevHistoryViewModel.h"
#import "SVRDevOperator.h"


@interface DevHistoryViewModel()

@property (nonatomic,strong) SVRDevOperator *netWorking;

@end

@implementation DevHistoryViewModel
#pragma mark - 懒加载
- (SVRDevOperator *)netWorking{
    if (!_netWorking) {
        _netWorking = [SVRDevOperator new];
    }
    return _netWorking;
}

- (void)getDeviceHistory:(NSNumber *)deviceId pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize startTime:(NSString *)startTime
                 endTime:(NSString *)endTime{
    [[self.netWorking getHistoryDetails:deviceId pageNum:pageNum pageSize:pageSize startTime:startTime endTime:endTime] subscribeNext:^(id respose) {
        NSNumber *result = respose[@"result"]; // respose是返回的数据字典。
        if (result) {
            NSInteger errorCode = [result integerValue];    // "result"key对应value为errorCode。
            // 处理返回的数据
            if (errorCode == 0) { // 没有错误，在这个block里调用VC中的show方法，把数据显示出来
                [self.vmHandler showHistoryList:respose[@"data"] count:respose[@"total"] hasNext:[respose[@"hasNext"] boolValue]];
            }else if(errorCode == 100){ // 有错误
                [self.vmHandler showErrorMsg:NSLocalizedString(@"login_state_expired", nil)];
                
                [self.vmHandler loginFail];
            }else{
                [self.vmHandler showErrorMsg:respose[@"message"]];
            }
        }else{
            [self.vmHandler showErrorMsg:NSLocalizedString(@"login_state_expired", nil)];
            [self.vmHandler loginFail];
        }
    } error:^(NSError *error) {
        [self.vmHandler showErrorMsg:NSLocalizedString(@"fail_net", nil)];
    }];
}


@end
