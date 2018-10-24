//
//  KKChannelView.m
//  KKChannelView
//
//  Created by 凯朱 on 2018/10/23.
//  Copyright © 2018年 凯朱. All rights reserved.
//

#import "KKChannelView.h"
#import "KKChannelLabel.h"
//屏幕的宽高
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
@interface KKChannelView()<UIScrollViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>
{
    KKChannelViewLayout *_layout;
    CGRect _rect;
    NSInteger _currentIndex;
    NSArray *_dataArray;
    
    //label数据源
    NSMutableArray  *_labelArray;
    
    //默认属性
    UIFont *_labelFont;
    UIColor *_topBgColor;
    UIColor *_titleColor;
    UIColor *_titleSelectColor;
    UIColor *_sliderColor;
    UIColor *_lineColor;
    
    CGFloat _topHeight;
    CGSize _sliderSize;
    CGFloat _lineHeight;
    CGFloat _labelWidth;
    CGFloat _labelHeight;
    
    //是否点击了label
    BOOL _isClickLabel;
    BOOL _openScale;
}
/** 顶部scrollView*/
@property (nonatomic, strong)UIScrollView *topScrollView;

/** 滑块*/
@property (nonatomic, strong)UIView *sliderView;

/** 分割线*/
@property (nonatomic, strong)UIView *lineView;

/** 布局*/
@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation KKChannelView
/**
 实例化方法
 
 @param frame - frame
 @param layout - 布局
 @return - 实例
 */
-(instancetype)initWithFrame:(CGRect)frame layout:(KKChannelViewLayout *)layout{
    
    if (self = [super initWithFrame:frame]) {
        [self setDefaultLayoutWith:frame layout:layout];
        [self setUpViewWithLayout];
    }
    return self;
}

/**
 初始化属性
 */
-(void)setDefaultLayoutWith:(CGRect)frame layout:(KKChannelViewLayout *)layout{

    //布局文件
    _layout = layout;
    _dataArray = _layout.dataArray;
    _labelArray = [[NSMutableArray alloc] init];
    _rect = frame;
    _currentIndex = _layout.currentIndex?_layout.currentIndex:0;
    
    _labelFont = _layout.titleFont ? _layout.titleFont : [UIFont systemFontOfSize:15];
    _titleColor = _layout.titleColor ? _layout.titleColor : [UIColor grayColor];
    _titleSelectColor = _layout.titleSelectColor ? _layout.titleSelectColor:[UIColor blackColor];
    _labelWidth = _layout.labelWidth > 0 ? _layout.labelWidth : 80;
    _labelHeight = _layout.labelHeight > 0 ? _layout.labelHeight : 50 ;
    
    _topHeight = _layout.labelHeight > 0 ? _layout.labelHeight : 50;
    _topBgColor = _layout.bgColor ? _layout.bgColor : [UIColor whiteColor];
    
    _sliderSize = _layout.sliderSize;
    CGFloat height = _sliderSize.height > 0 ? _sliderSize.height : 3;
    CGFloat width = _sliderSize.width > 0 ? _sliderSize.width : 50;
    _sliderSize = CGSizeMake(width, height);
    if (_layout.hideSlider) {
       _sliderSize = CGSizeMake(0, 0);
    }
    _sliderColor = _layout.sliderColor ? _layout.sliderColor : [UIColor blackColor];
    
    _lineHeight = _layout.lineHeight > 0 ? _layout.lineHeight : 0.5 ;
    _lineColor = _layout.lineColor ? _layout.lineColor : [UIColor lightGrayColor];
    if (_layout.hideLine) {
        _lineHeight = 0;
    }
    //过滤掉标题为空的label
    __block NSMutableArray *tureData = [[NSMutableArray alloc] init];
    [_dataArray enumerateObjectsUsingBlock:^(KKChannelViewModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (model.title.length > 0) {
            [tureData addObject:model];
        }
    }];
    _dataArray = tureData;
    
    self.backgroundColor = [UIColor whiteColor];
}

