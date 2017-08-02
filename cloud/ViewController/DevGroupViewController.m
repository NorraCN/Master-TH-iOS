//
//  DevGroupViewController.m
//  cloud
//
//  Created by 崔远寿 on 16/1/6.
//  Copyright © 2016年 kelly-cui. All rights reserved.
//

#import "DevGroupViewController.h"
#import "DevListViewController.h"
#import "DevGroupViewModel.h"
#import <Masonry.h>
#import "AboutViewController.h"
#import "SVTopScrollView.h"
#import "SVRootScrollView.h"

@interface DevGroupViewController ()
<
    DevGroupVMInterface,
    UIActionSheetDelegate,
    RefreshDelegate
>

@property (nonatomic,weak) IBOutlet UIView *pageView;

//@property (nonatomic,strong) LazyPageScrollView *pageScrollView;
@property (nonatomic,strong) NSMutableArray *devListViewControllers;
@property (nonatomic,strong) DevGroupViewModel *viewModel;
@property (nonatomic,strong) UIButton *rightBtn;

@property (nonatomic,weak) IBOutlet UIScrollView *scrollView;

@end

@implementation DevGroupViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self defaultNaviBarShowTitle:NSLocalizedString(@"my_device", nil)];
    
//    [self defaultNaviBarShowTitle:AppConfigInstance.jpushToken];
    [self showLoadingIndicatorInView];
    self.devListViewControllers = [NSMutableArray array];
    self.viewModel = [DevGroupViewModel new];
    self.viewModel.vmHandler = self;
    [self.viewModel getDeviceList];
    [self addNavBtn];
    

}

- (void)reloadData{
    [self.viewModel getDeviceList];

}

- (void)setupBase{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:self.rightBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addNavBtn{
//    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Show" style:UIBarButtonItemStylePlain target:self action:@selector(refreshPropertyList:)];
//    self.navigationItem.rightBarButtonItem = anotherButton;
//    [anotherButton release];
    
    
    self.rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 50, 20, 50, 40)];
    [self.rightBtn setImage:[UIImage imageNamed:@"icon_mother_class_search_menu"] forState:UIControlStateNormal];
//    [self.rightBtn setBackgroundColor:[UIColor redColor]];
    [self.rightBtn setImageEdgeInsets: UIEdgeInsetsMake(2, 5, 2, 5)];
    
    [self.rightBtn addTarget:self action:@selector(clickNavBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.rightBtn];
}

- (void)clickNavBtn:(UIButton *)btn{
//    UIActionSheet *actionSheet = [[UIActionSheet alloc]
//                                  initWithTitle:NSLocalizedString(@"menu", nil)
//                                  delegate:self
//                                  cancelButtonTitle:NSLocalizedString(@"cancel", nil)
//                                  destructiveButtonTitle:NSLocalizedString(@"login_out", nil)
//                                  otherButtonTitles:NSLocalizedString(@"refresh", nil),NSLocalizedString(@"about", nil),nil];
//    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
//    [actionSheet showInView:self.view];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                  destructiveButtonTitle:NSLocalizedString(@"login_out", nil)
                                  otherButtonTitles:NSLocalizedString(@"refresh", nil),NSLocalizedString(@"about", nil),nil];
//    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
//    [actionSheet showFromBarButtonItem: ??? animated:YES];
    [actionSheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //登出
        [self showLoadingIndicatorInView];
        [self.viewModel loginOut];
        [self.view bringSubviewToFront:self.rightBtn];

    }else if (buttonIndex == 1) {
        //刷新
        [self showLoadingIndicatorInView];
        [self.viewModel getDeviceList];
        [self.view bringSubviewToFront:self.rightBtn];
    }else if (buttonIndex == 2){
        AboutViewController *about = InstantiateVCFromStoryboard(@"Main", @"AboutViewController");
        [self.navigationController pushViewController:about animated:YES];
    }else{
    
    }
}


#pragma mark - For View Model
- (void)refreshUIFromVM:(NSArray *)list{
    for (UIViewController *vc in self.devListViewControllers) {
        [vc removeFromParentViewController];
    }
    SVTopScrollView *topScrollView = [SVTopScrollView shareInstance];
    SVRootScrollView *rootScrollView = [SVRootScrollView shareInstance];
    [topScrollView removeFromSuperview];
    [rootScrollView removeFromSuperview];
    
    NSMutableArray *nameArray = [NSMutableArray array];
    NSMutableArray *viewsArray = [NSMutableArray array];
    for (NSDictionary *devDic in list) {
        DevListViewController *devList = InstantiateVCFromStoryboard(@"Main", @"DevListViewController");
        devList.delegate = self;
        devList.devList = devDic[@"devices"];
        [viewsArray addObject:devList.view];
        [nameArray addObject:devDic[@"name"]];
        [self addChildViewController:devList];
        [self.devListViewControllers addObject:devList];
    }
    
    
    topScrollView.nameArray = nameArray;
    rootScrollView.viewNameArray = viewsArray;
    
    [self.pageView addSubview:topScrollView];
    [self.pageView addSubview:rootScrollView];
    
    [topScrollView initWithNameButtons];
    [rootScrollView initWithViews];
    

}

#pragma mark --ViewModel
- (void)showErrorMsg:(NSString *)errorMsg{
    [self hideLoadingIndicatorInView];
    [self showNoticeText:errorMsg];

}

- (void)showGroupList:(NSArray *)list{
    [self hideLoadingIndicatorInView];
    [self showNoticeText:NSLocalizedString(@"refresh_suc", nil)];
    [self refreshUIFromVM:list];
}

@end
