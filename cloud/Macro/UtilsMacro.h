//
//  UtilsMacro.h
//  cloud
//
//  Created by 崔远寿 on 16/1/4.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#ifndef Vaccin_UtilsMacro_h
#define Vaccin_UtilsMacro_h


#ifdef DEBUG

#define ENABLE_ASSERT_STOP          1
#define ENABLE_DEBUGLOG             1

#endif

// 颜色日志
#define XCODE_COLORS_ESCAPE_MAC @"\033["
#define XCODE_COLORS_ESCAPE_IOS @"\xC2\xA0["
#define XCODE_COLORS_ESCAPE  XCODE_COLORS_ESCAPE_MAC
#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color
#define LogBlue(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg0,150,255;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogRed(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg250,0,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogGreen(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg0,235,30;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)

// debug log
#ifdef ENABLE_DEBUGLOG
#define DebugLog(...) NSLog(__VA_ARGS__)
#define DebugLogBlue(...) LogBlue(__VA_ARGS__)
#define DebugLogRed(...) LogRed(__VA_ARGS__)
#define DebugLogGreen(...) LogGreen(__VA_ARGS__)
#define DLogPos(s, ...) NSLog(@"=== %@ === %@ ===>> %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [NSString stringWithFormat:(s), ##__VA_ARGS__])
#else
#define DebugLog(...) do { } while (0);
#define DebugLogBlue(...) do { } while (0);
#define DebugLogRed(...) do { } while (0);
#define DebugLogGreen(...) do { } while (0);
#define DLogPos(...) do { } while (0);
#endif

// log
#define AppLog(...) NSLog(__VA_ARGS__)

// assert
#ifdef ENABLE_ASSERT_STOP
#define AssertStop                          {LogRed(@"APP_ASSERT_STOP"); NSAssert1(NO, @" \n\n\n===== APP Assert. =====\n%s\n\n\n", __PRETTY_FUNCTION__);}
#define AssertCondition(condition)          {NSAssert(condition, @" ! Assert");}
#else
#define AssertStop                          do {} while (0);
#define AssertCondition(condition)          do {} while (0);
#endif


/////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Redefine

#define AppBuildVersion                         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define AppVersion                              [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define AppName                                 [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey]
#define DeviceName                              [[UIDevice currentDevice] name]
#define DeviceModel                             [[UIDevice currentDevice] systemName]
#define DeviceVersion                           [[UIDevice currentDevice] systemVersion]
#define URLFromString(str)                      [NSURL URLWithString:str]
#define InstantiateVCFromStoryboard(storyboardName, VCID)       [[UIStoryboard storyboardWithName:storyboardName bundle:nil] instantiateViewControllerWithIdentifier:VCID]
 
#define ApplicationDelegate                 ((BubblyAppDelegate *)[[UIApplication sharedApplication] delegate])
#define UserDefaults                        [NSUserDefaults standardUserDefaults]
#define SharedApplication                   [UIApplication sharedApplication]
#define Bundle                              [NSBundle mainBundle]
#define MainScreen                          [UIScreen mainScreen]
#define ShowNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
#define NetworkActivityIndicatorVisible(x)  [UIApplication sharedApplication].networkActivityIndicatorVisible = x
#define SelfNavBar                          self.navigationController.navigationBar
#define SelfTabBar                          self.tabBarController.tabBar
#define SelfNavBarHeight                    self.navigationController.navigationBar.bounds.size.height
#define SelfTabBarHeight                    self.tabBarController.tabBar.bounds.size.height
#define ScreenRect                          [[UIScreen mainScreen] bounds]
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height
#define TouchHeightDefault                  44
#define TouchHeightSmall                    32
#define ViewWidth(v)                        v.frame.size.width
#define ViewHeight(v)                       v.frame.size.height
#define ViewX(v)                            v.frame.origin.x
#define ViewY(v)                            v.frame.origin.y
#define SelfViewHeight                      self.view.bounds.size.height
#define RectX(f)                            f.origin.x
#define RectY(f)                            f.origin.y
#define RectWidth(f)                        f.size.width
#define RectHeight(f)                       f.size.height
#define RectSetWidth(f, w)                  CGRectMake(RectX(f), RectY(f), w, RectHeight(f))
#define RectSetHeight(f, h)                 CGRectMake(RectX(f), RectY(f), RectWidth(f), h)
#define RectSetX(f, x)                      CGRectMake(x, RectY(f), RectWidth(f), RectHeight(f))
#define RectSetY(f, y)                      CGRectMake(RectX(f), y, RectWidth(f), RectHeight(f))
#define RectSetSize(f, w, h)                CGRectMake(RectX(f), RectY(f), w, h)
#define RectSetOrigin(f, x, y)              CGRectMake(x, y, RectWidth(f), RectHeight(f))
#define Rect(x, y, w, h)                    CGRectMake(x, y, w, h)
// #define DATE_COMPONENTS                     NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit 重复定义
#define TIME_COMPONENTS                     NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
#define FlushPool(p)                        [p drain]; p = [[NSAutoreleasePool alloc] init]
#define RGB(r, g, b)                        [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define StatusBarHeight                     [UIApplication sharedApplication].statusBarFrame.size.height
#define SelfDefaultToolbarHeight            self.navigationController.navigationBar.frame.size.height
#define IOSVersion                          [[[UIDevice currentDevice] systemVersion] floatValue]
#define IsiOS7Later                         !(IOSVersion < 7.0f)
#define IsiOS8Later                         !(IOSVersion < 8.0f)
#define iOS6                                (IOSVersion >= 6.0 && IOSVersion < 7.0)
#define iOS7                                (IOSVersion >= 7.0 && IOSVersion < 8.0)
#define iOS8                                (IOSVersion >= 8.0)


#define Size(w, h)                          CGSizeMake(w, h)
#define Point(x, y)                         CGPointMake(x, y)
#define IntNumber(i)                        [NSNumber numberWithInt:i]
#define IntegerNumber(i)                    [NSNumber numberWithInteger:i]
#define FloatNumber(f)                      [NSNumber numberWithFloat:f]
#define DoubleNumber(dl)                    [NSNumber numberWithDouble:dl]
#define BoolNumber(b)                       [NSNumber numberWithBool:b]

#define StringNotEmpty(str)                 (str && ![str isKindOfClass:[NSNull class]] && (str.length > 0))
#define ArrayNotEmpty(arr)                  (arr && ![arr isKindOfClass:[NSNull class]] && (arr.count > 0))
#define NumberIDValid(num)                  (num && [num isKindOfClass:NSNumber.class] && (num.integerValue > 0))       // 各种数据ID都是大于0的整数
#define InvalidNumberID                     @(-1)
#define ClassNameStr(ClassName)             (((void)(NO && ((void)ClassName.class, NO)), @#ClassName))



#define TabBarHeight                        49.0f
#define NaviBarHeight                       44.0f
#define HeightFor4InchScreen                568.0f
#define HeightFor3p5InchScreen              480.0f

#define ViewCtrlTopBarHeight                (IsiOS7Later ? (NaviBarHeight + StatusBarHeight) : NaviBarHeight)
#define IsUseIOS7SystemSwipeGoBack          (IsiOS7Later ? YES : NO)



#endif
