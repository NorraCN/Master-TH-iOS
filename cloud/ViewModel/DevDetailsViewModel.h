//
//  DevDetailsViewModel.h
//  cloud
//
//  Created by 崔远寿 on 16/1/7.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import "DevDetailsVMInterface.h"

@interface DevDetailsViewModel : NSObject
<
    DevDetailsVMInterface
>

@property (nonatomic,weak) id<DevDetailsVMInterface> vmHandler;

@end
