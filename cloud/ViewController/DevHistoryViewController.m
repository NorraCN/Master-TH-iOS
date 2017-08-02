//
//  DevHistoryViewController.m
//  cloud
//
//  Created by 崔远寿 on 16/1/7.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import "DevHistoryViewController.h"
#import "NSDate+Utils.h"
#import "DevHistoryViewModel.h"
#import "UtilityUI+Refresh.h"


#define  HistoryPageSize 20

@interface DevHistoryCell:UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *tempLabel;
@property (nonatomic,weak) IBOutlet UILabel *humLabel;
@property (nonatomic,weak) IBOutlet UILabel *timeLabel;

@end

@implementation DevHistoryCell


@end

@interface DevHistoryViewController()

<
    UITableViewDataSource,
    UITableViewDelegate,
    DevHistoryVMInterface
>

@property (nonatomic,weak) IBOutlet UIButton *startBtn;
@property (nonatomic,weak) IBOutlet UIButton *endBtn;
@property (nonatomic,weak) IBOutlet UIButton *searchBtn;

@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,weak) IBOutlet UILabel *countLabel;

@property (nonatomic,strong) DevHistoryViewModel *viewModel;

@property (nonatomic,assign) NSInteger pageNum;
@property (nonatomic,strong) NSMutableArray *historyArray;

//选择日期
@property (nonatomic,weak) IBOutlet UIButton *chooseDateBtn;
@property (nonatomic,weak) IBOutlet UIButton *cancelDateBtn;
@property (nonatomic,weak) IBOutlet UIDatePicker *datePicker;
//@property (nonatomic,weak) IBOutlet UIDatePicker *timePicker; 

@property (nonatomic,assign) BOOL isStartTime;

@property (nonatomic,weak) IBOutlet NSLayoutConstraint *pickerConstraint;


@end

@implementation DevHistoryViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self defaultNaviBarShowTitle:NSLocalizedString(@"historyRecord", nil)];
    self.searchBtn.layer.cornerRadius = 6;
    self.searchBtn.layer.borderWidth = 1;
    self.searchBtn.layer.borderColor = [UIColor colorWithRed:225/255. green:225/255. blue:225/255. alpha:1].CGColor;
    self.searchBtn.layer.masksToBounds = YES;
    
    self.pickerConstraint.constant = -380;
    
    //初始化picker
    NSDate* maxDate = [NSDate date];
    
    self.datePicker.maximumDate = maxDate;
    //self.datePicker.datePickerMode = UIDatePickerModeDate;
    //self.timePicker.datePickerMode = UIDatePickerModeTime;
    
    //NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文显示3
    NSLocale *locale = [NSLocale currentLocale];
    //self.timePicker.locale = locale;
    self.datePicker.locale = locale;

    
    
    self.viewModel = [DevHistoryViewModel new];
    self.viewModel.vmHandler = self;
    
     
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    [self.startBtn setTitle:[NSString stringWithFormat:@"%@",[[yesterday string] substringToIndex:16]] forState:UIControlStateNormal];
    [self.endBtn setTitle:[NSString stringWithFormat:@"%@",[[[NSDate date] string] substringToIndex:16]] forState:UIControlStateNormal];
    [self searchClick:self.searchBtn]; // self.searchBtn
}

// 重写 viewWillDisappear
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark 加载数据
// 默认加载数据
- (void)loadData {
    [self.viewModel getDeviceHistory:self.deviceId
                             pageNum:[NSNumber numberWithInteger:self.pageNum]
                            pageSize:[NSNumber numberWithInteger:HistoryPageSize]
                           startTime:self.startBtn.titleLabel.text
                             endTime:self.endBtn.titleLabel.text];
    [UtilityUI endRefreshingAt:self.tableView]; // 结束上拉下拉刷新动作
}
// 加载更多数据
- (void)loadMore{
    self.pageNum ++;
    [self.viewModel getDeviceHistory:self.deviceId
                             pageNum:[NSNumber numberWithInteger:self.pageNum]
                            pageSize:[NSNumber numberWithInteger:HistoryPageSize]
                           startTime:self.startBtn.titleLabel.text
                             endTime:self.endBtn.titleLabel.text];
    [UtilityUI endRefreshingAt:self.tableView]; // 结束上拉下拉刷新动作
}
// 加载最后一组数据
- (void)loadLastData{
    self.pageNum ++;
    [self.viewModel getDeviceHistory:self.deviceId
                             pageNum:[NSNumber numberWithInteger:self.pageNum]
                            pageSize:[NSNumber numberWithInteger:HistoryPageSize]
                           startTime:self.startBtn.titleLabel.text
                             endTime:self.endBtn.titleLabel.text];
    [UtilityUI showNoMoreViewAt:self.tableView];
}

#pragma mark - Action

- (IBAction)startChoose:(id)sender{ /**< push the `start Date` select button */
    self.isStartTime = YES;
    [self.startBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.endBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [self.startBtn setBackgroundColor:[UIColor grayColor]];
//    [self.endBtn setBackgroundColor:[UIColor clearColor]];

    if (self.pickerConstraint.constant != 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.pickerConstraint.constant = 0;
        }];
    }

}

- (IBAction)endChoose:(id)sender{ /**< push the `end Date` select action */
    self.isStartTime = NO;      // flag
    [self.endBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.startBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [self.endBtn setBackgroundColor:[UIColor grayColor]];
//    [self.startBtn setBackgroundColor:[UIColor clearColor]];

    if (self.pickerConstraint.constant != 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.pickerConstraint.constant = 0;
        }];
    }
}

