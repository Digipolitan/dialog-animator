//
//  DGDialogAnimator.swift
//  DGDialogAnimator
//
//  Created by Julien Sarazin on 27/12/2016.
//  Copyright © 2016 Digipolitan. All rights reserved.
//

import UIKit


open class DGDialogAnimator {
	/**
	*	Nested Struct used to maintain default values.
	*/
	fileprivate struct Defaults {
		var animationDuration: TimeInterval
		var animationDelay: TimeInterval

		init(animationDuration: TimeInterval = 0.3, animationDelay: TimeInterval = 1.0) {
			self.animationDuration = animationDuration
			self.animationDelay = animationDelay
		}
	}
	/**
	*	Nested Struct that hold default pre-registered positions
	**/
	public struct Position: OptionSet {
		public let rawValue: Int

		public init(rawValue: Int) {
			self.rawValue = rawValue
		}

		public static let top		= Position(rawValue: 1 << 0)
		public static let right		= Position(rawValue: 1 << 1)
		public static let bottom	= Position(rawValue: 1 << 2)
		public static let left		= Position(rawValue: 1 << 3)
		public static let center	= Position(rawValue: 1 << 4)
	}
	/**
	*	Nested Struct used to configure the behavior of the animator.
	*/
	public struct Options {
		public var backDrop: Bool
		public var blurEffect: UIBlurEffectStyle?
		public var coverStatusBar: Bool
		public var duration: TimeInterval
		public var hold: TimeInterval
		public var enterAnimationOptions: UIViewAnimationOptions
		public var leaveAnimationOptions: UIViewAnimationOptions
		public var waiting: Bool

		private var _blurIntensity: CGFloat = 1.0
		public var blurIntensity: CGFloat {
			get {
				return _blurIntensity
			}
			set {
				_blurIntensity = max(0, min(1, newValue))
			}
		}

