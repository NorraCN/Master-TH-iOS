//
//  DevDetailsViewModel.m
//  cloud
//
//  Created by 崔远寿 on 16/1/7.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import "DevDetailsViewModel.h"
#import "SVRDevOperator.h"


@interface DevDetailsViewModel()

@property (nonatomic,strong) SVRDevOperator *netWorking;

@end

@implementation DevDetailsViewModel

- (SVRDevOperator *)netWorking{
    if (!_netWorking) {
        _netWorking = [SVRDevOperator new];
    }
    return _netWorking;
}

- (void)getDeviceDetails:(NSNumber *)deviceId{
    [[self.netWorking getDeviceDetails:deviceId] subscribeNext:^(id respose) {
        NSNumber *result = respose[@"result"];
        if (result) {
            NSInteger errorCode = [result integerValue];
            if (errorCode == 0) {
                DetailsDataModel *dataModel = [MTLJSONAdapter modelOfClass:[DetailsDataModel class]
                                                        fromJSONDictionary:respose[@"data"]
                                                                     error:nil];
                
                DetailsDeviceModel *deviceModel = [MTLJSONAdapter modelOfClass:[DetailsDeviceModel class]
                                                            fromJSONDictionary:respose[@"device"]
                                                                         error:nil];

                [self.vmHandler showDetailsWithData:dataModel device:deviceModel];
                
            }else if(errorCode == 100){
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

- (void) enableAlarm:(BOOL)decision forDeviceID:(NSNumber *)deviceId {
    [[self.netWorking enableAlarm:decision forDeviceID:deviceId] subscribeNext:^(id response) {
        NSNumber *result = response[@"result"];
        if (result) {
            NSInteger errorCode = [result integerValue];
            if (errorCode == 0) {   // 服务器端只返回这个，只表示指令收到了，并不代表closeAlarm成功或失败。
                DebugLog(@"closeAlarm Response result: %@", response);
                [self getDeviceDetails:deviceId];   // 所以，只能刷新view，不能盲目只是更新本地dataModel。
//                [self.vmHandler switchToggleSucceed:YES];
                DebugLog(@"更新设备细节，包括server端的Alarm状态");
            }else if(errorCode == 100){
                [self.vmHandler showErrorMsg:NSLocalizedString(@"login_state_expired", nil)];
                
                [self.vmHandler loginFail];
            }else{
                [self.vmHandler switchToggleSucceed:NO];

//                [self.vmHandler showErrorMsg:respose[@"message"]];
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
