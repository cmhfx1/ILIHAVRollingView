//
//  ILIHAVRollingView.h
//  sc
//
//  Created by fx on 2018/1/19.
//  Copyright © 2018年 fxtest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILIHAVRollingHeaderView.h"

@interface ILIHAVRollingView : UIView


+ (ILIHAVRollingView *)rollingWithViews:(NSArray *)views headerView:(ILIHAVRollingHeaderView *)header headerHeight:(CGFloat)height heightMinHeight:(CGFloat)minH;
@end
