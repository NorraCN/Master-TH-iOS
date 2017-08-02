//
//  DataListModel.h
//  cloud
//
//  Created by 崔远寿 on 16/3/10.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import <Mantle/Mantle.h>
/**
 *
 *  model for "devices" key of the returned json in Group view.
 */
@interface DataListModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *details;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *humidity;
@property (nonatomic, strong) NSNumber *deviceId;
@property (nonatomic, strong) NSNumber *temp;
@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, copy) NSString *createOn;
@property (nonatomic, copy) NSString *localTime;

@property (nonatomic, strong) NSNumber *maxHum;
@property (nonatomic, strong) NSNumber *maxTemp;
@property (nonatomic, strong) NSNumber *minEnergy;
@property (nonatomic, strong) NSNumber *minHum;
@property (nonatomic, strong) NSNumber *minTemp;


@end
