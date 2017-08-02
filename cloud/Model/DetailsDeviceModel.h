//
//  DetailsDeviceModel.h
//  cloud
//
//  Created by 崔远寿 on 16/1/7.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import <Mantle/Mantle.h>
/**
 *
 *  model for "detail" key of the returned json in Device detail view.
 */
@interface DetailsDeviceModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *closeAlarm;
@property (nonatomic, strong) NSNumber *maxTemp;
@property (nonatomic, strong) NSNumber *deviceId;
@property (nonatomic, copy) NSString *details;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *maxHum;
@property (nonatomic, strong) NSNumber *minTemp;
@property (nonatomic, strong) NSNumber *minHum;
@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, copy) NSString *createOn;
@property (nonatomic, copy) NSString *localTime;
@property (nonatomic, strong) NSNumber *minEnergy;


@end
