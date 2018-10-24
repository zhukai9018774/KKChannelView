//
//  KKChannelLabel.h
//  KKChannelView
//
//  Created by 凯朱 on 2018/10/23.
//  Copyright © 2018年 凯朱. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKChannelLabel : UILabel
@property (nonatomic,assign) CGFloat scale;  //缩放比

@property (nonatomic,strong) UIColor *fillColor;//填充色

@property (nonatomic,assign) CGFloat progress;//进度
@end
