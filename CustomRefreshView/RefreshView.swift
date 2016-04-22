//
//  RefreshView.swift
//  CustomRefreshView
//
//  Created by David on 2016/4/22.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

protocol RefreshViewDelegate: class {
	func refreshViewBeginRefreshing()
	func refreshViewEndRefreshing()
}

class RefreshView: UIView {

	weak var delegate: RefreshViewDelegate?
	weak var rootScrollView: UIScrollView?
	var isRefreshing: Bool = false
	var ball = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
	
	init(frame: CGRect, rootScrollView: UIScrollView?, delegate: RefreshViewDelegate?) {
		super.init(frame: frame)
		
		self.rootScrollView = rootScrollView
		self.rootScrollView?.delegate = self
		self.delegate = delegate
		
		backgroundColor = UIColor.lightGrayColor()
		
		ball.layer.cornerRadius = 15
		ball.backgroundColor = UIColor.greenColor()
		ball.center.y = bounds.midY
		ball.frame.origin.x = 30
		addSubview(ball)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func beginRefreshing() {
		isRefreshing = true
		delegate?.refreshViewBeginRefreshing()
	}
	
	func cancelRefreshing() {
		UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { 
			self.rootScrollView?.contentInset.top = 0
			}, completion: nil)
	}
	
	func endRefreshing() {
		isRefreshing = false
		UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
			self.rootScrollView?.contentInset.top = 0
			}, completion: nil)
		delegate?.refreshViewEndRefreshing()
	}
	
	func updateUI(progress: CGFloat) {
		ball.frame.origin.x = 30 + progress * 300
	}
}

extension RefreshView : UIScrollViewDelegate {
	
	func scrollViewWillBeginDragging(scrollView: UIScrollView) {
		if rootScrollView?.contentInset.top != bounds.height {
			rootScrollView?.contentInset.top = bounds.height
		}
	}
	
	func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if -scrollView.contentOffset.y >= bounds.height && !isRefreshing {
			beginRefreshing()
		} else if -scrollView.contentOffset.y < bounds.height {
			cancelRefreshing()
		}
	}
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		let progress = CGFloat(min(100.0, max(-scrollView.contentOffset.y, 0.0))) / 100
		print("progress", progress)
		updateUI(progress)
	}
}