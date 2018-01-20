//
//  ILIHAVRollingHeaderView.m
//  sc
//
//  Created by fx on 2018/1/19.
//  Copyright © 2018年 fxtest. All rights reserved.
//

#import "ILIHAVRollingHeaderView.h"

@interface ILIHAVRollingHeaderView()


@property (nonatomic,weak)UIButton *btn;
@property (nonatomic,assign)CGPoint point;
@end

@implementation ILIHAVRollingHeaderView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor redColor];
        btn.frame = CGRectMake(0, 100, 120, 40);
        [self addSubview:btn];
        [btn addTarget:self action:@selector(handle) forControlEvents:UIControlEventTouchUpInside];
        self.btn = btn;
    }
    return self;
}


- (void)handle
{
    NSLog(@"cll");
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{

    self.point = point;
    return nil;
}

- (void)handleClickHeader
{
    if (CGRectContainsPoint(self.btn.frame, self.point)) {
        [self handle];
    }
}
@end
