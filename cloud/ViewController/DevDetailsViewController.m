//
//  DevDetailsViewController.m
//  cloud
//
//  Created by 崔远寿 on 16/1/6.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import "DevDetailsViewController.h"
#import "DevDetailsViewModel.h"
#import "DevHistoryViewController.h"
#import "JpushViewController.h"
#import "UtilityUI+Refresh.h"

@protocol AlarmStatusDelegate <NSObject>

@optional
- (void)alarmStatusChangeTo:(BOOL)onStatus;

@end

@interface DevDetailsContentCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *contenLabel;

@end

@implementation DevDetailsContentCell

@end

@interface DevDetailsWarningCell : UITableViewCell
<
    AlarmStatusDelegate
>

@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UISwitch *warningSwitch;

@property (nonatomic,weak) id<AlarmStatusDelegate> delegate;

@end

@implementation DevDetailsWarningCell

- (IBAction)switchToggle:(UISwitch *)sender {
    [self.delegate alarmStatusChangeTo:sender.on];
}


@end



@interface DevDetailsViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    DevDetailsVMInterface,
    AlarmStatusDelegate
>

@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,weak) IBOutlet UILabel *temperatureLabel;
@property (nonatomic,weak) IBOutlet UILabel *temperatureStatusLabel;
@property (nonatomic,weak) IBOutlet UILabel *moistureLabel;
@property (nonatomic,weak) IBOutlet UILabel *moistureStatusLabel;
@property (nonatomic,weak) IBOutlet UILabel *timeLabel;

@property (nonatomic,weak) IBOutlet UIButton *historyButton;

@property (nonatomic,strong) DevDetailsViewModel *viewModel;
@property (nonatomic,strong) DetailsDataModel *dataModel;
@property (nonatomic,strong) DetailsDeviceModel *deviceModel;

@end

@implementation DevDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.historyButton.layer.cornerRadius = 8;
    self.historyButton.layer.borderWidth = 1;
    self.historyButton.layer.borderColor = [UIColor colorWithRed:225/255. green:225/255. blue:225/255. alpha:1].CGColor;
    self.historyButton.layer.masksToBounds = YES;
    
    [self defaultNaviBarShowTitle:self.name];
    
    
    self.viewModel = [DevDetailsViewModel new];
    self.viewModel.vmHandler = self;
    
    __unsafe_unretained UITableView *tableView = self.tableView;
    
    // 下拉刷新
    tableView.mj_header= [MJDIYHeader headerWithRefreshingBlock:^{
        [self refreshDetails];
        [UtilityUI endRefreshingAt:tableView];
    }];

    // 马上进入刷新状态
    [self refreshDetails];
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    [self refreshHeader];
}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    [self refreshHeader];
//}



- (void)refreshDetails{
    [self showLoadingIndicatorInView];
    [self.viewModel getDeviceDetails:self.deviceId];
}


- (void)updateDataDetails{
    self.timeLabel.text = self.dataModel.localTime;

    self.temperatureLabel.text = [NSString stringWithFormat:@"%.1f",[self.dataModel.temp floatValue]];
    self.moistureLabel.text = [NSString stringWithFormat:@"%.1f",[self.dataModel.humidity floatValue]];
    
    if ([self.dataModel.temp floatValue] > [self.deviceModel.maxTemp floatValue]) {
        if (self.deviceModel.maxTemp == nil) {
            self.temperatureStatusLabel.text = @"";
        }else{
            self.temperatureStatusLabel.text = NSLocalizedString(@"temperature_high", nil);
            [self.temperatureLabel setTextColor:[UIColor redColor]];
        }

        
    }else if([self.dataModel.temp floatValue] < [self.deviceModel.minTemp floatValue]){
        self.temperatureStatusLabel.text = NSLocalizedString(@"temperature_low", nil);
        [self.temperatureLabel setTextColor:[UIColor redColor]];
    }else{
        self.temperatureStatusLabel.text = NSLocalizedString(@"temperature_normal", nil);
        [self.temperatureLabel setTextColor:[UIColor blueColor]];
    }
    
    if ([self.dataModel.humidity floatValue] > [self.deviceModel.maxHum floatValue]) {
        if (self.deviceModel.maxHum == nil) {
            self.moistureStatusLabel.text = @"";
        }else{
            self.moistureStatusLabel.text =  NSLocalizedString(@"humidity_high", nil);
            [self.moistureLabel setTextColor:[UIColor redColor]];
        }

    }else if([self.dataModel.humidity floatValue] < [self.deviceModel.minTemp floatValue]){
        self.moistureStatusLabel.text =  NSLocalizedString(@"humidity_low", nil);
        [self.moistureLabel setTextColor:[UIColor redColor]];
    }else{
        self.moistureStatusLabel.text =  NSLocalizedString(@"humidity_normal", nil);
        [self.moistureLabel setTextColor:[UIColor blueColor]];
    }
    [self.tableView reloadData];
}


#pragma mark - Action
- (IBAction)historyClick:(id)sender{
    DevHistoryViewController *historyVC = InstantiateVCFromStoryboard(@"Main", @"DevHistoryViewController");
    historyVC.deviceId = self.deviceId;
    [self.navigationController pushViewController:historyVC animated:YES];
}

//- (void) refreshHeader {
//    [UtilityUI addHeaderRefreshViewAt:self.tableView withRefreshActionBolck:^{
//        [self refreshDetails];
//    }];
//
//}




