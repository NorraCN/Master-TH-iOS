//
//  DevGroupViewModel.m
//  cloud
//
//  Created by 崔远寿 on 16/1/6.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import "DevGroupViewModel.h"
#import "SVRDevOperator.h"
#import "SVRLoginOperator.h"
#import "DataListModel.h"

@interface DevGroupViewModel()

@property (nonatomic,strong) SVRDevOperator *netWorking;
@property (nonatomic,strong) SVRLoginOperator *loginOutNetWorking;
@end


@implementation DevGroupViewModel

- (SVRDevOperator *)netWorking{
    if (!_netWorking) {
        _netWorking = [SVRDevOperator new];
    }
    return _netWorking;
}

- (SVRLoginOperator *)loginOutNetWorking{
    if (!_loginOutNetWorking) {
        _loginOutNetWorking = [SVRLoginOperator new];
    }
    return _loginOutNetWorking;
}

/**
 *  
 *  get Device List
 */
- (void)getDeviceList{
    [[self.netWorking getDeviceList] subscribeNext:^(id respose) {
        DebugLog(@"urlPath = %@",respose);  

        NSNumber *result = respose[@"result"];
        if (result) {   // result field exist in the response
            NSInteger errorCode = [result integerValue];
            if (errorCode == 0) {
                //组装统一格式的数据
                NSMutableArray *groupArray = [NSMutableArray array];
                NSArray *ungroup = respose[@"ungroup"];
                if (ArrayNotEmpty(ungroup)) {
                    NSMutableArray *changeUngroup = [NSMutableArray array];
                    for(NSDictionary *dic in ungroup){

                        [changeUngroup addObject:dic];
                    }
                    NSDictionary *ungroupDic = @{@"devices":ungroup,@"name":NSLocalizedString(@"ungroup", nil)};
                    [groupArray addObject:ungroupDic];
                }
                NSArray *shareArray = respose[@"shared"];
                if (ArrayNotEmpty(shareArray)) {
                    NSMutableArray *changeShareArray = [NSMutableArray array];
                    for (NSDictionary *dic in shareArray) {

                        [changeShareArray addObject:dic];
                    }
                    NSDictionary *shareDic = @{@"devices":shareArray,@"name":NSLocalizedString(@"sharegroup", nil)};
                    [groupArray addObject:shareDic];
                }
                
                NSMutableArray *groupsArray = [NSMutableArray arrayWithArray:respose[@"groups"]];
                NSMutableArray *changeGroupsArray = [NSMutableArray array];
                for (NSDictionary *groupsDic in groupsArray) {
                    NSArray *gArray = groupsDic[@"devices"];
                    NSMutableArray *changeArray = [NSMutableArray array];
                    for (NSDictionary *dic in gArray) {
                        [changeArray addObject:dic];
                    }
                    [changeGroupsArray addObject:@{@"devices":changeArray,@"name":groupsDic[@"name"]}];
                }
                if (ArrayNotEmpty(changeGroupsArray)) {
                    [groupArray addObjectsFromArray:changeGroupsArray];
                }

                if (ArrayNotEmpty(groupArray)) {
                    [self.vmHandler showGroupList:groupArray];
                }else{
                    [self.vmHandler showErrorMsg:NSLocalizedString(@"no_data", nil)];
                }
                
            }else if(errorCode == 100){
                [self.vmHandler showErrorMsg:NSLocalizedString(@"login_state_expired", nil)];

                [self.vmHandler loginFail];
            }else{
                [self.vmHandler showErrorMsg:respose[@"message"]];
                [self.vmHandler loginFail];
            }
        }else{
            [self.vmHandler showErrorMsg:NSLocalizedString(@"login_state_expired", nil)];
            [self.vmHandler loginFail];
        }
    } error:^(NSError *error) {
        [self.vmHandler showErrorMsg:NSLocalizedString(@"fail_net", nil)];
        
    }];
}

- (void)loginOut{
    [[self.loginOutNetWorking loginOut] subscribeNext:^(id respose) {
        NSNumber *result = respose[@"result"];
        if (result) {
            NSInteger errorCode = [result integerValue];
            if (errorCode == 0) {
                [self.vmHandler loginFail];
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

@end
