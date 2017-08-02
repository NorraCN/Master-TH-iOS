//
//  GVUserDefaults+AppConfig.m
//  Vaccin
//
//  Created by jimple on 14/7/29.
//  Copyright (c) 2014年 Threegene. All rights reserved.
//

#import "GVUserDefaults+AppConfig.h"

@implementation GVUserDefaults (AppConfig)

@dynamic appToken;
@dynamic jpushToken;

- (NSDictionary *)setupDefaults
{
    return @{
                @"appToken" : @"",
                @"jpushToken" : @"-1",
             };
}

- (void)saveAll
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}





























@end