/**
 布局
 */
-(void)setUpViewWithLayout{
    
    if (_dataArray.count == 0) return;
    
    [self addSubview:self.topScrollView];
    [self addSubview:self.collectionView];
    [self addSubview:self.lineView];
    
    //布局按钮
    CGFloat labelX = 0;
    CGFloat labelY = 0;
    
    for (int i = 0; i < _dataArray.count; i ++) {
        //实例化label
        KKChannelLabel *label = [[KKChannelLabel alloc] initWithFrame:CGRectMake(labelX + i * _labelWidth, labelY, _labelWidth, _labelHeight)];
        label.fillColor = _titleSelectColor;
        label.textColor = _titleColor;
        label.font = _labelFont;
        KKChannelViewModel *model = _dataArray[i];
        label.text = model.title;
        //添加点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickLabelAction:)];
        [label addGestureRecognizer:tap];
        label.userInteractionEnabled = YES;
        label.tag = i;
        
        //默认项
        if (_currentIndex == i) {
            label.textColor = _titleSelectColor;
            _currentIndex = i;
            label.scale = _layout.scale;
        }
        
        [_labelArray addObject:label];
        [_topScrollView addSubview:label];
    }
    [_topScrollView addSubview:self.sliderView];
    _topScrollView.contentSize = CGSizeMake(_labelArray.count * _labelWidth, 0);
}

#pragma mark - ================<UICollectionViewDataSource,UICollectionViewDelegate>===============
//每个item的size
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath{
    //宽度为屏幕宽度
    CGFloat y = _topHeight +_sliderSize.height +_lineHeight;
    return CGSizeMake(ScreenWidth, _rect.size.height-y);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKChannelViewCollectionView:cellForItemAtIndexPath:)]) {
       return [self.delegate KKChannelViewCollectionView:collectionView cellForItemAtIndexPath:indexPath];
    }else{
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
         return cell;
    }
}

/**
 点击事件
 */
-(void)clickLabelAction:(UITapGestureRecognizer *)tap{
    
    NSInteger index = tap.view.tag;
    //重复点击
    if (index != _currentIndex) {
        KKChannelLabel *currentLabel = _labelArray[_currentIndex];
        currentLabel.scale = 0;
        currentLabel.textColor = _titleColor;
    }
    
    //区分点击还是滑动collectionView的回调
    _isClickLabel = YES;
    
    //collectionView滚动到对应界面
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:0 animated:NO];
    _currentIndex = index;
    CGFloat offsetX = _collectionView.contentOffset.x;
    CGFloat newX = offsetX/(_collectionView.bounds.size.width/_labelWidth)+(_labelWidth-_sliderSize.width)/2;
    CGRect newRect = CGRectMake(newX, _sliderView.frame.origin.y, _sliderView.frame.size.width, _sliderView.frame.size.height);
    if (_isClickLabel) {
        [UIView animateWithDuration:0.25 animations:^{
            self->_sliderView.frame = newRect;
        }completion:^(BOOL finished) {
            self->_isClickLabel = NO;
            //矫正label位置
            [self scrollLabelToCenter];
        }];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKChannelViewClickTitleAction:model:)]) {
        [self.delegate KKChannelViewClickTitleAction:_currentIndex model:_dataArray[_currentIndex]];
    }
}

