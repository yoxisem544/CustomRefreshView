//
//  ViewController.swift
//  CustomRefreshView
//
//  Created by David on 2016/4/20.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	let scrollView = UIScrollView()
	var refreshView: RefreshView?
	
	func delay(time: Double, block: () -> Void) {
		let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * time))
		dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
			block()
		})
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		scrollView.frame = UIScreen.mainScreen().bounds
		scrollView.contentSize = scrollView.frame.size
		scrollView.contentSize.height = scrollView.frame.size.height * 3
		scrollView.delegate = self
		automaticallyAdjustsScrollViewInsets = false
		view.addSubview(scrollView)
		
		let refreshViewRect = CGRect(x: 0, y: -100, width: UIScreen.mainScreen().bounds.width, height: 100)
		
		refreshView = RefreshView(frame: refreshViewRect, rootScrollView: scrollView, delegate: self)
		scrollView.addSubview(refreshView!)
	}
}

extension ViewController : RefreshViewDelegate {
	func refreshViewBeginRefreshing() {
		delay(4.0) {
			self.refreshView?.endRefreshing()
		}
	}
	
	func refreshViewEndRefreshing() {
		
	}
}

extension ViewController : UIScrollViewDelegate {
	func scrollViewDidScroll(scrollView: UIScrollView) {
		
	}
}
