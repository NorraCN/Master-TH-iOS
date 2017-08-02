//
//  GVUserDefaults+AppConfig.h
//  Vaccin
//
//  Created by jimple on 14/7/29.
//  Copyright (c) 2014年 Threegene. All rights reserved.
//

#import "GVUserDefaults.h"

#define AppConfigInstance                   [GVUserDefaults standardUserDefaults]



@interface GVUserDefaults (AppConfig)

//用户token
@property (nonatomic,weak) NSString *appToken;
@property (nonatomic,weak) NSString *jpushToken;


- (void)saveAll;




@end
