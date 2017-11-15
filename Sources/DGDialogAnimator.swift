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
        public static let bottom = Position(rawValue: 1 << 2)
        public static let left = Position(rawValue: 1 << 3)
        public static let center = Position(rawValue: 1 << 4)
    }

    public struct AnimationPath {

        public let initialPosition: Position
        public let intermediatePosition: Position
        public let finalPosition: Position

        public init(initial: Position, intermediate: Position = .center, final: Position? = nil) {
            self.initialPosition = initial
            self.intermediatePosition = intermediate
            if final != nil {
                self.finalPosition = final!
            } else {
                self.finalPosition = initial
            }
        }
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

        fileprivate static func buildAnimationOptions(animationCurve: UIViewAnimationCurve) -> UIViewAnimationOptions {
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

    open static let defaultOptions = Options()

    private var dialogInfo: DialogInfo?

    private var topLevelContainer: UIView?

    public init() {
        #if os(iOS)
        NotificationCenter.default.addObserver(self, selector: #selector(updateFrameWithOrientation), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        #endif
    }

    #if os(iOS)
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    #endif

    @objc
    public func dismiss() {
        guard let dialogInfo = self.dialogInfo else {
            return
        }
        if let timer = dialogInfo.leaveTimer {
            if timer.isValid {
                timer.invalidate()
            }
        }
        UIView.animate(withDuration: dialogInfo.options.animationDuration,
                       delay: 0,
                       options: Options.buildAnimationOptions(animationCurve: dialogInfo.options.leaveAnimationCurve),
                       animations: {
                        dialogInfo.dialog.frame.origin = dialogInfo.finalPoint
                        dialogInfo.background?.alpha = 0
        }, completion: { _ in
            dialogInfo.background?.removeFromSuperview()
            dialogInfo.dialog.removeFromSuperview()
            if dialogInfo.container == self.topLevelContainer {
                dialogInfo.container.isHidden = true
            }
            dialogInfo.completion?()
            self.dialogInfo = nil
        })
    }

    @objc
    private func backgroundDismiss() {
        guard
            let dialogInfo = self.dialogInfo,
            dialogInfo.options.backdrop
            else {
                return
        }
        self.dismiss()
    }

    #if os(iOS)
    @objc
    fileprivate func updateFrameWithOrientation() {
        guard let dialogInfo = self.dialogInfo else {
            return
        }
        dialogInfo.dialog.frame.origin = dialogInfo.intermediatePoint
    }
    #endif

    public func animate(view: UIView, in container: UIView? = nil, with options: Options? = nil, path: AnimationPath, completion: (() -> Void)? = nil) {
        guard self.dialogInfo == nil else {
            return
        }
        let dialogOptions = options ?? DGDialogAnimator.defaultOptions
        guard let containerView = container == nil ? defaultContainer(coverStatusBar: dialogOptions.coverStatusBar) : container else {
            return
        }

        let background = self.background(options: dialogOptions)
        if let backgroundView = background {
            backgroundView.frame = containerView.bounds
            containerView.addSubview(backgroundView)
        }

        var dialogInfo = DialogInfo(dialog: view, container: containerView, background: background, path: path, options: dialogOptions)
        view.frame.origin = dialogInfo.initialPoint
        containerView.addSubview(view)

        dialogInfo.completion = completion
        self.dialogInfo = dialogInfo

        UIView.animate(withDuration: dialogOptions.animationDuration,
                       delay: 0,
                       options: Options.buildAnimationOptions(animationCurve: dialogOptions.enterAnimationCurve),
                       animations: {
                        background?.alpha = 1
                        view.frame.origin = dialogInfo.intermediatePoint
        }, completion: { _ in
            if self.dialogInfo != nil {
                if !dialogOptions.hold {
                    self.dialogInfo!.leaveTimer = Timer.scheduledTimer(timeInterval: dialogOptions.dismissDelay, target: self, selector: #selector(self.dismiss), userInfo: nil, repeats: false)
                }
            }
        })
    }

    private func defaultContainer(coverStatusBar: Bool = false) -> UIView? {
        if coverStatusBar {
            if self.topLevelContainer == nil {
                let window = DialogWindow()
                window.windowLevel = UIWindowLevelAlert
                window.rootViewController = UIViewController()
                self.topLevelContainer = window
            }
            let window =  self.topLevelContainer!
            window.frame = UIScreen.main.bounds
            window.isHidden = false
            window.backgroundColor = .clear
            return window
        }
        return UIApplication.shared.keyWindow
    }

    private func background(options: Options) -> UIView? {
        var background: UIView? = nil
        if let blurStyle = options.blurEffectStyle {
            background = self.blur(with: blurStyle)
        }
        background?.alpha = 0
        background?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundDismiss)))
        return background
    }

    private func blur(with effectStyle: UIBlurEffectStyle) -> UIVisualEffectView? {
        guard !UIAccessibilityIsReduceTransparencyEnabled() else {
            return nil
        }
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: effectStyle))
        blurEffectView.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleWidth, .flexibleHeight, .flexibleRightMargin, .flexibleBottomMargin]
        return blurEffectView
    }
}
