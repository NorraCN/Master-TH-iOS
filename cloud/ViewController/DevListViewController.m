//
//  DevListViewController.m
//  cloud
//
//  Created by 崔远寿 on 16/1/6.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import "DevListViewController.h"
#import "DevDetailsViewController.h"
#import "DataListModel.h"
#import "UtilityUI+Refresh.h"

@interface DevListCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *headLabel;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *detailLabel;
@property (nonatomic,weak) IBOutlet UILabel *timeLabel;


- (void)showDetail:(DataListModel *)model;

@end

@implementation DevListCell

- (void)showDetail:(DataListModel *)model{
//    NSString *details = devicesDic[@"details"];
    NSString *nameString = @"";
    if (model.name) {
        nameString = model.name;
    }
    
    if (!StringNotEmpty(nameString)) {
        nameString = [NSString stringWithFormat:@"%@",model.identifier] ;
    }
    self.nameLabel.text = nameString;
    self.headLabel.text = [nameString substringToIndex:1];

    float temp = [model.temp floatValue];
    float hum = [model.humidity floatValue];
    
    self.detailLabel.text = [NSString stringWithFormat:@"%@:%.1f%@ %@:%.1f%@",NSLocalizedString(@"temperatureListShow", nil),temp,@"℃",NSLocalizedString(@"humidityListShow", nil),hum,@"%"];
    
    if (model.maxHum && (model.humidity.floatValue > model.maxHum.floatValue)) {
        [self.detailLabel setTextColor:[UIColor redColor]];
    }else if(model.maxTemp && (model.temp.floatValue > model.maxTemp.floatValue)){
        [self.detailLabel setTextColor:[UIColor redColor]];
    }else if(model.minHum && (model.humidity.floatValue < model.minHum.floatValue)){
        [self.detailLabel setTextColor:[UIColor redColor]];
    }else if(model.minTemp && (model.temp.floatValue < model.minTemp.floatValue)){
        [self.detailLabel setTextColor:[UIColor redColor]];
    }else{
        [self.detailLabel setTextColor:[UIColor lightGrayColor]];
    }
    self.timeLabel.text = model.localTime;
//    if (StringNotEmpty(details)) {
//        self.detailLabel.text = details;
//    }else{
//        self.detailLabel.text = @"";
//    }
}


@end

@interface DevListViewController ()

<
    UITableViewDataSource,
    UITableViewDelegate
>

@property (nonatomic,weak) IBOutlet UITableView *tableView;


@end

@implementation DevListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [UtilityUI addHeaderRefreshViewAt:self.tableView withRefreshActionBolck:^{
//        [self reloadData];
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData{
    [self.delegate reloadData];
}


#pragma mark - UITableViewDataSource & UITableViewDelegate
// 返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.devList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// 返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DevListCell *cell = (DevListCell *)[tableView dequeueReusableCellWithIdentifier:@"DevListCell"];
    [cell showDetail:self.devList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

// 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    DataListModel *model = self.devList[indexPath.row];
    if (model.deviceId) {
        DevDetailsViewController *detailsVC = InstantiateVCFromStoryboard(@"Main", @"DevDetailsViewController");
        NSString *nameString = model.name;

        if (!StringNotEmpty(nameString)) {
            nameString = [NSString stringWithFormat:@"%@",model.identifier] ;
        }
        detailsVC.name = nameString;
        detailsVC.deviceId = model.deviceId;
        [self.navigationController pushViewController:detailsVC animated:YES];
    }else{
        [UtilityUI showNoticeText:NSLocalizedString(@"no_data", nil)];
    }
}

@end
