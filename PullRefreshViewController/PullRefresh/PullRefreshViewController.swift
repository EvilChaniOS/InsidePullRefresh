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
        tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(UIScreen.mainScreen().bounds), height: 0))
        refreshView = RefreshView(frame: CGRect(x: 0, y: -44, width:  CGRectGetWidth(UIScreen.mainScreen().bounds), height: 44))
        tableHeaderView.addSubview(refreshView)
        
        tableFooterView = UIView(frame:  CGRect(x: 0, y: 0, width: CGRectGetWidth(UIScreen.mainScreen().bounds), height: 0))
        loadMoreView = RefreshView(frame: CGRect(x: 0, y: 0, width:  CGRectGetWidth(UIScreen.mainScreen().bounds), height: 44))
        tableFooterView.addSubview(loadMoreView)
    }
    
    func initInsets() {
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
        print("scrollView.contentInset = \(scrollView.contentInset)")
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging:willDecelerate")
        initInsets()
//        print("scrollview.contentOffset = \(scrollView.contentOffset)")
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
            self.tableView.contentInset.top = Constant.refreshViewHeight + self.tableViewInsetTop
            self.tableView.scrollIndicatorInsets = self.tableView.contentInset
        }) { (finished: Bool) in
            
        }
    }
    
    func endRefresh() {
        refreshView.endRefereshing()
        isRefreshing = false
        UIView.animateWithDuration(0.5) { 
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
