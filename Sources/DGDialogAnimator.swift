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
     * Nested Struct that hold default pre-registered positions
     */
    public struct Position: OptionSet {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let top = Position(rawValue: 1 << 0)
        public static let right = Position(rawValue: 1 << 1)
        public static let bottom	= Position(rawValue: 1 << 2)
        public static let left = Position(rawValue: 1 << 3)
        public static let center	= Position(rawValue: 1 << 4)
    }

    /**
     * Nested Struct used to configure the behavior of the animator.
     */
    public struct Options {
        /**
         * Perform the dismiss animation if the user touch the background view, default true
         */
        public var backdrop: Bool
        /**
         * The blur effect to apply, default nil
         */
        public var blurEffectStyle: UIBlurEffectStyle?
        /**
         * The dialog will be prompt over the window's top view controller, default false
         */
        public var coverStatusBar: Bool
        /**
         * Animation duration, default 0.3
         */
        public var animationDuration: TimeInterval
        /**
         * The hold duration of the dialog, default 1.0
         */
        public var dismissDelay: TimeInterval
        /**
         * The curve animation, default easeOut
         */
        public var enterAnimationCurve: UIViewAnimationCurve
        /**
         * The curve animation, default easeIn
         */
        public var leaveAnimationCurve: UIViewAnimationCurve

        /**
         * The dialog will be fix until "dismiss" method called
         */
        public var hold: Bool

        public init(animationDuration: TimeInterval = 0.3, dismissDelay: TimeInterval = 1, enterAnimationCurve: UIViewAnimationCurve = .easeOut, leaveAnimationCurve: UIViewAnimationCurve = .easeIn) {
            self.animationDuration = animationDuration
            self.dismissDelay = dismissDelay
            self.enterAnimationCurve = enterAnimationCurve
            self.leaveAnimationCurve = leaveAnimationCurve
            self.coverStatusBar = false
            self.blurEffectStyle = .light
            self.hold = false
            self.backdrop = true
        }

        static func buildAnimationOptions(animationCurve: UIViewAnimationCurve) -> UIViewAnimationOptions {
            switch animationCurve {
            case .easeIn:
                return .curveEaseIn
            case .easeOut:
                return .curveEaseOut
            case .easeInOut:
                return .curveEaseInOut
            case .linear:
                return .curveLinear
            }
        }
    }

    open static let `default`: DGDialogAnimator = DGDialogAnimator()

    private init() {
        self.defaultOptions = Options()
        self.isLeaving = false
        self.isVisible = false
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(updateFrameIsAnimating), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    private let defaultOptions: Options

    private var isLeaving: Bool
    private var isVisible: Bool

    private weak var currentView: UIView?
    private weak var currentContainer: UIView?

    private var initialPosition: Position?
    private var initialCoordinates: CGPoint?

    private var finalPosition: Position?
    private var finalCoordinates: CGPoint?

    private var leaveAnimation: ((_ deadline: DispatchTime?) -> Void)?

    @objc
    public func dismiss() {
        guard let dismiss = self.leaveAnimation else {
            return
        }
        dismiss(.now())
    }

    @objc
    fileprivate func updateFrameIsAnimating() {
        if let view = self.currentView {
            self.finalCoordinates = self.finalCoordinates(for: view, in: self.currentContainer, from: self.finalPosition)
            self.initialCoordinates = self.initialCoordinates(for: view, in: self.currentContainer, from: self.initialPosition)
            if let origin = self.finalCoordinates {
                view.frame.origin = origin
            }
        }
    }

    public func animate(view: UIView, in container: UIView?, with options: Options?, from initial: Position, to final: Position? = nil, completion: ((Void) -> (Void))? = nil) {
        self.initialCoordinates = self.initialCoordinates(for: view, in: container, from: initial)
        self.finalCoordinates = self.finalCoordinates(for: view, in: container, from: final)

        self.initialPosition = initial
        self.finalPosition = final

        if let initialPoint = self.initialCoordinates,
            let finalPoint = self.finalCoordinates {
            self.animate(view: view,
                         in: container,
                         with: options ?? self.defaultOptions,
                         initialPoint: initialPoint,
                         finalPoint: finalPoint,
                         completion: completion)
        }
    }

    public func animate(view: UIView, in container: UIView?, with options: Options, initialPoint: CGPoint, finalPoint: CGPoint, completion: ((Void) -> (Void))?) {

        guard !self.isVisible else {
            return
        }
        guard container == nil || !options.coverStatusBar else {
            fatalError("container must be nil when `coverStatusBar` options is enabled")
        }
        self.currentView = view
        self.currentContainer = container
        self.isVisible = true

        let wrapperView = (container == nil && options.coverStatusBar) ? self.wrap(view: view) : view
        wrapperView.frame.origin = initialPoint

        let blurView = self.blur(view: container, with: options.blurEffectStyle)
        if blurView != nil {
            blurView!.alpha = 0
            if container != nil {
                container?.addSubview(blurView!)
            } else if let window = UIApplication.shared.keyWindow {
                window.addSubview(blurView!)
            }

            UIView.animate(withDuration: 0.2, animations: {
                blurView!.alpha = 1
            })
        }

        container?.addSubview(wrapperView)
        self.leaveAnimation = { (dispatchTime) in
            let deadline = (dispatchTime == nil) ? .now() + (options.hold ? 0 : options.dismissDelay) : dispatchTime!

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

                UIView.animate(withDuration: options.animationDuration,
                               delay: 0,
                               options: Options.buildAnimationOptions(animationCurve: options.leaveAnimationCurve),
                               animations: {
                                wrapperView.frame.origin = self.initialCoordinates ?? initialPoint
                }) { _ in
                    blurView?.removeFromSuperview()
                    wrapperView.removeFromSuperview()
                    self.isVisible = false
                    self.isLeaving = false
                    completion?()
                }
            })
        }

        UIView.animate(withDuration: options.animationDuration,
                       delay: 0,
                       options: Options.buildAnimationOptions(animationCurve: options.enterAnimationCurve),
                       animations: {
                        wrapperView.frame.origin = finalPoint
        }) { _ in
            guard !options.hold else {
                return
            }
            self.leaveAnimation?(nil)
        }
    }

    private func wrap(view: UIView) -> UIWindow {
        let window = UIWindow(frame: view.bounds)
        window.isHidden = false
        window.windowLevel = UIWindowLevelStatusBar + 1
        window.addSubview(view)
        return window
    }

    private func blur(view: UIView?, with effectStyle: UIBlurEffectStyle?) -> UIVisualEffectView? {
        guard let style = effectStyle else {
            return nil
        }
        guard !UIAccessibilityIsReduceTransparencyEnabled() else {
            return nil
        }
        guard let containerView = view ?? UIApplication.shared.keyWindow else {
            return nil
        }
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = containerView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
        return blurEffectView
    }

    private func initialCoordinates(for view: UIView, in containerView: UIView?, from position: Position?) -> CGPoint {

        guard let container = containerView ?? UIApplication.shared.keyWindow else {
            return nil
        }

        switch position {
        case [.top]?:
            return CGPoint(x: container.bounds.width / 2 - view.frame.width / 2,
                            y: -view.frame.height)
        case [.bottom]?:
            return CGPoint(x: container.bounds.width / 2 - view.frame.width / 2,
                           y: container.bounds.height)
        case [.left]?:
            return CGPoint(x: -view.frame.width,
                            y: container.bounds.height / 2 - view.frame.height / 2)
        case [.right]?:
            return CGPoint(x: container.bounds.width,
                            y: container.bounds.height / 2 - view.frame.height / 2)
        case [.top, .left]?:
            return CGPoint(x: -view.frame.width,
                           y: 0)
        case [.top, .right]?:
            return CGPoint(x: container.bounds.width,
                            y: 0)
        case [.bottom, .left]?:
            return CGPoint(x: -view.frame.width,
                            y: container.bounds.height - view.frame.height)
        case [.bottom, .right]?:
            return CGPoint(x: container.bounds.width,
                            y: container.bounds.height - view.frame.height)
        default:
            return CGPoint(x: container.bounds.width / 2 - view.frame.width / 2,
                           y: container.bounds.height / 2 - view.frame.height / 2)
        }
    }
    
    private func finalCoordinates(for view: UIView, in containerView: UIView?, from position: Position?) -> CGPoint {

        guard let container = containerView ?? UIApplication.shared.keyWindow else {
            return nil
        }

        switch position {
        case [.top]?:
            return CGPoint(x: container.bounds.width / 2 - view.frame.width / 2,
                           y: 0)
        case [.bottom]?:
            return CGPoint(x: container.bounds.width / 2 - view.frame.width / 2,
                           y: container.bounds.height - view.frame.height)
        case [.left]?:
            return CGPoint(x: 0,
                            y: container.bounds.height / 2 - view.frame.height / 2)
        case [.right]?:
            return CGPoint(x: container.bounds.width - view.frame.width,
                            y: container.bounds.height / 2 - view.frame.height / 2)
        case [.top, .left]?:
            return CGPoint(x: 0,
                            y: 0)
        case [.top, .right]?:
            return CGPoint(x: container.bounds.width - view.frame.width,
                            y: 0)
        case [.bottom, .left]?:
            return CGPoint(x: 0,
                            y: container.bounds.height - view.frame.height)
        case [.bottom, .right]?:
            return CGPoint(x: container.bounds.width - view.frame.width,
                            y: container.bounds.height - view.frame.height)
        default:
            return CGPoint(x: container.bounds.width / 2 - view.frame.width / 2,
                            y: container.bounds.height / 2 - view.frame.height / 2)
        }
    }
}
