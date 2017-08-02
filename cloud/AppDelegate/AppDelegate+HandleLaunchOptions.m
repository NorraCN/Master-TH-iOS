//
//  AppDelegate+HandleLaunchOptions.m
//  cloud
//
//  Created by 崔远寿 on 16/1/4.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import "AppDelegate+HandleLaunchOptions.h"
#import "JPUSHService.h"
#import "objc/runtime.h"
#import "JpushViewController.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@implementation AppDelegate (HandleLaunchOptions)

- (void)handleLaunchOptions:(NSDictionary *)options
{
    [JPUSHService setDebugMode];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    // 根据notification名字选择用什么SELECTOR处理notification
    // 这个是login用的
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidLoginNotification object:nil];
    // 这个是（非APNS）
    [defaultCenter addObserver:self selector:@selector(ReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];

    
    //极光推送,iOS8系统设置推送的方法已经改变,故分开设置
    //NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //Required
    // init Push(2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil  )
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
//    [JPUSHService setupWithOption:options appKey:@"a9906c2a308c0a2625465ab3"
//                          channel:@"channel"
//                 apsForProduction:YES         // 用JPUSH web版，非生产模式可以推过来！！！ 但是我写的是YES啊。
//            advertisingIdentifier:nil];
    
    // SensorThere 中国版
    [JPUSHService setupWithOption:options appKey:@"a052869a61ae0045ae4de55c" channel:@"channel" apsForProduction:YES];
    // 掌握温湿度
//    [JPUSHService setupWithOption:options appKey:@"d90c5dd7a8b36177fde5f64b" channel:@"channel" apsForProduction:YES];
    
    //inhouse
//    [JPUSHService setupWithOption:options appKey:@"b694af2655bc780c79c138d8" channel:@"channel" apsForProduction:YES];

    // Required
    //如需兼容旧版本的方式，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化和同时使用pushConfig.plist文件声明appKey等配置内容。
//    [JPUSHService setupWithOption:launchOptions appKey:appKey channel:channel apsForProduction:isProduction];
    
//    // =============iOS 10 ================
//    if( SYSTEM_VERSION_LESS_THAN( @"10.0" ) )
//    {
//        [[UIApplication sharedApplication] registerUserNotificationSettings: [UIUserNotificationSettings
//                                                           settingsForTypes: (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
//                                                                 categories: nil]];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//        
//        if( options != nil )
//        {
//            NSLog( @"registerForPushWithOptions:" );
//        }
//    }
//    else
//    {
//        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//        center.delegate = self;
//        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error)
//         {
//             if( !error )
//             {
//                 [[UIApplication sharedApplication] registerForRemoteNotifications]; // required to get the app to do anything at all about push notifications
//                 NSLog( @"Push registration success." );
//             }
//             else
//             {
//                 NSLog( @"Push registration FAILED" );
//                 NSLog( @"ERROR: %@ - %@", error.localizedFailureReason, error.localizedDescription );
//                 NSLog( @"SUGGESTIONS: %@ - %@", error.localizedRecoveryOptions, error.localizedRecoverySuggestion );  
//             }  
//         }];  
//    }

}


// 极光推送注册
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];

    NSString *deviceId = @"";
    deviceId = [[deviceToken description] substringWithRange:NSMakeRange(1, [[deviceToken description] length]-2)];
    deviceId = [deviceId stringByReplacingOccurrencesOfString:@" " withString:@""];
    deviceId = [deviceId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    DLogPos(@"APNS deviceToken：deviceId = %@ , APService registrationID = %@", deviceId, [JPUSHService registrationID]);
    AppConfigInstance.jpushToken = [JPUSHService registrationID];
    [AppConfigInstance saveAll];
}



#pragma mark - enter different state
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[UIApplication sharedApplication]  setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [JPUSHService setBadge:0];
}


#pragma mark - RemoteNotification

