//
//  PullRefreshViewController.swift
//  PullRefreshViewController
//
//  Created by lzw on 5/11/16.
//  Copyright © 2016 lzwjava. All rights reserved.
//

import UIKit

class PullRefreshViewController: UIViewController, UIScrollViewDelegate {
    
    var tableView: UITableView!
    var refreshView: RefreshView!
    var loadMoreView: RefreshView!
    var tableHeaderView: UIView!
    var tableFooterView: UIView!
    var isRefreshing = false
    var isLoadingMore = false
    var tableViewInsetTop: CGFloat = -1
    var tableViewInsetBottom: CGFloat = -1
    
    struct Constant {
        static let refreshViewHeight: CGFloat = 44
    }
    
    var refreshBlock: (() -> ())? {
        didSet {
            tableView.tableHeaderView = tableHeaderView
        }
    }
    
    var loadMoreBlock: (() -> ())? {
        didSet {
            tableView.tableFooterView = tableFooterView
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        super.loadView()
        // tableHeaderView 的高度设为0，是为了让它的高度不影响我们的计算，减少复杂度。大家可以设为 44 看看。
        tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(UIScreen.mainScreen().bounds), height: 0))
        refreshView = RefreshView(frame: CGRect(x: 0, y: -44, width:  CGRectGetWidth(UIScreen.mainScreen().bounds), height: 44))
        tableHeaderView.addSubview(refreshView)
        
        tableFooterView = UIView(frame:  CGRect(x: 0, y: 0, width: CGRectGetWidth(UIScreen.mainScreen().bounds), height: 0))
        loadMoreView = RefreshView(frame: CGRect(x: 0, y: 0, width:  CGRectGetWidth(UIScreen.mainScreen().bounds), height: 44))
        tableFooterView.addSubview(loadMoreView)
    }
    
    func initInsets() {
        // 动态获取默认的 tableViewInsetTop 和 tableViewInsetBottom，比如底部有无 Tabbar、顶部有无导航栏，会影响它们的具体数值
        if (tableViewInsetTop == -1) {
            tableViewInsetTop = self.tableView.contentInset.top
        }
        if (tableViewInsetBottom == -1) {
            tableViewInsetBottom = self.tableView.contentInset.bottom
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print("scrollViewDidScroll")
        print("scrollview.contentOffset = \(scrollView.contentOffset)")
//        print("scrollView.contentInset = \(scrollView.contentInset)")
        let refreshOffset = -scrollView.contentOffset.y - scrollView.contentInset.top
        // 研究下拉刷新时，建议把其它位置的 log 注释掉，只打印下面一行
        print("refreshOffset<\(refreshOffset)> = -contentOffset.y <\(scrollView.contentOffset.y)> - contentInset.top<\(scrollView.contentInset.top)>")
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging:willDecelerate")
        initInsets()
        let refreshOffset = -scrollView.contentOffset.y - scrollView.contentInset.top
        if (refreshOffset > 60 && refreshBlock != nil && !isRefreshing) {
            beginRefresh()
        }
        
        let loadMoreOffset = scrollView.contentSize.height - scrollView.contentOffset.y - (view.frame.height - scrollView.contentInset.bottom)
        print("scrollView.contentInset.bottom= \(scrollView.contentInset.bottom)")
        print("loadMoreOffset = \(loadMoreOffset)")
        if (loadMoreOffset < -60 && loadMoreBlock != nil && !isLoadingMore) {
            beginLoadMore()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
    }
    
    func beginRefresh() {
        if (isRefreshing) {
            return
        }
        isRefreshing = true
        refreshView.beginRefreshing()
        if let refreshBlock = refreshBlock {
            refreshBlock()
        }
        UIView.animateKeyframesWithDuration(0.3, delay: 0, options: .BeginFromCurrentState, animations: {
            // 把 contentInsetTop 设为刷新头高度加上初始状态时的值，露出刷新头，保持在那个位置等待刷新结束
            self.tableView.contentInset.top = Constant.refreshViewHeight + self.tableViewInsetTop
            // scrollIndicator，即旁边的滚动提示，看起来更好些，也可以不设置。
            self.tableView.scrollIndicatorInsets = self.tableView.contentInset
        }) { (finished: Bool) in
            
        }
    }
    
    func endRefresh() {
        refreshView.endRefereshing()
        isRefreshing = false
        UIView.animateWithDuration(0.5) {
            // 把 contentInsetTop 设为初始状态时候的值，恢复原位
            self.tableView.contentInset.top = self.tableViewInsetTop
            self.tableView.scrollIndicatorInsets = self.tableView.contentInset
        }
    }
    
    func beginLoadMore() {
        loadMoreView.beginRefreshing()
        isLoadingMore = true
        if let loadMoreBlock = loadMoreBlock {
            loadMoreBlock()
        }
        UIView.animateWithDuration(0.2) {
            var inset = self.tableView.contentInset
            inset.bottom = inset.bottom + Constant.refreshViewHeight
            self.tableView.contentInset = inset
        }
    }
    
    func endLoadMore() {
        loadMoreView.endRefereshing()
        isLoadingMore = false
        UIView.animateWithDuration(0.2) {
            var inset = self.tableView.contentInset
            inset.bottom = self.tableViewInsetBottom
            self.tableView.contentInset = inset
        }
    }
    
}
