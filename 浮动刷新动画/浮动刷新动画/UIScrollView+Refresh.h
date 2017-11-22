//
//  UIScrollView+Refresh.h
//  浮动刷新动画
//
//  Created by 马鸣 on 2017/11/22.
//  Copyright © 2017年 马鸣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshView.h"
@interface UIScrollView (Refresh)
//下拉刷新控件  头部
@property(nonatomic,strong)RefreshView *refreshHeaderView;
@end
