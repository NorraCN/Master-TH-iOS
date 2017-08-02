//
//  SVTopScrollView.h
//  SlideView
//
//  Created by Chen Yaoqiang on 13-12-27.
//  Copyright (c) 2013年 Chen Yaoqiang. All rights reserved.
//
//  Kangqiao Modified: 20160809
//  fix the typing error of misleading meanning. remove useless stuff.
//  注释一下


#import <UIKit/UIKit.h>

@interface SVTopScrollView : UIScrollView <UIScrollViewDelegate>
{
    NSArray *nameArray;                     /**< 标签按钮名称数组 */
    NSInteger userSelectedChannelID;        /**< 选中的标签按钮ID */
    NSInteger scrollViewSelectedChannelID;  /**< 选中的滑动列表ID */
    
    UIImageView *shadowImageView;           /**< 阴影图片 */
}
@property (nonatomic, strong) NSArray *nameArray;

@property(nonatomic,strong)NSMutableArray *buttonOriginXArray;  /**< 标签按钮原点x坐标数组 */
@property(nonatomic,strong)NSMutableArray *buttonWidthArray;    /**< 标签按钮宽度数组 */

@property (nonatomic, assign) NSInteger scrollViewSelectedChannelID;

+ (SVTopScrollView *)shareInstance;
/**
 *  加载顶部标签
 */
- (void)initWithNameButtons;
/**
 *  滑动撤销选中按钮
 */
- (void)setButtonUnSelect;
/**
 *  设定选择按钮
 */
- (void)setButtonSelect;

- (void)setScrollViewContentOffset;  /**< set ScrollView content offset without Button  */


@end
