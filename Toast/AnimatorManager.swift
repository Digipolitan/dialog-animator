//
//  ToastManager.swift
//  Toast
//
//  Created by Julien Sarazin on 27/12/2016.
//  Copyright © 2016 Digipolitan. All rights reserved.
//

import UIKit

struct DGPosition: OptionSet {
	let rawValue: Int

	static let top		= DGPosition(rawValue: 1 << 0)
	static let right	= DGPosition(rawValue: 1 << 1)
	static let bottom   = DGPosition(rawValue: 1 << 2)
	static let left		= DGPosition(rawValue: 1 << 3)
	static let center	= DGPosition(rawValue: 1 << 4)
}

private let default_animation_duration = 0.3
private let default_animation_delay = 1.0

open class AnimatorManager {
	open static let `default`: AnimatorManager = AnimatorManager()
	private init() {

	}

	func animate(view: UIView, in container: UIView?, with options: AnimatorOptions?, from initial: DGPosition, to final: DGPosition? = nil) {
		let initialPoint = self.getInitialCoordinates(for: view, in: container, from: initial)
		let finalPoint	 = self.getFinalCoordinates(for: view, in: container, from: final)
		let	animatorOptions = options ?? AnimatorOptions()

		self.animate(view: view, in: container, from: initialPoint, to: finalPoint, options: animatorOptions)
	}

	func animate(view: UIView, in container: UIView?, from initialPosition: CGPoint, to finalPosition: CGPoint, options: AnimatorOptions) {
		guard (container  == nil || !options.coverStatusBar) else {
			fatalError("cannot cover status bar with a container")
		}

		let wrapper = (container == nil && options.coverStatusBar) ? self.wrap(view: view) : view
		wrapper.frame.origin = initialPosition

		container?.addSubview(wrapper)

		UIView.animate(withDuration: options.duration,
		               delay: 0,
		               options: options.enterAnimationOptions,
		               animations: {
						wrapper.frame.origin = finalPosition
		}) { (completed) in
			UIView.animate(withDuration: options.duration,
			               delay: options.hold,
			               options: options.leaveAnimationOptions,
			               animations: {
							wrapper.frame.origin = initialPosition
			}) { (completed) in
				wrapper.removeFromSuperview()
			}
		}
	}

	private func wrap(view: UIView) -> UIWindow{
		let window = UIWindow(frame: view.frame)
		window.isHidden = false
		window.windowLevel = UIWindowLevelStatusBar + 1
		window.addSubview(view)
		return window
	}

	private func getInitialCoordinates(for view: UIView, in containerView: UIView?,  from position: DGPosition) -> CGPoint {
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

	private func getFinalCoordinates(for view: UIView, in containerView: UIView?,  from position: DGPosition?) -> CGPoint {
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
