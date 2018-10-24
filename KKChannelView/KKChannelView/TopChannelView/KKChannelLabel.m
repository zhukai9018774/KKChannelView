//
//  KKChannelLabel.m
//  KKChannelView
//
//  Created by 凯朱 on 2018/10/23.
//  Copyright © 2018年 凯朱. All rights reserved.
//

#import "KKChannelLabel.h"

@implementation KKChannelLabel

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:15];
    }
    return self;
}

- (void)setScale:(CGFloat)scale{
    _scale = scale;
    CGFloat realScale = 1 + scale / 5;
    self.transform = CGAffineTransformMakeScale(realScale, realScale);
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [_fillColor set];
    CGRect newRect = rect;
    newRect.size.width = rect.size.width * self.progress;
    
    //在控制器中左侧的label文本颜色是蓝色,填充色是黑色,右侧文本颜色是蓝色,填充色是黑色
    //向当前绘图环境所创建的内存中的图片上填充一个矩形，绘制使用指定的混合模式。
    UIRectFillUsingBlendMode(newRect, kCGBlendModeSourceIn);
}

@end
