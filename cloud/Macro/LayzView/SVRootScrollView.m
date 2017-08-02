//
//  SVRootScrollView.m
//  SlideView
//
//  Created by Chen Yaoqiang on 13-12-27.
//  Copyright (c) 2013年 Chen Yaoqiang. All rights reserved.
//

#import "SVRootScrollView.h"

#import "SVGloble.h"
#import "SVTopScrollView.h"

#define POSITIONID (int)(scrollView.contentOffset.x/ScreenWidth)

@implementation SVRootScrollView

@synthesize viewNameArray;

+ (SVRootScrollView *)shareInstance {
    static SVRootScrollView *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance=[[self alloc] initWithFrame:CGRectMake(0, 44+IOS7_STATUS_BAR_HEGHT, ScreenWidth, [SVGloble shareInstance].globleHeight-44)];
    });
    return _instance;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.backgroundColor = [UIColor lightGrayColor];
        self.pagingEnabled = YES;
        self.userInteractionEnabled = YES;
        self.bounces = NO;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        userContentOffsetX = 0;
    }
    return self;
}

- (void)initWithViews
{
    userContentOffsetX = 0;
    [self setContentOffset:CGPointMake(0,0)  animated:NO];

    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    for (int i = 0; i < [viewNameArray count]; i++) {
        UIView *view = [viewNameArray objectAtIndex:i];
        [view setFrame:CGRectMake(0+ScreenWidth*i, 0, ScreenWidth, [SVGloble shareInstance].globleHeight-44-64)];
        [self addSubview:view];
    }
    self.contentSize = CGSizeMake(ScreenWidth*[viewNameArray count], [SVGloble shareInstance].globleHeight-44);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    userContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (userContentOffsetX < scrollView.contentOffset.x) {
        isLeftScroll = YES;
    }
    else {
        isLeftScroll = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //调整顶部滑条按钮状态
    [self adjustTopScrollViewButton:scrollView];
    
    [self loadData];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self loadData];
}

-(void)loadData
{
//    CGFloat pagewidth = self.frame.size.width;
//    int page = floor((self.contentOffset.x - pagewidth/viewNameArray.count)/pagewidth)+1;
//    UIView *view = (UIView *)[self viewWithTag:page+200];
//    UILabel *label = (UILabel *)[self viewWithTag:page+200];
//    label.text = [NSString stringWithFormat:@"%@",[viewNameArray objectAtIndex:page]];
}

//滚动后修改顶部滚动条
- (void)adjustTopScrollViewButton:(UIScrollView *)scrollView
{
    [[SVTopScrollView shareInstance] setButtonUnSelect];
    [SVTopScrollView shareInstance].scrollViewSelectedChannelID = POSITIONID+100;
    [[SVTopScrollView shareInstance] setButtonSelect];
    [[SVTopScrollView shareInstance] setScrollViewContentOffset];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
