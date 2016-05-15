//
//  JZRefreshHeaderView.h
//  PullRefresh_OC
//
//  Created by jiong23 on 16/5/15.
//  Copyright © 2016年 Chenjz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JZRefreshHeaderView : UIView

+ (instancetype)refreshHeaserView;

- (void)beginRefreshing;
- (void)endRefreshing;

@end
