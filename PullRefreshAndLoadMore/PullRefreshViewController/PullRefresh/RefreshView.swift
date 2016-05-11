//
//  RefreshView.swift
//  PullRefreshViewController
//
//  Created by lzw on 5/11/16.
//  Copyright © 2016 lzwjava. All rights reserved.
//

import UIKit

class RefreshView: UIView {
    
    var titleLabel: UILabel!
    var indicatorView: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        addSubview(titleLabel)
        titleLabel.textAlignment = NSTextAlignment.Center
//        titleLabel.backgroundColor = UIColor(red: 167 / 255.0, green: 222 / 255.0, blue: 232 / 255.0, alpha: 1)
        resetLabel()
        
        print("size: \(frame.size)")
        
        indicatorView = UIActivityIndicatorView(frame: CGRect(x: (frame.size.width - 44) / 2, y: 0, width: 44, height: 44))
        print("center: \(center)")
        indicatorView.hidesWhenStopped = true
        indicatorView.activityIndicatorViewStyle = .Gray
//        indicatorView.backgroundColor = UIColor.redColor()
        indicatorView.hidden = true
        addSubview(indicatorView)
    }
    
    func resetLabel() {
        titleLabel.text = "请下拉刷新"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func beginRefreshing() {
        titleLabel.text = "刷新中"
        titleLabel.hidden = true
        indicatorView.startAnimating()
    }
    
    func endRefereshing() {
//        titleLabel.hidden = false
//        indicatorView.hidden = true
        titleLabel.text = "刷新成功"
        titleLabel.hidden = false
        indicatorView.stopAnimating()
        performSelector(#selector(self.resetLabel), withObject: nil, afterDelay: 1)
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
