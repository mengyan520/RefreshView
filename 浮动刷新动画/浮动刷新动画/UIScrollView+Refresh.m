//
//  UIScrollView+Refresh.m
//  浮动刷新动画
//
//  Created by 马鸣 on 2017/11/22.
//  Copyright © 2017年 马鸣. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import <objc/runtime.h>
static const char *refreshHeaderKey = "refreshHeaderKey";
@implementation UIScrollView (Refresh)
#pragma mark - set
- (void)setRefreshHeaderView:(RefreshView *)refreshHeaderView {
    
    objc_setAssociatedObject(self, refreshHeaderKey, refreshHeaderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#pragma mark - get
- (RefreshView *)refreshHeaderView {
    RefreshView *refreshHeaderView = objc_getAssociatedObject(self, refreshHeaderKey);
    if (refreshHeaderView == nil) {
        refreshHeaderView = [[RefreshView alloc]initWithFrame:CGRectMake(0, -RefreshViewHeight, [UIScreen mainScreen].bounds.size.width, RefreshViewHeight)];
        //保存对象
        self.refreshHeaderView = refreshHeaderView;
        [self addSubview:refreshHeaderView];
    }
    return refreshHeaderView;
}
@end
