//
//  DevHistoryViewModel.h
//  cloud
//
//  Created by 崔远寿 on 16/1/7.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import "DevHistoryVMInterface.h"

@interface DevHistoryViewModel : NSObject
<
    DevHistoryVMInterface
>

@property (nonatomic,weak) id<DevHistoryVMInterface> vmHandler;

@end
