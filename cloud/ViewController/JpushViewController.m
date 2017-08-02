//
//  JpushViewController.m
//  cloud
//
//  Created by 崔远寿 on 16/3/7.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//
// 改进意见。20160810

#import "JpushViewController.h"
#import "JPUSHService.h"


@interface JpushViewController ()

@property (nonatomic,weak) IBOutlet UILabel *iferLabel;
@property (nonatomic,weak) IBOutlet UILabel *timeLabel;
@property (nonatomic,weak) IBOutlet UILabel *tempLabel;
@property (nonatomic,weak) IBOutlet UILabel *huiLabel;
@property (nonatomic, weak) IBOutlet UILabel *batteryLowLabel;
@property (nonatomic,weak) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation JpushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.userDic isEqual:null.null];
//    if (!self.userDic) {
//        DebugLog(@"属性userDic:%@",self.userDic);
//        return;
//    }
    DebugLog(@"外部属性userDic:%@",self.userDic);
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"device_name", nil), self.userDic[@"name"]] ;
    self.iferLabel.text = [NSString stringWithFormat:@"ID: %@", self.userDic[@"identifier"]] ;
    self.timeLabel.text = [NSString stringWithFormat:@"%@", [self localTimeJSONTransform: self.userDic[@"time"]  ]];
    
    DebugLog(@"Default");
    self.tempLabel.textColor = [UIColor grayColor];
    self.huiLabel.textColor = [UIColor grayColor];
    if (([self.userDic[@"state"] integerValue] & 1) == 1) {
        DebugLog(@"Temp High");
        self.tempLabel.textColor = [UIColor redColor];
    }
    if (([self.userDic[@"state"] integerValue] & 2) == 2) {
        DebugLog(@"Temp Low");
        self.tempLabel.textColor = [UIColor blueColor];
    }
    if (([self.userDic[@"state"] integerValue] & 4) == 4) {
        DebugLog(@"Humid High");
        self.huiLabel.textColor = [UIColor redColor];
    }
    if (([self.userDic[@"state"] integerValue] & 8) == 8) {
        DebugLog(@"Temp Low");
        self.huiLabel.textColor = [UIColor blueColor];
    }
    if (([self.userDic[@"state"] integerValue] & 16) == 16) {
        DebugLog(@"battery Low");
        self.batteryLowLabel.text = [NSString stringWithFormat:@"%@", NSLocalizedString(@"batteryLow", nil)];
    } else {
        self.batteryLowLabel.text = [NSString stringWithFormat:@""];
    }

    
    self.tempLabel.text = [NSString stringWithFormat:@"%@: %0.1f℃",NSLocalizedString(@"temperature", nil),[self.userDic[@"temp"] floatValue]];
//    self.huiLabel.numberOfLines = 2;
    self.huiLabel.text = [NSString stringWithFormat:@"%@: %0.1f %%",NSLocalizedString(@"humidity", nil),[self.userDic[@"humidity"] floatValue]];
    [self.btn setTitle:NSLocalizedString(@"confirm", nil) forState:UIControlStateNormal];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickBtn:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        // [TODO] 是否应该定位到出问题的设备。或再列出一个GOTO按钮。
        
        // 这里可以把badge处理了。
        NSInteger currentBadge = [UIApplication sharedApplication].applicationIconBadgeNumber;
        DebugLog(@"currentBadge = %ld",currentBadge);
        UIViewController *vc = [[self presentingViewController] presentingViewController];
        DebugLog(@"pp VC: %@",vc);
//        if (currentBadge>5) currentBadge = 5;   // JPUSH最多存5条离线消息。这只是权宜之计。。
        [UIApplication sharedApplication].applicationIconBadgeNumber = currentBadge - 1;
        [JPUSHService setBadge:currentBadge - 1];

    }];
}


# pragma mark - function

- (NSString *)localTimeJSONTransform:(NSNumber *) timeSince1970
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([timeSince1970 doubleValue]/1000)];
    
    NSDateFormatter *localFormat = [[NSDateFormatter alloc] init];
    [localFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    [localFormat setTimeZone:[NSTimeZone localTimeZone]];
    return [localFormat stringFromDate:date];
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
