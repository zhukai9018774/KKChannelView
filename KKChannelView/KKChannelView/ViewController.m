//
//  ViewController.m
//  KKChannelView
//
//  Created by 凯朱 on 2018/10/24.
//  Copyright © 2018年 凯朱. All rights reserved.
//
#import "ViewController.h"
#import "KKChannelView.h"
#import "KKTestCell.h"

@interface ViewController ()<KKChannelViewDelegate>
{
    NSMutableArray *_dataArray;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupKKChannelView];
    
}

-(void)setupKKChannelView{
    CGFloat ScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat ScreenHeight = [UIScreen mainScreen].bounds.size.height;
    
    KKChannelViewLayout *layout = [[KKChannelViewLayout alloc] init];
    _dataArray = [[NSMutableArray alloc] init];
    NSArray *titleArray = @[@"关注",@"推荐",@"科学",@"NBA",@"探索兴趣",@"自定义",@"娱乐",@"深圳",@"新时代",@"历史"];
    __block NSArray *valueArray = @[@"关注Value",@"推荐Value",@"科学Value",@"NBAValue",@"探索兴趣Value",@"自定义Value",@"娱乐Value",@"深圳Value",@"新时代Value",@"历史Value"];
    [titleArray enumerateObjectsUsingBlock:^(NSString *titleStr, NSUInteger idx, BOOL * _Nonnull stop) {
        
        KKChannelViewModel *model = [[KKChannelViewModel alloc] init];
        model.title = titleStr;
        model.value = valueArray[idx];
        [self->_dataArray addObject:model];
    }];
    
    //    layout.hideSlider = YES;
    //    layout.hideLine = YES;
        layout.titleColor = [UIColor blackColor];
        layout.titleSelectColor = [UIColor redColor];
    //    layout.labelHeight = 80;
    //    layout.labelWidth = 100;
    //    layout.titleFont = [UIFont systemFontOfSize:20];
        layout.scale = 1.2;
    layout.dataArray = _dataArray;
    KKChannelView *channelView = [[KKChannelView alloc] initWithFrame:CGRectMake(0, 20,ScreenWidth, ScreenHeight-20) layout:layout];
    channelView.delegate = self;
    [channelView.collectionView registerClass:[KKTestCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:channelView];
    
}

-(UICollectionViewCell *)KKChannelViewCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KKTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    KKChannelViewModel *model = _dataArray[indexPath.row];
    cell.titleStr = model.title;
    return cell;
}

-(void)KKChannelViewClickTitleAction:(NSInteger)index model:(KKChannelViewModel *)model{
    NSLog(@"点击了index = %ld,value = %@",index,model.value);
}

- (void)KKChannelViewCollectionViewDidEndScrollAction:(NSInteger)index model:(KKChannelViewModel *)model{
    NSLog(@"滑动到了index = %ld,value = %@",index,model.value);
}

@end
