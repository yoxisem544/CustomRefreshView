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
	let bear = UIImageView(image: UIImage(named: "bear.png"))
	let spaceship = UIImageView(image: UIImage(named: "spaceship.png"))
	let flame = UIImageView(image: UIImage(named: "flame.png"))
	var initialCenter: CGPoint!
	var animationCenter: CGPoint!
	var endAnimationCenter: CGPoint!
	
	init(frame: CGRect, rootScrollView: UIScrollView?, delegate: RefreshViewDelegate?) {
		super.init(frame: frame)
		
		self.rootScrollView = rootScrollView
		self.rootScrollView?.delegate = self
		self.delegate = delegate
		
		backgroundColor = UIColor.lightGrayColor()
		
		initialCenter = CGPoint(x: bounds.midX, y: bounds.midY + 12)
		animationCenter = CGPoint(x: initialCenter.x, y: initialCenter.y - 20)
		endAnimationCenter = CGPoint(x: animationCenter.x, y: animationCenter.y - 20)
		
		clipsToBounds = true
		
		addBear()
		addSpaceship()
		addFlame()
		
		// initial point
		moveBearToInitialPoint()
		moveSpaceShipToInitialPoint()
	}
	
	func addBear() {
		addSubview(bear)
		bear.center = CGPoint(x: bounds.midX, y: bounds.midY)
		let width = bear.bounds.width
		let height = bear.bounds.height
		let scaleFactor: CGFloat = 0.07
		bear.bounds.size = CGSize(width: width * scaleFactor, height: height * scaleFactor)
		
		bear.center.y = bear.center.y + 10
	}
	
	func moveBearToInitialPoint() {
		bear.center.y = initialCenter.y + 50
	}
	
	func updateBear(progress: CGFloat) {
		bear.center.y = initialCenter.y + 50 * (1.0 - progress)
	}
	
	func moveBearToAnimationPoint() {
		bear.center.y = animationCenter.y
	}
	
	func moveBearToEndAnimationPoint() {
		bear.center.y = endAnimationCenter.y
	}
	
	func addSpaceship() {
		addSubview(spaceship)
		spaceship.center = CGPoint(x: bounds.midX, y: bounds.midY)
		let width = spaceship.bounds.width
		let height = spaceship.bounds.height
		let scaleFactor: CGFloat = 0.07
		spaceship.bounds.size = CGSize(width: width * scaleFactor, height: height * scaleFactor)
	}
	
	func moveSpaceShipToInitialPoint() {
		spaceship.center.y = -65 + bear.center.y - 5
	}
	
	func updateSpaceShip(progress: CGFloat) {
		spaceship.center.y = -65 * (1.0 - progress) + bear.center.y - 5
	}
	
	func moveSpaceShipToAnimationPoint() {
		spaceship.center.y = bear.center.y - 5
	}
	
	func addFlame() {
		insertSubview(flame, belowSubview: spaceship)
		flame.center = CGPoint(x: bounds.midX, y: bounds.midY)
		let width = flame.bounds.width
		let height = flame.bounds.height
		let scaleFactor: CGFloat = 0.07
		flame.bounds.size = CGSize(width: width * scaleFactor, height: height * scaleFactor)
		
		hideFlame()
	}
	
	func showFlame() {
		flame.hidden = false
		moveFlameToInitialPoint()
	}
	
	func hideFlame() {
		flame.hidden = true
	}
	
	func moveFlameToInitialPoint() {
		flame.frame.origin.y = spaceship.frame.maxY - 8
	}
	
	func moveFlameToAnimationPoint() {
		flame.frame.origin.y = spaceship.frame.maxY - 8
	}
	
	func initialRotateAngleOfFlame() {
		let angle: CGFloat = CGFloat(M_PI) / 180.0 * 5
		flame.transform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(angle), -0.5, 0)
	}
	
	func rotateFlame() {
		let angle: CGFloat = CGFloat(M_PI) / 180.0 * -5
		flame.transform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(angle), 0.5, 0)
	}
	
	func startAnimation() {
		
		showFlame()
		
		UIView.animateWithDuration(0.2) {
			self.moveBearToAnimationPoint()
			self.moveSpaceShipToAnimationPoint()
			self.moveFlameToAnimationPoint()
		}
		
		initialRotateAngleOfFlame()
		
		UIView.animateWithDuration(0.08, delay: 0, options: [UIViewAnimationOptions.Repeat, UIViewAnimationOptions.Autoreverse], animations: {
			self.rotateFlame()
			}, completion: nil)
		
	}
	
	func stopAnimating() {
		
		UIView.animateWithDuration(0.3, delay: 0.3, options: [], animations: { 
			self.moveBearToEndAnimationPoint()
			self.moveSpaceShipToAnimationPoint()
			self.moveFlameToAnimationPoint()
			}) { (_) in
				self.hideFlame()
				
				UIView.animateWithDuration(0.1) {
					self.bear.transform = CGAffineTransformIdentity
					self.spaceship.transform = CGAffineTransformIdentity
					self.flame.transform = CGAffineTransformIdentity
				}
				
				self.moveBearToInitialPoint()
				self.moveSpaceShipToInitialPoint()
				self.moveFlameToInitialPoint()
				
				self.isRefreshing = false
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func beginRefreshing() {
		isRefreshing = true
		delegate?.refreshViewBeginRefreshing()
		startAnimation()
	}
	
	func cancelRefreshing() {
		isRefreshing = false
		UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
			self.rootScrollView?.contentInset.top = 0
			}, completion: nil)
		stopAnimating()
	}
	
	func endRefreshing() {
		UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
			self.rootScrollView?.contentInset.top = 0
			}, completion: { _ in
				self.stopAnimating()
		})
		delegate?.refreshViewEndRefreshing()
	}
	
	func updateUI(progress: CGFloat) {
		if !isRefreshing {
			updateSpaceShip(progress)
			updateBear(progress)
		}
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
//			cancelRefreshing()
		}
	}
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		let progress = CGFloat(min(100.0, max(-scrollView.contentOffset.y, 0.0))) / 100
//		print("progress", progress)
		updateUI(progress)
	}
}