#pragma mark - UITableViewDataSource & UITableViewDelegate
// 返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// 返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            
            DevDetailsWarningCell *cell = (DevDetailsWarningCell *)[tableView dequeueReusableCellWithIdentifier:@"DevDetailsWarningCell"];
            cell.delegate = self;
            if ([self.deviceModel.closeAlarm boolValue]) {  // logic decision need to be checked.
                [cell.warningSwitch setOn:NO];
            }else{
                [cell.warningSwitch setOn:YES];
            }
            cell.nameLabel.text = NSLocalizedString(@"alert_set", nil);
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            break;
        case 2:{
            DevDetailsContentCell *cell = (DevDetailsContentCell *)[tableView dequeueReusableCellWithIdentifier:@"DevDetailsContentCell"];
            cell.nameLabel.text =  NSLocalizedString(@"left_power", nil);
            if (self.dataModel.energy == nil) {
                cell.contenLabel.text = @"";
                
            }else{
                cell.contenLabel.text = [NSString stringWithFormat:@"%@ %@",self.dataModel.energy,@"%"];
                if ([self.dataModel.energy floatValue] < [self.deviceModel.minEnergy floatValue]) {
                    [cell.contenLabel setTextColor:[UIColor redColor]];
                }else{
                    [cell.contenLabel setTextColor:[UIColor lightGrayColor]];
                }
            }
            

            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        case 4:{
            DevDetailsContentCell *cell = (DevDetailsContentCell *)[tableView dequeueReusableCellWithIdentifier:@"DevDetailsContentCell"];
            [cell.contenLabel setTextColor:[UIColor lightGrayColor]];
            cell.nameLabel.text = NSLocalizedString(@"temperature_normal_range", nil);
            if (self.deviceModel.minTemp == nil || self.deviceModel.maxTemp == nil) {
                if(self.deviceModel.minTemp){
                    cell.contenLabel.text = [NSString stringWithFormat:@"%@~%@(℃)",self.deviceModel.minTemp,@""];

                }else if (self.deviceModel.maxTemp) {
                    cell.contenLabel.text = [NSString stringWithFormat:@"%@~%@(℃)",@"",self.deviceModel.maxTemp];
                }else{
                    cell.contenLabel.text = NSLocalizedString(@"Not_set", nil);
                }
            }else{
                cell.contenLabel.text = [NSString stringWithFormat:@"%@~%@(℃)",self.deviceModel.minTemp,self.deviceModel.maxTemp];

            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        case 6:{
            DevDetailsContentCell *cell = (DevDetailsContentCell *)[tableView dequeueReusableCellWithIdentifier:@"DevDetailsContentCell"];
            [cell.contenLabel setTextColor:[UIColor lightGrayColor]];
            cell.nameLabel.text = NSLocalizedString(@"humidity_normal_range", nil);
            if (self.deviceModel.minHum == nil || self.deviceModel.maxHum == nil) {
                if (self.deviceModel.minHum) {
                    cell.contenLabel.text = [NSString stringWithFormat:@"%@~%@(℃)",self.deviceModel.minHum,@""];

                }else if (self.deviceModel.maxHum) {
                    cell.contenLabel.text = [NSString stringWithFormat:@"%@~%@(℃)",@"",self.deviceModel.maxHum];

                }else{
                    cell.contenLabel.text = NSLocalizedString(@"Not_set", nil);
                }
                
            }else{
                cell.contenLabel.text = [NSString stringWithFormat:@"%@~%@(℃)",self.deviceModel.minHum,self.deviceModel.maxHum];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            
        default:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;

        }
            break;
    }
}

// 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 6) {
        return 44;
    }
    return 15;
}

// 让cell不能被选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark --ViewModel

- (void)showErrorMsg:(NSString *)errorMsg{
    [self hideLoadingIndicatorInView];
    [self showNoticeText:errorMsg];
}

- (void)showDetailsWithData:(DetailsDataModel *)dataModel device:(DetailsDeviceModel *)deviceModel{
    [self hideLoadingIndicatorInView];
    self.dataModel = dataModel;
    self.deviceModel = deviceModel;
    [self updateDataDetails];
}
/**
 *  @author Kangqiao, 16-08-17 13:08:42
 *
 *  除非服务器返回的result=0,表示更新alarmStatus成功，否则，succeed为YES的部分不应该执行。
 *  因为这部分只更新本地dataModel。如果服务器端，并没有更新成功，那就会有分歧了。
 *
 *  @param succeed 表示switch成功改变状态到 On 或 Off。只表示成功与否，与最终是什么状态(On/Off)无关。
 */
- (void)switchToggleSucceed:(BOOL)succeed {
    if (succeed) {     // toggled the switch
        [self hideLoadingIndicatorInView];
        self.deviceModel.closeAlarm = [NSNumber numberWithBool:![self.deviceModel.closeAlarm boolValue]];
        [self.tableView reloadData];
    }else{
        [self showNoticeText: NSLocalizedString(@"fail_net", nil)];
        [self.tableView reloadData];
    }
}
/**
 *  @author Kangqiao, 16-08-17 13:08:48
 *
 *  让此设备的Alarm状态改变为On或Off。
 *
 *  @param onStatus 如果是YES则为On状态，NO为Off状态。
 */
- (void)alarmStatusChangeTo:(BOOL)onStatus{
    [self showLoadingIndicatorInView];
    // 发请求去改服务器状态。
    [self.viewModel enableAlarm:onStatus forDeviceID:self.deviceId];
}


@end
