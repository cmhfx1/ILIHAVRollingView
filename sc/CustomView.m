//
//  ILIHAVRollingSubview.m
//  sc
//
//  Created by fx on 2018/1/19.
//  Copyright © 2018年 fxtest. All rights reserved.
//

#import "CustomView.h"


@interface CustomView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation CustomView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.frame = [UIScreen mainScreen].bounds;
        [self setupTableview];
    }
    return self;
}


- (void)setupTableview
{
    UITableView *tableview = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    tableview.dataSource = self;
    tableview.delegate = self;
    [tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView = tableview;
    if (@available(iOS 11.0, *)) {
        tableview.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
    }
    tableview.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
    [self addSubview:tableview];

}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 40;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"first   %ld %ld",indexPath.section,indexPath.row ];
    
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"ddddddddddddd");
}

@end
