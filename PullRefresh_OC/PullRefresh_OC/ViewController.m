//
//  ViewController.m
//  PullRefresh_OC
//
//  Created by jiong23 on 16/5/15.
//  Copyright © 2016年 Chenjz. All rights reserved.
//

#import "ViewController.h"
#import "JZRefreshHeaderView.h"

static CGFloat const kRefreshHeaderHeight = 40.0;

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *talbeView;
@property (nonatomic, strong) JZRefreshHeaderView *refreshHeader;

@end

@implementation ViewController
#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.talbeView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
    [view addSubview:self.refreshHeader];
    self.talbeView.tableHeaderView = view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Delegate
#pragma mark - TableViewDelegate

#pragma mark - TableViewDateSourcr && TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    return cell;
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    NSLog(@"scrollViewWillBeginDragging - contentOffset - %@",NSStringFromCGPoint(scrollView.contentOffset));
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"scrollViewDidScroll - contentOffset - %@",NSStringFromCGPoint(scrollView.contentOffset));
    CGFloat offsetY = - scrollView.contentOffset.y - 64;
    NSLog(@"scrollViewscrollViewDidScrollDidEndDragging - contentOffset - %f",offsetY);
    if (offsetY > 50) {
        [self beginRefresh];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat offsetY = - scrollView.contentOffset.y - 64;
    NSLog(@"scrollViewDidEndDragging - contentOffset - %f",offsetY);
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:2.0];
}

#pragma mark - Privite Method

- (void)beginRefresh {
    
    [UIView animateWithDuration:1.0 animations:^{
        [self.refreshHeader beginRefreshing];
        UIEdgeInsets insets = self.talbeView.contentInset;
        insets.top = 64 + kRefreshHeaderHeight;
        self.talbeView.contentInset = insets;
    }];
    
}

- (void)endRefresh {
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.refreshHeader endRefreshing];
        UIEdgeInsets insets = self.talbeView.contentInset;
        insets.top = 64 ;
        self.talbeView.contentInset = insets;
    }];
    
}

#pragma mark - Setter && Getter

- (UITableView *)talbeView {
    if(!_talbeView) {
        _talbeView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        _talbeView.delegate = self;
        _talbeView.dataSource = self;
        _talbeView.backgroundColor = [UIColor blueColor];
        _talbeView.rowHeight = 40;
        _talbeView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _talbeView;
}

- (JZRefreshHeaderView *)refreshHeader {
    if(!_refreshHeader) {
        _refreshHeader = [JZRefreshHeaderView refreshHeaserView];
        _refreshHeader.frame = CGRectMake(0, -kRefreshHeaderHeight, [UIScreen mainScreen].bounds.size.width, kRefreshHeaderHeight);
        _refreshHeader.backgroundColor = [UIColor orangeColor];
    }
    return _refreshHeader;
}

@end
