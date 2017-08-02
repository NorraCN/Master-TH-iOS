//
//  SVRDevOperator.h
//  cloud
//
//  Created by 崔远寿 on 16/1/6.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import "BaseSVRRequestOperator.h"

@interface SVRDevOperator : BaseSVRRequestOperator

- (RACSignal *)getDeviceList;

- (RACSignal *)getDeviceDetails:(NSNumber *)deviceId;

- (RACSignal *)enableAlarm:(BOOL)decision forDeviceID:(NSNumber *)deviceId;


- (RACSignal *)getHistoryDetails:(NSNumber *)deviceId pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize startTime:(NSString *)startTime
                         endTime:(NSString *)endTime;



@end
