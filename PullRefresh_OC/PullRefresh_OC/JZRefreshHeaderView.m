//
//  JZRefreshHeaderView.m
//  PullRefresh_OC
//
//  Created by jiong23 on 16/5/15.
//  Copyright © 2016年 Chenjz. All rights reserved.
//

#import "JZRefreshHeaderView.h"

@interface JZRefreshHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activetyView;

@end

@implementation JZRefreshHeaderView

+ (instancetype)refreshHeaserView {
    JZRefreshHeaderView *refreshHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"JZRefreshHeaderView" owner:nil options:nil] lastObject];
    return refreshHeaderView;
}

- (void)beginRefreshing {
    _titleLabel.text = @"正在刷新";
    _titleLabel.hidden = YES;
    [_activetyView startAnimating];
}

- (void)endRefreshing {
    _titleLabel.text = @"请下拉刷新";
    _titleLabel.hidden = NO;
    [_activetyView stopAnimating];
}

@end