- (IBAction)searchClick:(id)sender{
    if ([self.startBtn.titleLabel.text length] == 8) {
        [self showNoticeText:NSLocalizedString(@"select_start_time", nil)];
        return;
    }else if([self.endBtn.titleLabel.text length] == 8){
        [self showNoticeText:NSLocalizedString(@"select_end_time", nil)];
        return;
    }
    
    NSDate *startDate = [NSDate dateFromString:[NSString stringWithFormat:@"%@:00",self.startBtn.titleLabel.text]];
    NSDate *endDate = [NSDate dateFromString:[NSString stringWithFormat:@"%@:00",self.endBtn.titleLabel.text]];
    NSTimeInterval timeBetween = [startDate timeIntervalSinceDate:endDate];
    
    
    if (timeBetween > 0) {
        [self showNoticeText:NSLocalizedString(@"select_start_end", nil)];
        return;
    }
    [self showLoadingIndicatorInView];
    self.pageNum = 0;
    self.tableView.tableFooterView = nil;
    self.historyArray = [NSMutableArray array];
    [self.tableView reloadData];
    [self.viewModel getDeviceHistory:self.deviceId
                             pageNum:[NSNumber numberWithInteger:self.pageNum]
                            pageSize:[NSNumber numberWithInteger:HistoryPageSize]
                           startTime:self.startBtn.titleLabel.text
                             endTime:self.endBtn.titleLabel.text];
    
}

- (IBAction)cancelChoose:(id)sender{
    if (self.pickerConstraint.constant == 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.pickerConstraint.constant = -380;
        }];
    }
}

- (IBAction)chooseDate:(id)sender{  /**< 按选"OK"选定日期后，更新到指定的按钮Title显示。 */
    NSString *dateString = [self.datePicker.date string];
    NSString *timeString = [self.datePicker.date string];

    NSString *chooseDate = [NSString stringWithFormat:@"%@ %@",[dateString substringToIndex:10],
                            [timeString substringWithRange:NSMakeRange(11, 5)]];
    if (self.isStartTime) {     // 根据当前选择的 start 或 end 时间按钮，更新上去
        [self.startBtn setTitle:chooseDate forState:UIControlStateNormal];
    }else{
        [self.endBtn setTitle:chooseDate forState:UIControlStateNormal];
    }
    
    // 选择完成，隐藏控件
    if (self.pickerConstraint.constant == 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.pickerConstraint.constant = -380;
        }];
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
// 返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.historyArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// 返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DevHistoryCell *cell = (DevHistoryCell *)[tableView dequeueReusableCellWithIdentifier:@"DevHistoryCell"];
    
    if(indexPath.row == 0){ // 第一行显示表头
        cell.tempLabel.textColor = [UIColor blueColor];
        cell.humLabel.textColor = [UIColor blueColor];
        cell.timeLabel.textColor = [UIColor blueColor];
        
        cell.tempLabel.text = [NSString stringWithFormat:@"%@℃",NSLocalizedString(@"temperature", nil)];
        cell.humLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"humidity", nil),@"%"];
//        cell.timeLabel.text = NSLocalizedString(@"time", nil);
        
    }else{                  // 后边的行显示数据
        cell.tempLabel.textColor = [UIColor lightGrayColor];
        cell.humLabel.textColor = [UIColor lightGrayColor];
        cell.timeLabel.textColor = [UIColor lightGrayColor];
    
        NSDictionary *dataDic = self.historyArray[indexPath.row - 1]; // row 0 is the table head
        cell.tempLabel.text = [NSString stringWithFormat:@"%0.1f",[dataDic[@"temp"] floatValue]];
        cell.humLabel.text = [NSString stringWithFormat:@"%0.1f",[dataDic[@"humidity"] floatValue]];
        
        // convert the lastDataTime to string
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:([dataDic[@"lastDataTime"] doubleValue]/1000)];
        NSDateFormatter *localFormat = [[NSDateFormatter alloc] init];
        [localFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
        [localFormat setTimeZone:[NSTimeZone localTimeZone]];
        cell.timeLabel.text = [localFormat stringFromDate:date];
    }
    
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

// 让cell不能点选
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - ViewModel
- (void)showErrorMsg:(NSString *)errorMsg{
    [self hideLoadingIndicatorInView];
    [self showNoticeText:errorMsg];
}

- (void)showHistoryList:(NSArray *)list count:(NSNumber *)count hasNext:(BOOL)hasNext{
    // ?缓存，数据存到字典里。
    // 内存里不应该清掉。但是historyArray 在VC死掉以后（比如回到DeviceView）就也不存在了，那自然data也不见了。
    // 如果保存下来，还有一个问题：下次重新调到的数据怎么拼接？除非像URL一样每条数据有id，否则拼接比较复杂。
    
    // 1. 准备显示数据
    [self hideLoadingIndicatorInView];      // 隐藏HUD
    if (ArrayNotEmpty(self.historyArray)) {
        [UtilityUI endRefreshingAt:self.tableView]; // 结束上拉下拉刷新动作
    }
    
    // 2. 添加数据到historyArray里。
    [self.historyArray addObjectsFromArray:list];  // 这个如果直接添加到最后
    
    // 3. 更新数据
    self.countLabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"search_data", nil),count];
    [self.tableView reloadData];
    
    // 4. 还有没显示的新数据，则可以继续上拉刷新
    if (hasNext) {
        if (self.pageNum == 0) {
            [UtilityUI addFooterRefreshViewAt:self.tableView withRefreshActionBolck:^{
                [self loadMore];
            }];
        }
    }else{ // 没有数据了
        [UtilityUI showNoMoreViewAt:self.tableView];
    }
}


@end
