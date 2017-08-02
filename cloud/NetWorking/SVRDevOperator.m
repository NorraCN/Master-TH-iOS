//
//  SVRDevOperator.m
//  cloud
//
//  Created by 崔远寿 on 16/1/6.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import "SVRDevOperator.h"

@implementation SVRDevOperator

- (RACSignal *)getDeviceList{
    @weakify(self);
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self);
        static NSString *apiName = @"json/deviceList";
        
        NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
        [dicParam setObject:AppConfigInstance.appToken forKey:@"appToken"];
        
        [self requestNetworkWithHost:[BaseSVRRequestOperator serverDomain] path:apiName isPost:@"GET" parameters:dicParam reserveInfo:nil callBackBlock:^(BOOL finished, id responseObject, NSError *error) {
            if(error)
            {
                [subscriber sendNext:responseObject];
                [subscriber sendError:error];
            }
            else
            {
                [subscriber sendNext:responseObject];
            }
            [subscriber sendCompleted];
            
        }];
        return [RACDisposable disposableWithBlock:^{}];
    }] doError:^(NSError *error) {
        
    }];
}

- (RACSignal *)getDeviceDetails:(NSNumber *)deviceId{
    @weakify(self);
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self);
        static NSString *apiName = @"json/devDetails";
        
        NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
        [dicParam setObject:AppConfigInstance.appToken forKey:@"appToken"];
        [dicParam setObject:deviceId forKey:@"deviceId"];
        [self requestNetworkWithHost:[BaseSVRRequestOperator serverDomain] path:apiName isPost:@"POST" parameters:dicParam reserveInfo:nil callBackBlock:^(BOOL finished, id responseObject, NSError *error) {
            if(error)
            {
                [subscriber sendNext:responseObject];
                [subscriber sendError:error];
            }
            else
            {
                [subscriber sendNext:responseObject];
            }
            [subscriber sendCompleted];
            
        }];
        return [RACDisposable disposableWithBlock:^{}];
    }] doError:^(NSError *error) {
        
    }];
}

- (RACSignal *) enableAlarm:(BOOL)decision forDeviceID:(NSNumber *)deviceId {
    @weakify(self);
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self);
        static NSString *apiName = @"NDCenter/json/alarmCtrl";
        
        NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
        [dicParam setObject:AppConfigInstance.appToken forKey:@"appToken"];
        [dicParam setObject:deviceId forKey:@"deviceId"];
        [dicParam setObject:[NSString stringWithUTF8String: !decision ? "true" : "false"]  forKey:@"closeAlarm"]; // [TODO] maybe change the key name.
        DebugLog(@"dicParam sent closeAlarm = %d", decision);
        DebugLog(@"dicParam sent closeAlarm = %d", decision);
        
        [self requestNetworkWithHost:[BaseSVRRequestOperator serverDomain] path:apiName isPost:@"POST" parameters:dicParam reserveInfo:nil callBackBlock:^(BOOL finished, id responseObject, NSError *error) {
            if(error)
            {
                [subscriber sendNext:responseObject];
                [subscriber sendError:error];
            }
            else
            {
                [subscriber sendNext:responseObject];
            }
            [subscriber sendCompleted];
            
        }];
        return [RACDisposable disposableWithBlock:^{}];
    }] doError:^(NSError *error) {
        
    }];
}

- (RACSignal *)getHistoryDetails:(NSNumber *)deviceId pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize startTime:(NSString *)startTime
                         endTime:(NSString *)endTime{
    @weakify(self);
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self);
        static NSString *apiName = @"json/history";
        
        NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
        [dicParam setObject:AppConfigInstance.appToken forKey:@"appToken"];
        [dicParam setObject:deviceId forKey:@"deviceId"];
        [dicParam setObject:pageNum forKey:@"pageNum"];
        [dicParam setObject:pageSize forKey:@"pageSize"];
        // convert time to Beijing Time
        NSDateFormatter *localFormat = [[NSDateFormatter alloc] init];
        [localFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
        [localFormat setTimeZone:[NSTimeZone localTimeZone]];
        NSDate* start = [localFormat dateFromString:startTime];
        NSDate* end = [localFormat dateFromString:endTime];
        
        NSDateFormatter* beijingFormat = [[NSDateFormatter alloc] init];
        [beijingFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
        [beijingFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        
        
        [dicParam setObject:[beijingFormat stringFromDate:start] forKey:@"start"];
        [dicParam setObject:[beijingFormat stringFromDate:end] forKey:@"end"];
        [self requestNetworkWithHost:[BaseSVRRequestOperator serverDomain] path:apiName isPost:@"GET" parameters:dicParam reserveInfo:nil callBackBlock:^(BOOL finished, id responseObject, NSError *error) {
            if(error)
            {
                [subscriber sendNext:responseObject];
                [subscriber sendError:error];
            }
            else
            {
                [subscriber sendNext:responseObject];
            }
            [subscriber sendCompleted];
            
        }];
        return [RACDisposable disposableWithBlock:^{}];
    }] doError:^(NSError *error) {
        
    }];
}


@end
