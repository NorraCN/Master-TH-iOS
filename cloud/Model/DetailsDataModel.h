//
//  DetailsDataModel.h
//  cloud
//
//  Created by 崔远寿 on 16/1/7.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import <Mantle/Mantle.h>
/**
 *
 *  model for "data" key of the returned json in Device detail view.
 */
@interface DetailsDataModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *localTime;
@property (nonatomic, strong) NSNumber *humidity;
@property (nonatomic, strong) NSNumber *temp;
@property (nonatomic, strong) NSNumber *rssi;
@property (nonatomic, strong) NSNumber *energy;

@end