/**
 *
 *  苹果官方APNs方式处理应用收到的远程通知。不管foreground还是susbend运行。通知会唤醒app到background，有30s的窗口完成一些处理。
 *  【问题】因为我们没有通知到服务器app的状况，区分处理，所以服务器误以为在后台，导致发送了bedge信息。。。把数据搞乱了就出现null。
    要想让这个方法在App后台的时候运行，content-available: 1 必须有。
    像这样：
     {
        "aps" : {
            "content-available" : 1
        },
        "data-id" : 345
     }
    这是iOS7以后的功能。
 
 *  In iOS 10 (NEW)
 * // This will fire in iOS 10 when the app is foreground or background, but not closed
 *
 *  @param application       某个APP
 *  @param userInfo          服务器传来的
 *  @param completionHandler completion handler
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // 1. JPUSHService 先处理一下 （Required）
    [JPUSHService handleRemoteNotification:userInfo];
    DebugLog(@"妹的进入了APNS通知方法！！！有completionHandler\n");
    // 2. 处理Notification， 不论前台收到的还是后台。注意：不是Message
    // 比如，接到远程通知后，再发个本地通知
    int badge = [[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] intValue];
    [JPUSHService setLocalNotification:[NSDate dateWithTimeIntervalSinceNow:1]
                             alertBody:[NSString stringWithFormat:@"badge is now: %d", badge]
                                 badge:badge
                           alertAction:@"aaction"
                         identifierKey:@"idkey"
                              userInfo:userInfo
                             soundName:@"default"];
    
    // 3. 30s 之内要掉这个block， 参考方法说明。
    completionHandler(UIBackgroundFetchResultNewData);  // what's the difference NoData, NewData.

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // 1. JPUSHService 先处理一下 （Required）
    [JPUSHService handleRemoteNotification:userInfo];
    DebugLog(@"妹的进入了APNS通知方法！！！\n");
    // 2. 处理Notification， 不论前台收到的还是后台。注意：不是Message
    // 比如，接到远程通知后，再发个本地通知
    int badge = [[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] intValue];
    [JPUSHService setLocalNotification:[NSDate dateWithTimeIntervalSinceNow:1]
                             alertBody:[NSString stringWithFormat:@"新徽章 is now: %d", badge]
                                 badge:badge
                           alertAction:@"aaction"
                         identifierKey:@"idkey"
                              userInfo:userInfo
                             soundName:@"default"];
    
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    NSLog( @"Handle push from foreground" );
    // custom code to handle push while app is in the foreground
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler
{
    NSLog( @"Handle push from background or closed" );
    // if you set a member variable in didReceiveRemoteNotification, you will know if this is from closed or background
}


// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    DebugLog(@"进来啦！！！willPresentNotification\n");
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    DebugLog(@"进来啦！！！didReceiveNotificationResponse:\n");
    completionHandler();  // 系统要求执行这个方法
}



#pragma mark- Foreground JPUSH
// 前台处理通知。把JPUSH view 搞出来。
- (void)handleNotificationWhenAppActive:(NSDictionary *)userInfo {
    // update badge
    [UIApplication sharedApplication].applicationIconBadgeNumber++;
    [JPUSHService setBadge:[UIApplication sharedApplication].applicationIconBadgeNumber];
    
    // 1. 拿到最上边VC
    UIViewController *controller = [self getTopViewController]; // 这个好使，能拿到最上的VC。
    
    // 2. 初始化VC，并给dataModel赋值
    DebugLog(@"JPUSH VC begin init.");
    JpushViewController *jpush = InstantiateVCFromStoryboard(@"Main", @"JpushViewController");
    DebugLog(@"JPUSH VC finish init.");
    jpush.userDic = userInfo;   // data model
    
    // 3. present VC
    /* 如果animation耗时多了。[JPUSHSessionController] Action - doSendTcpRequest发出去，那userInfo就null了
     另外就是如果animate过程中下一个message也到了，可能就不能及时处理，把新的View再覆盖上去，出现
     Warning: Attempt to present <JpushViewController: 0x13e90bd70> on <UINavigationController: 0x13e01d800> whose view is not in the window hierarchy!
     的问题。
     把userInfo property改成strong类型。好像解决了部分问题。通知多了，在进入前台的一瞬间也会有上述Warning。
     */
    [controller presentViewController:jpush animated:NO completion:^{
        // 理论上这里放一个flag使能下一个push进来。但是我还不知道怎么控制下一个PUSH进来的时机。
    }];
}


#pragma mark- Supporting methods
/**
 *  @author Kangqiao, 16-08-26 08:08:56
 *
 *  来自网络，stackoverflow。
 *
 *  @return 返回Top VC，好往上边叠东西。
 */
- (UIViewController *)getTopViewController {
    UIViewController *topViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topViewController.presentedViewController) topViewController = topViewController.presentedViewController;
    
    return topViewController;
}

// 登陆成功kJPFNetworkDidLoginNotification的通知方法
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    DebugLog(@"进入了：登陆成功kJPFNetworkDidLoginNotification的通知方法");
    // 既然login成功了，就不用再监视了。从Center里移除。
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPFNetworkDidLoginNotification object:nil];
    AppConfigInstance.jpushToken = [JPUSHService registrationID];
    [AppConfigInstance saveAll];
    
//    NSString *content = [userInfo valueForKey:@"content"];
//    NSDictionary *extras = [userInfo valueForKey:@"extras"];
//    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
    

}

// 收到消息(非APNS)kJPFNetworkDidReceiveMessageNotification的通知方法
- (void)ReceiveMessage:(NSNotification *)notification {
    DebugLog(@"进入了：收到消息(非APNS)kJPFNetworkDidReceiveMessageNotification的通知方法");
    NSDictionary * userInfo = [notification userInfo];
    DebugLog(@"(非APNS)[Notification userInfo]:%@",userInfo);
    // 字典里套的字典
    if (userInfo[@"content"]) {
        NSDictionary *contentDic = [self dictionaryWithJsonString:userInfo[@"content"]];
        // 这才是需要handle的消息内容
        if (contentDic) {
            [self handleNotificationWhenAppActive:contentDic];
        }
    }
}
// json 转 字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


@end
