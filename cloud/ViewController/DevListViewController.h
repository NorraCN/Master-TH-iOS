//
//  DevListViewController.h
//  cloud
//
//  Created by 崔远寿 on 16/1/6.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RefreshDelegate <NSObject>

- (void)reloadData;

@end

@interface DevListViewController : UIViewController

@property (nonatomic,strong) NSArray *devList;
@property (nonatomic,weak) id<RefreshDelegate> delegate;

@end
