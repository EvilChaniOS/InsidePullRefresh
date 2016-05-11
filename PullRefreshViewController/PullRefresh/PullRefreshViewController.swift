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
    var refreshView: UIView!
    var tableHeaderView: UIView!
    
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
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        
    }
    
    func endRefresh() {
        
    }
    
}
