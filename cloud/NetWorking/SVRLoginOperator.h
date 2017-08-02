//
//  SVRLoginOperator.h
//  cloud
//
//  Created by 崔远寿 on 16/1/5.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import "BaseSVRRequestOperator.h"
#import "LoginModel.h"

@interface SVRLoginOperator : BaseSVRRequestOperator

//1、请求jsessionid
//请求路径：http://www.vip.norra.com.cn/json/jsessionid
//返回：{"jsessionid":"37561436CB6881340B7F6E558CB6A72F"}
- (RACSignal *)getJsessionIdString;

//2、请求校验码图片
//请求路径：http://www.vip.norra.com.cn/front/codingImage;jsessionid=37561436CB6881340B7F6E558CB6A72F
//返回：图片数据流
- (RACSignal *)refreshPic:(NSString *)jsessionid;

- (RACSignal *)login:(NSString *)userName PassW:(NSString *)passWord Code:(NSString *)codeString jsessionid:(NSString *)jsessionid;

- (RACSignal *)loginOut;


@end
