//
//  KKChannelView.h
//  KKChannelView
//
//  Created by 凯朱 on 2018/10/23.
//  Copyright © 2018年 凯朱. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKChannelViewLayout.h"
/**
 KKChannelViewDelegate
 */
@protocol KKChannelViewDelegate <NSObject>

/**
 点击了某个标题

 @param index 索引
 @param model 携带的模型
 */
@optional
-(void)KKChannelViewClickTitleAction:(NSInteger)index model:(KKChannelViewModel *)model;

/**
 collectView滑动结束
 
 @param index 索引
 @param model 携带的模型
 */
@optional
-(void)KKChannelViewCollectionViewDidEndScrollAction:(NSInteger)index model:(KKChannelViewModel *)model;

/**
 collectionView代理

 @param collectionView - collectionView
 @param indexPath - indexPath
 @return cell - cell
 */
@optional
-(UICollectionViewCell *)KKChannelViewCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface KKChannelView : UIView

-(instancetype)initWithFrame:(CGRect)frame layout:(KKChannelViewLayout *)layout;

@property(nonatomic, weak) id<KKChannelViewDelegate> delegate;

/** 主界面*/
@property (nonatomic, strong)UICollectionView *collectionView;

@end
