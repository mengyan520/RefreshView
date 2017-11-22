//
//  RefreshView.h
//  浮动刷新动画
//
//  Created by 马鸣 on 2017/11/22.
//  Copyright © 2017年 马鸣. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RefreshViewHeight 64
//刷新状态
typedef enum:NSUInteger {
    RefreshStatusNormal,//正常
    RefreshStatusPulling,//释放刷新
    RefreshStatusRefreshing//正在刷新
    
    
}RefreshStatus;
@interface RefreshView : UIView
@property (nonatomic, copy) void(^refreshingBlock)(void);
//结束刷新
- (void)endRefreshing;
//开始刷新
- (void)startRefreshing;
@end
