//
//  BaseSVRRequestOperator.h
//  cloud
//
//  Created by 崔远寿 on 16/1/4.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

//超时时间
#define kSVRDefaultTimeout           30.0f

//服务器域名
#define kAppServerDomain            @"http://www.norra.cn"
//#define kAppServerDomain            @"http://eu.norra.cn"
//#define kAppServerDomain            @"http://www.vip.norra.com.cn"


typedef void (^NetworkCallBackBlock)( BOOL finished, id responseObject, NSError *error);


@class AFHTTPResponseSerializer;
@class AFHTTPSessionManager;
@class AFJSONRequestOperation;

@interface BaseSVRRequestOperator : NSObject


@property (nonatomic, strong) NSMutableArray *afRequestArray;
@property (nonatomic, strong) AFHTTPSessionManager *manager;
// 停止所有请求
- (void)cancelRequest;

- (AFHTTPResponseSerializer *)createResponseSerializer;


+ (NSString *)serverDomain;

//请求网络

-(void)requestNetworkWithHost:(NSString *)host
                         path:(NSString *)path
                       isPost:(NSString *)type
                   parameters:(NSDictionary *)parameters
                  reserveInfo:(id)reserveInfo
                callBackBlock:(NetworkCallBackBlock)callBackBlock;




@end