#pragma mark - ================<scrolleView滑动代理>===============

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _topScrollView) {
        return;
    }
    
    //获取当前label的索引
    _currentIndex = scrollView.contentOffset.x / _collectionView.bounds.size.width;
    [self scrollLabelToCenter];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKChannelViewCollectionViewDidEndScrollAction:model:)]) {
        [self.delegate KKChannelViewCollectionViewDidEndScrollAction:_currentIndex model:_dataArray[_currentIndex]];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _topScrollView) return;
        
    //获取偏移量
    CGFloat offsetX = _collectionView.contentOffset.x;
    NSInteger itemCount = offsetX / _collectionView.bounds.size.width;
    //当前频道在屏幕的位置
    CGFloat rightPageLeftDelta = offsetX - itemCount * ScreenWidth;
    CGFloat progress = rightPageLeftDelta / ScreenWidth;
    
    CGFloat rightScale = offsetX / _collectionView.bounds.size.width - itemCount;
    CGFloat leftScale = 1 - rightScale;
    if (_layout.scale < 1) {
        rightScale = 0;
        leftScale = 0;
    }
    
    //左侧的label
    KKChannelLabel *leftLabel = _labelArray[itemCount];
    leftLabel.scale = leftScale;
    leftLabel.textColor = _titleSelectColor;
    leftLabel.fillColor = _titleColor;
    leftLabel.progress = progress;
    
    //滑块的位置
    CGFloat newX = offsetX/(_collectionView.bounds.size.width/_labelWidth)+(_labelWidth-_sliderSize.width)/2;
    CGRect newRect = CGRectMake(newX, _sliderView.frame.origin.y, _sliderView.frame.size.width, _sliderView.frame.size.height);
    if (!_isClickLabel) {
        _sliderView.frame = newRect;
    }
    
    if (itemCount == _labelArray.count - 1) return;
        
    //右侧的label
    KKChannelLabel *rightLabel = _labelArray[itemCount + 1];
    rightLabel.scale = rightScale;
    rightLabel.textColor = _titleColor;
    rightLabel.fillColor = _titleSelectColor;
    rightLabel.progress = progress;
    
    //重新赋值
    _currentIndex = itemCount;
}

/**
 矫正label位置
 */
- (void)scrollLabelToCenter{
    //获取当前的label
    KKChannelLabel *currentLabel = _labelArray[_currentIndex];
    //获取label的中心点x
    CGFloat currentLabelCenterX = currentLabel.center.x;
    
    CGFloat offsetX = currentLabelCenterX - _collectionView.bounds.size.width / 2;
    //如果点击label在屏幕中心点的左侧,移动到最左边
    offsetX = offsetX <= 0 ? 0 : offsetX;
    
    //当点击的label中心点的x在屏幕中心点的右侧，移动到最右边
    CGFloat maxOffset = _topScrollView.contentSize.width - _topScrollView.bounds.size.width;
    offsetX = offsetX > maxOffset ? maxOffset : offsetX;
    
    //使label所在的scrollView移动
    [_topScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

#pragma mark - ================<lazy init>===============
-(UIScrollView *)topScrollView{
    if (!_topScrollView) {
        _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _rect.size.width, _topHeight+_sliderSize.height+_lineHeight)];
        _topScrollView.delegate = self;
        _topScrollView.backgroundColor = _topBgColor;
        _topScrollView.showsVerticalScrollIndicator = NO;
        _topScrollView.showsHorizontalScrollIndicator = NO;
        [_topScrollView addSubview:self.sliderView];
    }
    return _topScrollView;
}

-(UIView *)sliderView{
    if (!_sliderView && !_layout.hideSlider) {
        CGFloat newX = (_labelWidth-_sliderSize.width)/2;
        _sliderView = [[UIView alloc] initWithFrame:CGRectMake(newX, _topHeight, _sliderSize.width,_sliderSize.height)];
        _sliderView.backgroundColor = _sliderColor;
    }
    return _sliderView;
}

-(UICollectionView *)collectionView{
    if (_collectionView  == nil) {
        CGFloat y = _topHeight +_sliderSize.height +_lineHeight;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,y, _rect.size.width, _rect.size.height - y) collectionViewLayout:self.flowLayout];
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

-(UIView *)lineView{
    if (!_lineView && !_layout.hideLine) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _topHeight+_sliderSize.height, _rect.size.width, _lineHeight)];
        _lineView.backgroundColor = _lineColor;
    }
    return _lineView;
}

- (UICollectionViewFlowLayout *)flowLayout{
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [_flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    }
    return _flowLayout;
}

@end
