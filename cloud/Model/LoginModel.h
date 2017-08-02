    //
//  LoginModel.h
//  cloud
//
//  Created by 崔远寿 on 16/1/5.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface LoginModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign) BOOL success;
@property (nonatomic, copy) NSString *jsessionid;

@end



//1、请求jsessionid
//请求路径：http://www.vip.norra.com.cn/json/jsessionid
//返回：{"jsessionid":"37561436CB6881340B7F6E558CB6A72F"}

@interface JsessionidModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign) BOOL success;
@property (nonatomic, copy) NSString *jsessionid;

@end