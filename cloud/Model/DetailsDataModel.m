//
//  DetailsDataModel.m
//  cloud
//
//  Created by 崔远寿 on 16/1/7.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import "DetailsDataModel.h"

@implementation DetailsDataModel

+ (NSValueTransformer *)localTimeJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *timestamp) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:([timestamp doubleValue]/1000)];
        
        NSDateFormatter *localFormat = [[NSDateFormatter alloc] init];
        [localFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
        [localFormat setTimeZone:[NSTimeZone localTimeZone]];
        
        return [localFormat stringFromDate:date];
    } reverseBlock:^(NSString *date) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
        [dateFormat setTimeZone:[NSTimeZone localTimeZone]];
        NSDate *datens = [dateFormat dateFromString:date];
        return  [[NSNumber numberWithDouble:[datens timeIntervalSince1970]] stringValue];
    }];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"time" : @"time",
             @"localTime" : @"lastDataTime",
             @"humidity" : @"humidity",
             @"temp" : @"temp",
             @"rssi" : @"rssi",
             @"energy" : @"energy",
             };
}

@end
