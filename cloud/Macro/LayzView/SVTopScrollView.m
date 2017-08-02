//
//  SVTopScrollView.m
//  SlideView
//
//  Created by Chen Yaoqiang on 13-12-27.
//  Copyright (c) 2013年 Chen Yaoqiang. All rights reserved.
//
//  Kangqiao Modified: 20160809
//  fix the typing error of misleading meanning. remove useless stuff.

#import "SVTopScrollView.h"
#import "SVGloble.h"
#import "SVRootScrollView.h"


//按钮空隙
#define BUTTONGAP 5
//滑条宽度
//#define CONTENTSIZEX 320
#define CONTENTSIZEX ScreenWidth
//按钮id
#define BUTTONID (sender.tag-100)
//滑动id
#define BUTTONSELECTEDID (scrollViewSelectedChannelID - 100)


@implementation SVTopScrollView

@synthesize nameArray;
@synthesize scrollViewSelectedChannelID;

+ (SVTopScrollView *)shareInstance {
    static SVTopScrollView *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance=[[self alloc] initWithFrame:CGRectMake(0, IOS7_STATUS_BAR_HEGHT, CONTENTSIZEX, 44)];
    });
    return _instance;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
        self.pagingEnabled = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        userSelectedChannelID = 100;
        scrollViewSelectedChannelID = 100;
        
        self.buttonOriginXArray = [NSMutableArray array];
        self.buttonWidthArray = [NSMutableArray array];
    }
    return self;
}

- (void)initWithNameButtons
{
    // init contentOffset and view
    [self setContentOffset:CGPointMake(0,0)  animated:NO];
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    float xPos = BUTTONGAP;   // put a gap leading the left of first button
    for (int i = 0; i < [self.nameArray count]; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *title = [self.nameArray objectAtIndex:i];
        
        [button setTag:i+100];
        if (i == 0) {
            button.selected = YES;
        }
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:20.0];
        [button setTitleColor:[SVGloble colorFromHexRGB:@"868686"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(selectNameButton:) forControlEvents:UIControlEventTouchUpInside];
        
        float buttonWidth = [title sizeWithFont:button.titleLabel.font
                            constrainedToSize:CGSizeMake(150, 30)   // width 150, height 30
                                lineBreakMode:NSLineBreakByClipping].width;
        // recalculate the button width...
        if ([self.nameArray count] < 5) {   // for case of less than 5 buttons.
            buttonWidth = (CONTENTSIZEX-BUTTONGAP*([self.nameArray count]+1)) / [self.nameArray count];
        }
        button.frame = CGRectMake(xPos, 0, buttonWidth, 30);
//        button.frame = CGRectMake(xPos, 0, buttonWidth+BUTTONGAP, 30);
//        [button setBackgroundColor:[UIColor redColor]];     // debug
        
        [_buttonOriginXArray addObject:@(xPos)];    // 多组的话，xPos可能好几屏。。
        
        xPos += buttonWidth+BUTTONGAP;
        
        [_buttonWidthArray addObject:@(button.frame.size.width)];
        
        [self addSubview:button];
    }
    
    self.contentSize = CGSizeMake(xPos, 44);
    
    shadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(BUTTONGAP, 0, [[_buttonWidthArray objectAtIndex:0] floatValue], 44)];
    [shadowImageView setImage:[UIImage imageNamed:@"red_line_and_shadow.png"]];
    [self addSubview:shadowImageView];
}

//点击顶部条滚动标签
- (void)selectNameButton:(UIButton *)sender
{
    [self adjustScrollViewContentX:sender];
    
    //如果更换按钮
    if (sender.tag != userSelectedChannelID) {
        //取之前的按钮
        UIButton *lastButton = (UIButton *)[self viewWithTag:userSelectedChannelID];
        lastButton.selected = NO;
        //赋值按钮ID
        userSelectedChannelID = sender.tag;
    }
    
    //按钮选中状态
    if (!sender.selected) {
        sender.selected = YES;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            [shadowImageView setFrame:CGRectMake(sender.frame.origin.x, 0, [[_buttonWidthArray objectAtIndex:BUTTONID] floatValue], 44)];
            
        } completion:^(BOOL finished) {
            if (finished) {
                //设置Detail页出现，从边上滚动进来。滚动
                [[SVRootScrollView shareInstance] setContentOffset:CGPointMake(BUTTONID*CONTENTSIZEX, 0) animated:YES];
//                [[SVRootScrollView shareInstance] setContentOffset:CGPointMake(BUTTONID*320, 0) animated:YES];
                //赋值滑动列表选择频道ID
                scrollViewSelectedChannelID = sender.tag;
            }
        }];
        
    }
    //重复点击选中按钮
    else {
        
    }
}


//滚动内容页顶部滚动
- (void)setButtonUnSelect
{
    //滑动撤销选中按钮
    UIButton *lastButton = (UIButton *)[self viewWithTag:scrollViewSelectedChannelID];
    lastButton.selected = NO;
}

- (void)setButtonSelect
{
    //滑动选中按钮
    UIButton *button = (UIButton *)[self viewWithTag:scrollViewSelectedChannelID];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [shadowImageView setFrame:CGRectMake(button.frame.origin.x, 0, [[_buttonWidthArray objectAtIndex:button.tag-100] floatValue], 44)];
        
    } completion:^(BOOL finished) {
        if (finished) {
            if (!button.selected) {
                button.selected = YES;
                userSelectedChannelID = button.tag;
            }
        }
    }];
    
}


/**
 *   *  public method
 */
- (void) setScrollViewContentOffset {
    [self setScrollViewContentOffsetForIndex:BUTTONSELECTEDID];
}

- (void) adjustScrollViewContentX:(UIButton *)sender {
    [self setScrollViewContentOffsetForIndex:BUTTONID];
}

/**
 *  @author Kangqiao, 16-08-09 17:08:36
 *
 *  private function
 *
 *  @param index index either for button or for scrolled page
 */
-(void)setScrollViewContentOffsetForIndex:(NSInteger) index
{
    int margin = (index==self.buttonOriginXArray.count-1 | index==0) ? BUTTONGAP:30;
    float originX = [[_buttonOriginXArray objectAtIndex:index] floatValue];
    float width = [[_buttonWidthArray objectAtIndex:index] floatValue];
    // 解耦不太好，contentOffset必须在此前先设好。
    if (originX - self.contentOffset.x > CONTENTSIZEX-(BUTTONGAP+width)) {
        [self setContentOffset:CGPointMake(originX - (CONTENTSIZEX-(BUTTONGAP+width)-margin), 0)  animated:YES];
    }
    if (originX - self.contentOffset.x < 5) {
        [self setContentOffset:CGPointMake(originX - margin, 0)  animated:YES];
    }
}

//- (void)setNameArray:(NSArray *)array{
//    _nameArray = array;
//}
//
//- (NSArray *)getNameArray{
//    return _nameArray;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
