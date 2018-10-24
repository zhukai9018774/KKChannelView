//
//  KKChannelViewLayout.h
//  KKChannelView
//
//  Created by 凯朱 on 2018/10/23.
//  Copyright © 2018年 凯朱. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class KKChannelViewModel;
@interface KKChannelViewLayout : NSObject

/** 数据源*/
@property(nonatomic,strong)NSArray <KKChannelViewModel *> *dataArray;

/** 背景色 - 默认白色*/
@property(nonatomic,strong)UIColor *bgColor;

/** 文字颜色 - 默认灰色*/
@property(nonatomic,strong)UIColor *titleColor;

/** 文字选中状态颜色 - 默认黑色*/
@property(nonatomic,strong)UIColor *titleSelectColor;

/** 文字大小 - 默认15*/
@property(nonatomic,strong)UIFont *titleFont;

/** 当前选中值 - 默认0*/
@property(nonatomic,assign)NSInteger currentIndex;

/** label宽度 - 默认80*/
@property(nonatomic,assign)CGFloat labelWidth;

/** label高度 - 默认50*/
@property(nonatomic,assign)CGFloat labelHeight;

/** 分割线高度 - 默认0.5*/
@property(nonatomic,assign)CGFloat lineHeight;

/** 分割线高度 - 默认0.5*/
@property(nonatomic,strong)UIColor *lineColor;

/** 是否隐藏分割线 - 默认NO*/
@property(nonatomic,assign)BOOL hideLine;

/** 是否隐藏滑块 - 默认NO*/
@property(nonatomic,assign)BOOL hideSlider;

/** 滑块颜色 - 默认黑色*/
@property(nonatomic,strong)UIColor *sliderColor;

/** 滑块大小 - 默认（50*3）*/
@property(nonatomic,assign)CGSize sliderSize;

/** 选中状态的缩放比 默认1*/
@property(nonatomic,assign)CGFloat scale;

@end

@interface KKChannelViewModel  : NSObject
/** 标题 - 未设置不生效 */
@property(nonatomic,strong)NSString *title;

/** 携带值 */
@property(nonatomic,strong)id value;

@end
