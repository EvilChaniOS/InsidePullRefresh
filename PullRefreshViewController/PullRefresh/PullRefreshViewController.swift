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
    var tableHeaderView: UIView!
    var isRefreshing = false
    
    struct Constant {
        static let refreshHeight: CGFloat = 44
        static let tableViewInsetTop: CGFloat = 64
    }
    
    var refreshBlock: (() -> ())? {
        didSet {
            tableView.tableHeaderView = tableHeaderView
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
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print("scrollViewDidScroll")
        print("scrollview.contentOffset = \(scrollView.contentOffset)")
        print("scrollView.contentInset.top = \(scrollView.contentInset.top)")
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging:willDecelerate")
//        print("scrollview.contentOffset = \(scrollView.contentOffset)")
        let refreshOffset = -scrollView.contentOffset.y - scrollView.contentInset.top
        if (refreshOffset > 60 && refreshBlock != nil && !isRefreshing) {
            beginRefresh()
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
            self.tableView.contentInset.top = Constant.refreshHeight + Constant.tableViewInsetTop
            self.tableView.scrollIndicatorInsets = self.tableView.contentInset
        }) { (finished: Bool) in
            
        }
    }
    
    func endRefresh() {
        refreshView.endRefereshing()
        isRefreshing = false
        UIView.animateWithDuration(0.5) { 
            self.tableView.contentInset.top = Constant.tableViewInsetTop
        }
    }
    
}
