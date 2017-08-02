//
//  BaseSVRRequestOperator.m
//  WSaiApp
//
//  Created by zhangym on 15/4/17.
//  Copyright (c) 2015年 StraMac. All rights reserved.
//

#import "BaseSVRRequestOperator.h"

@implementation BaseSVRRequestOperator

- (instancetype)init
{
    self = [super init];
    if (self)
    {
//        [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
        
    }else{}
    return self;
}

- (void)dealloc
{
    [self cancelRequest];
}

// 停止所有请求
- (void)cancelRequest
{
    
//    for (AFHTTPRequestOperation *afRequest in self.afRequestArray) {
//        [afRequest cancel];
//    }
}

- (AFHTTPResponseSerializer *)createResponseSerializer
{
    return [AFJSONResponseSerializer serializer];
}


+ (NSString *)serverDomain
{
    return kAppServerDomain;
}






-(void)requestNetworkWithHost:(NSString *)host
                         path:(NSString *)path
                       isPost:(NSString *)type
                   parameters:(NSDictionary *)parameters
                  reserveInfo:(id)reserveInfo
                callBackBlock:(NetworkCallBackBlock)callBackBlock
{
    [self requestNetworkWithHost:host
                            path:path
                          isPost:type
                      parameters:parameters
                         timeOut:kSVRDefaultTimeout
                     reserveInfo:reserveInfo
                   callBackBlock:callBackBlock];
}

/**
 *  <#Description#>
 *
 *  @param host          <#host description#>
 *  @param path          <#path description#>
 *  @param type          <#type description#>
 *  @param parameters    <#parameters description#>
 *  @param timeOut       必须加入这个功 [TODO]
 *  @param reserveInfo   <#reserveInfo description#>
 *  @param callBackBlock <#callBackBlock description#>
 */
- (void)requestNetworkWithHost:(NSString *)host
                          path:(NSString *)path
                        isPost:(NSString *)type
                    parameters:(NSDictionary *)parameters
                       timeOut:(CGFloat)timeOut
                   reserveInfo:(id)reserveInfo
                 callBackBlock:(NetworkCallBackBlock)callBackBlock
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSString *urlPath = [NSString stringWithFormat:@"%@/%@", host, path];
    DebugLog(@"urlPath = %@",urlPath);  // 查看一下URL
    self.manager = [AFHTTPSessionManager manager];

    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];

    if ([type isEqualToString:@"GET"]) {
        [self.manager GET:urlPath parameters:paramDic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            DebugLog(@"GET session response Object成功返回 %@",responseObject); // 看成功的返回值。
            
            /**
             *  @author Kangqiao, 16-08-24 11:08:23
             *
             *  [ISSUE]问题是：block 参数 finished 在block实现中根本没用，所以这里的if， else没差别。
             */
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]])
            {   // 有返回一个NSDictionary Class的对象
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(callBackBlock) callBackBlock(YES, responseObject, nil);  // YES: finished根本没用到
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(callBackBlock) callBackBlock(NO, responseObject, nil);   // NO: not finished
                });
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            DebugLog(@"GET session error 返回错误 %@",error); // 看失败的error。
            dispatch_async(dispatch_get_main_queue(), ^{
                if(callBackBlock) callBackBlock(NO, nil, error);
            });
        }];
        
    }else{
        [self.manager POST:urlPath parameters:paramDic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            DebugLog(@"%@",responseObject);
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(callBackBlock) callBackBlock(YES, responseObject, nil);
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(callBackBlock) callBackBlock(NO, responseObject, nil);
                });
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(callBackBlock) callBackBlock(NO, nil, error);
            });
        }];
    }
}


@end
