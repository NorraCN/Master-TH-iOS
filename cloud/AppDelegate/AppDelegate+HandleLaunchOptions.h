//
//  AppDelegate+HandleLaunchOptions.h
//  cloud
//
//  Created by 崔远寿 on 16/1/4.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (HandleLaunchOptions)

- (void)handleLaunchOptions:(NSDictionary *)options;
//- (void)updateApnsToken;
@property (nonatomic, weak) NSString* preBadge;

@end
