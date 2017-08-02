//
//  AboutViewController.m
//  cloud
//
//  Created by 崔远寿 on 16/3/7.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *contentLabel;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defaultNaviBarShowTitle:NSLocalizedString(@"about", nil)];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"app_name", nil)];
    [self.nameLabel setFont:[UIFont systemFontOfSize:25 weight:2]];
    self.nameLabel.textColor = [UIColor grayColor];
    self.contentLabel.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"about_content", nil)];
    self.contentLabel.textColor = [UIColor grayColor];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