		public init(coverStatusBar: Bool = false, hold: TimeInterval = 1.0, duration: TimeInterval = 0.3, options: UIViewAnimationOptions = .curveEaseIn) {
			self.coverStatusBar = coverStatusBar
			self.blurEffect = .light
			self.hold = hold
			self.duration = duration
			self.enterAnimationOptions = options
			self.leaveAnimationOptions = options
			self.backDrop = false
			self.waiting = false
		}
	}
	/**
	*	Nested class used to add behavior in dialog's background.
	*/
	fileprivate class Background: UIVisualEffectView {
		var backDrop: Bool = true

		override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
			if self.backDrop {
				DGDialogAnimator.default.dismiss()
			}
			super.touchesEnded(touches, with: event)
		}
	}

	open static let `default`: DGDialogAnimator = DGDialogAnimator()
	private init() {
		NotificationCenter.default.removeObserver(self)
		NotificationCenter.default.addObserver(self, selector: #selector(updateFrameIsAnimating), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
	}

	private weak var currentView: UIView?
	private weak var currentContainer: UIView?
	private var currentPosition: Position?

	private var isLeaving: Bool = false
	private var isAnimating: Bool = false
	private var leaveAnimation: ((_ deadline: DispatchTime?) -> Void)?

	public func dismiss() {
		guard let dismiss = self.leaveAnimation else {
			return
		}

		dismiss(.now())
		self.isAnimating = false
	}


	@objc
	fileprivate func updateFrameIsAnimating() {
		let origin: CGPoint = self.getFinalCoordinates(for: self.currentView!, in: self.currentContainer, from: self.currentPosition)
		self.currentView?.frame.origin = origin
	}

	public func animate(view: UIView, in container: UIView?, with options: Options?, from initial: Position, to final: Position? = nil, completion: ((Void) -> (Void))? = nil) {
		let initialPoint = self.getInitialCoordinates(for: view, in: container, from: initial)
		let finalPoint	 = self.getFinalCoordinates(for: view, in: container, from: final)
		let	animatorOptions = options ?? Options()

		self.currentPosition = final
		self.animate(view: view, in: container, with: animatorOptions, initialPoint: initialPoint, finalPoint: finalPoint, completion: completion)
	}

	public func animate(view: UIView, in container: UIView?, with options: Options, initialPoint: CGPoint, finalPoint: CGPoint, completion: ((Void) -> (Void))?) {
		guard (container  == nil || !options.coverStatusBar) else {
			fatalError("container must be nil when `coverStatusBar` options is enabled")
		}

		guard !self.isAnimating else {
			return
		}

		self.currentView		= view
		self.currentContainer	= container
		self.isAnimating		= true

		let wrapper = (container == nil && options.coverStatusBar) ? self.wrap(view: view) : view
		wrapper.frame.origin = initialPoint


		let blurView = self.blur(view: container, with: options.blurEffect)

		if blurView != nil {
			blurView?.alpha = 0
			blurView?.backDrop = options.backDrop
			if container != nil {
				container?.addSubview(blurView!)
			}
			else {
				UIApplication.shared.delegate!.window!!.addSubview(blurView!)
			}

			UIView.animate(withDuration: 0.2, animations: {
				blurView?.alpha = options.blurIntensity
			})
		}

		container?.addSubview(wrapper)
		self.leaveAnimation = { (dispatchTime) in
			let deadline = (dispatchTime == nil) ? .now() + (options.waiting ? 0 : options.hold) : dispatchTime!

			DispatchQueue.main.asyncAfter(deadline: deadline, execute: {
				guard !self.isLeaving else {
					return
				}

				self.isLeaving = true

				if blurView != nil {
					UIView.animate(withDuration: 0.2, animations: {
						blurView?.alpha = 0
					})
				}

				UIView.animate(withDuration: options.duration,
				               delay: 0,
				               options: [options.leaveAnimationOptions, .allowUserInteraction],
				               animations: {
								wrapper.frame.origin = initialPoint
				}) { (completed) in
					blurView?.removeFromSuperview()
					wrapper.removeFromSuperview()
					self.isAnimating = false
					self.isLeaving = false
					completion?()
				}
			})
		}

		UIView.animate(withDuration: options.duration,
		               delay: 0,
		               options: options.enterAnimationOptions,
		               animations: {
						wrapper.frame.origin = finalPoint
		}) { (completed) in
			guard !options.waiting else {
				return
			}
			self.leaveAnimation?(nil)
		}

	}

	private func wrap(view: UIView) -> UIWindow{
		let window = UIWindow(frame: view.frame)
		window.isHidden = false
		window.windowLevel = UIWindowLevelStatusBar + 1
		window.addSubview(view)
		return window
	}

	private func blur(view: UIView?, with effectStyle: UIBlurEffectStyle?) -> Background? {
		guard let style = effectStyle else {
			return nil
		}

		guard !UIAccessibilityIsReduceTransparencyEnabled() else {
			return nil
		}

		let container = view ?? UIApplication.shared.delegate!.window!!
		let blurEffect = UIBlurEffect(style: style)
		let blurEffectView = Background(effect: blurEffect)
		blurEffectView.frame = container.bounds
		blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		return blurEffectView
	}

	private func getInitialCoordinates(for view: UIView, in containerView: UIView?,  from position: Position) -> CGPoint {
		let container = containerView ?? UIApplication.shared.delegate!.window!!

		switch position {
		case [.top]:
			return  CGPoint(x: container.frame.width/2 - view.frame.width/2, y: -view.frame.height)
		case [.bottom]:
			return CGPoint(x: container.frame.width/2 - view.frame.width/2, y: container.frame.height)
		case [.left]:
			return  CGPoint(x: -view.frame.width, y: container.frame.height/2 - view.frame.height/2)
		case [.right]:
			return  CGPoint(x: container.frame.width, y: container.frame.height/2 - view.frame.height/2)
		case [.top, .left]:
			return CGPoint(x: -view.frame.width, y: 0)
		case [.top, .right]:
			return  CGPoint(x: container.frame.width, y: 0)
		case [.bottom, .left]:
			return  CGPoint(x: -view.frame.width, y: container.frame.height - view.frame.height)
		case [.bottom, .right]:
			return  CGPoint(x: container.frame.width, y: container.frame.height - view.frame.height)
		default:
			return CGPoint(x: 0, y:0)
		}
	}

	private func getFinalCoordinates(for view: UIView, in containerView: UIView?,  from position: Position?) -> CGPoint {
		let container = containerView ?? UIApplication.shared.delegate!.window!!

		switch position {
		case [.top]?:
			return CGPoint(x: container.frame.width/2 - view.frame.width/2, y: 0)
		case [.bottom]?:
			return CGPoint(x: container.frame.width/2 - view.frame.width/2, y: container.frame.height - view.frame.height)
		case [.left]?:
			return  CGPoint(x: 0, y: container.frame.height/2 - view.frame.height/2)
		case [.right]?:
			return  CGPoint(x: container.frame.width - view.frame.width, y: container.frame.height/2 - view.frame.height/2)
		case [.top, .left]?:
			return  CGPoint(x: 0, y: 0)
		case [.top, .right]?:
			return  CGPoint(x: container.frame.width - view.frame.width, y: 0)
		case [.bottom, .left]?:
			return  CGPoint(x: 0, y: container.frame.height - view.frame.height)
		case [.bottom, .right]?:
			return  CGPoint(x: container.frame.width - view.frame.width, y: container.frame.height - view.frame.height)
		default:
			return  CGPoint(x: container.frame.width/2 - view.frame.width/2, y: container.frame.height/2 - view.frame.height/2)
		}
	}
}
