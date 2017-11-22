//
//  RefreshView.m
//  浮动刷新动画
//
//  Created by 马鸣 on 2017/11/22.
//  Copyright © 2017年 马鸣. All rights reserved.
//

#import "RefreshView.h"
@interface RefreshView()
//刷新文字提示
@property (nonatomic, strong) UILabel *label;
//记录当前状态
@property (nonatomic, assign) RefreshStatus currentStatus;
//父控件
@property (nonatomic, strong) UIScrollView *superScrollView;
@end
@implementation RefreshView
#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
         [self addSubview:self.label];
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}
#pragma mark - 重写子视图将要添加到父视图的方法
//在控制器中调用[self.tableView addSubview:refreshView];会调用这个方法
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    //这里可以获取到父控件 tableView、scrollView、collection,在本类中监听父控件的滚动
    if ([newSuperview isKindOfClass:[UIScrollView class]]) {
        self.superScrollView = (UIScrollView *)newSuperview;
        //监听父控件elf.superScrollView的滚动  即contentOffset属性
        //最好通过KVO监听；如果通过代理监听，外部再次设置代理会使这里面的监听滚动会失效
        //本类self监听self.superScrollView的contentOffset属性
        [self.superScrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
    }
    
}
#pragma mark - KVO监听滚动
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        //DBLog(@"%f",self.superScrollView.contentOffset.y);
        //拖动中：normal -> pulling   pulling ->normal
        if (self.superScrollView.isDragging) {//正在拖动
            //在控制器中self.superScrollView中初始contentOffset.y为-64
            CGFloat normalPullingOffset = - 2 * RefreshViewHeight;
            if (self.superScrollView.contentOffset.y > normalPullingOffset && self.currentStatus == RefreshStatusPulling) {
                DBLog(@"从pulling切换到normal状态");
                self.currentStatus = RefreshStatusNormal;
            }else if (self.superScrollView.contentOffset.y <= normalPullingOffset && self.currentStatus == RefreshStatusNormal) {
                DBLog(@"从normal切换到pulling状态");
                self.currentStatus = RefreshStatusPulling;
                
            }
            
        }else {//松开：pulling -> refreshing
            if (self.currentStatus == RefreshStatusPulling) {
                DBLog(@"从pulling切换到Refreshing状态");
                self.currentStatus = RefreshStatusRefreshing;
            }
            
            
        }
        
    }
    
}
#pragma mark - 设置刷新状态
- (void)setCurrentStatus:(RefreshStatus)currentStatus {
    _currentStatus = currentStatus;
    switch (_currentStatus) {
        case RefreshStatusNormal:
            self.label.text = @"下拉刷新";
            break;
        case RefreshStatusPulling:
            self.label.text = @"释放刷新";
            break;
        case RefreshStatusRefreshing:
            self.label.text = @"正在刷新";
            //说明：系统很多动画时间都是0.25s
            [UIView animateWithDuration:0.2 animations:^{
                //self.superScrollView往下走
                self.superScrollView.contentInset = UIEdgeInsetsMake(self.superScrollView.contentInset.top + RefreshViewHeight, self.superScrollView.contentInset.left, self.superScrollView.contentInset.bottom, self.superScrollView.contentInset.right);
            }];
            //让控制器做事情
            if (self.refreshingBlock) {
                self.refreshingBlock();
            }
            break;
    }
    
}
#pragma mark - 开始刷新
- (void)startRefreshing {
    self.currentStatus = RefreshStatusRefreshing;
}
#pragma mark - 结束刷新
- (void)endRefreshing {
    //refreshing  -> normal
    if (self.currentStatus == RefreshStatusRefreshing) {
        self.currentStatus = RefreshStatusNormal;
        //tableView回去
        [UIView animateWithDuration:0.2 animations:^{
            //self.superScrollView往下走
            self.superScrollView.contentInset = UIEdgeInsetsMake(self.superScrollView.contentInset.top - RefreshViewHeight, self.superScrollView.contentInset.left, self.superScrollView.contentInset.bottom, self.superScrollView.contentInset.right);
        }];
    }
    
}
#pragma mark - Getter
- (UILabel *)label{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, 375, 20)];
        _label.textColor = [UIColor darkGrayColor];
        _label.font = [UIFont systemFontOfSize:16];
        _label.text = @"下拉刷新";
    }
    return _label;
}
#pragma mark - dealloc
-(void)dealloc{
    [self.superScrollView removeObserver:self forKeyPath:@"contentOffset"];
}
@end
