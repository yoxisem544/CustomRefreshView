//
//  CustomRefreshView.swift
//  CustomRefreshView
//
//  Created by David on 2016/4/20.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

protocol CustomRefreshViewDelegate: class {
	func customRefreshViewBeginRefreshing()
	func customRefreshViewEndRefreshing()
}

class CustomRefreshView: UIView {

	weak var delegate: CustomRefreshViewDelegate?
	weak var rootScrollView: UIScrollView?
	var isRefreshing: Bool = false
	let imageView = UIImageView()
	
	init(frame: CGRect, rootScrollView: UIScrollView?, delegate: CustomRefreshViewDelegate?) {
		super.init(frame: frame)
		
		imageView.frame = frame
		imageView.frame.origin = CGPointZero
		imageView.image = UIImage(named: "f.png")
		imageView.contentMode = .ScaleAspectFill
		imageView.clipsToBounds = true
		addSubview(imageView)
		
		self.rootScrollView = rootScrollView
		self.rootScrollView?.delegate = self
		self.delegate = delegate
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func beginRefresing(currentY: CGFloat) {
		isRefreshing = true
//		self.rootScrollView?.setContentOffset(CGPoint(x: 0, y: self.rootScrollView!.contentOffset.y-100), animated: false)
		UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
//			self.rootScrollView?.contentInset.top = 100
//			self.rootScrollView?.contentOffset.y = 0
			}, completion: { _ in
				
		})
		delegate?.customRefreshViewBeginRefreshing()
	}
	
	func cancelRefreshing() {
		UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
			self.rootScrollView?.contentInset.top = 0
			//			self.rootScrollView?.contentOffset.y = 0
			}, completion: { _ in
				
		})
	}
	
	func startRefreshing() {
		
	}
	
	func endRefresh() {
		isRefreshing = false
		delegate?.customRefreshViewEndRefreshing()
		UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { 
			self.rootScrollView?.contentInset.top = 0
			self.rootScrollView?.contentOffset.y = 0
			}, completion: nil)
		
	}
}

extension CustomRefreshView : UIScrollViewDelegate {
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		let yOffset = scrollView.contentOffset.y

	}
	
	func scrollViewWillBeginDragging(scrollView: UIScrollView) {
		if scrollView.contentInset.top != 100 {
			scrollView.contentInset.top = 100
		}
	}
	
	func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
		print("scrollViewWillBeginDecelerating")
	}
	
	func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
		print("scrollViewDidEndDecelerating")
	}
	
	func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		let yOffset = CGFloat(max(-(scrollView.contentOffset.y + scrollView.contentInset.top), 0.0))
		let progress = scrollView.contentOffset.y / frame.height
		print(scrollView.contentOffset.y)
		if -scrollView.contentOffset.y >= 100 && !isRefreshing {
			beginRefresing(scrollView.contentOffset.y)
		} else if -scrollView.contentOffset.y < 100 {
			cancelRefreshing()
		}
	}
	
	func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		
	}
}
