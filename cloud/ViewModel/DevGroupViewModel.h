//
//  DevGroupViewModel.h
//  cloud
//
//  Created by 崔远寿 on 16/1/6.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DevGroupVMInterface.h"

@interface DevGroupViewModel : NSObject
<
    DevGroupVMInterface
>

@property (nonatomic,weak) id<DevGroupVMInterface> vmHandler;

@end
