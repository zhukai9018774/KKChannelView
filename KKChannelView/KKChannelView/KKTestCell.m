//
//  KKTestCell.m
//  ZKTopScrollView
//
//  Created by 凯朱 on 2018/10/24.
//  Copyright © 2018年 凯朱. All rights reserved.
//

#import "KKTestCell.h"

@interface KKTestCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak) UITableView *tableView;
@end

@implementation KKTestCell
-(UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        [self.contentView addSubview:tableView];
        tableView.delegate = self;
        tableView.dataSource = self;
        _tableView = tableView;
        tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ -------------------------------- %ld",_titleStr,indexPath.row];
    return cell;
}

-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    [_tableView reloadData];
}


@end
