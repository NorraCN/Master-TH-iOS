//
//  SVRLoginOperator.m
//  cloud
//
//  Created by 崔远寿 on 16/1/5.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import "SVRLoginOperator.h"

@interface SVRLoginOperator ()

@end

@implementation SVRLoginOperator

/**
 *
 *  POST request to get Jsession ID string
 *
 *  @return <#return value description#>
 */
- (RACSignal *)getJsessionIdString{
    @weakify(self);
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self);
        
    static NSString *apiName = @"json/jsessionid";
        
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
        
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

- (RACSignal *)refreshPic:(NSString *)jsessionid{
    @weakify(self);
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self);
        NSString *apiName = [NSString stringWithFormat:@"front/codingImage;jsessionid=%@",jsessionid];
        
        NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
        
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
/**
 *
 *  Login GET request
 *
 *  @param userName   <#userName description#>
 *  @param passWord   <#passWord description#>
 *  @param codeString <#codeString description#>
 *  @param jsessionid <#jsessionid description#>
 *
 *  @return <#return value description#>
 */
- (RACSignal *)login:(NSString *)userName PassW:(NSString *)passWord Code:(NSString *)codeString jsessionid:(NSString *)jsessionid{
    @weakify(self);
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self);
        NSString *apiName = [NSString stringWithFormat:@"json/login;jsessionid=%@",jsessionid];
        
        NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
        [dicParam setObject:userName forKey:@"userName"];
        [dicParam setObject:passWord forKey:@"ticket"];
        [dicParam setObject:codeString forKey:@"securityCode"];
        if (StringNotEmpty(AppConfigInstance.jpushToken)) {
            [dicParam setObject:AppConfigInstance.jpushToken forKey:@"appTarget"];
        }else{
            [dicParam setObject:@"-1" forKey:@"appTarget"];
        }
        
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

- (RACSignal *)loginOut{
    @weakify(self);
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self);
        static NSString *apiName = @"json/logout";
        
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


@end
