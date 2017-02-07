//
//  DialogInfo.swift
//  DGDialogAnimator
//
//  Created by Benoit BRIATTE on 06/02/2017.
//  Copyright © 2017 Digipolitan. All rights reserved.
//

import UIKit

struct DialogInfo {

    public var dialog: UIView
    public var container: UIView
    public var background: UIView?

    public let path: DGDialogAnimator.AnimationPath

    public let options: DGDialogAnimator.Options

    public var leaveTimer: Timer?

    public var completion: ((Void) -> (Void))?

    public init(dialog: UIView, container: UIView, background: UIView?, path: DGDialogAnimator.AnimationPath, options: DGDialogAnimator.Options) {
        self.dialog = dialog
        self.container = container
        self.background = background
        self.path = path
        self.options = options
    }

    public var initialPoint: CGPoint {
        return DialogInfo.initialCoordinates(for: self.dialog, in: self.container, from: self.path.initialPosition)
    }

    public var intermediatePoint: CGPoint {
        return DialogInfo.finalCoordinates(for:self.dialog, in: self.container, from: self.path.intermediatePosition)
    }

    public var finalPoint: CGPoint {
        return DialogInfo.initialCoordinates(for: self.dialog, in: self.container, from: self.path.finalPosition)
    }

    private static func initialCoordinates(for view: UIView, in containerView: UIView, from position: DGDialogAnimator.Position?) -> CGPoint {

        switch position {
        case [.top]?:
            return CGPoint(x: containerView.bounds.width / 2 - view.frame.width / 2,
                           y: -view.frame.height)
        case [.bottom]?:
            return CGPoint(x: containerView.bounds.width / 2 - view.frame.width / 2,
                           y: containerView.bounds.height)
        case [.left]?:
            return CGPoint(x: -view.frame.width,
                           y: containerView.bounds.height / 2 - view.frame.height / 2)
        case [.right]?:
            return CGPoint(x: containerView.bounds.width,
                           y: containerView.bounds.height / 2 - view.frame.height / 2)
        case [.top, .left]?:
            return CGPoint(x: -view.frame.width,
                           y: 0)
        case [.top, .right]?:
            return CGPoint(x: containerView.bounds.width,
                           y: 0)
        case [.bottom, .left]?:
            return CGPoint(x: -view.frame.width,
                           y: containerView.bounds.height - view.frame.height)
        case [.bottom, .right]?:
            return CGPoint(x: containerView.bounds.width,
                           y: containerView.bounds.height - view.frame.height)
        default:
            return CGPoint(x: containerView.bounds.width / 2 - view.frame.width / 2,
                           y: containerView.bounds.height / 2 - view.frame.height / 2)
        }
    }

    private static func finalCoordinates(for view: UIView, in containerView: UIView, from position: DGDialogAnimator.Position?) -> CGPoint {

        switch position {
        case [.top]?:
            return CGPoint(x: containerView.bounds.width / 2 - view.frame.width / 2,
                           y: 0)
        case [.bottom]?:
            return CGPoint(x: containerView.bounds.width / 2 - view.frame.width / 2,
                           y: containerView.bounds.height - view.frame.height)
        case [.left]?:
            return CGPoint(x: 0,
                           y: containerView.bounds.height / 2 - view.frame.height / 2)
        case [.right]?:
            return CGPoint(x: containerView.bounds.width - view.frame.width,
                           y: containerView.bounds.height / 2 - view.frame.height / 2)
        case [.top, .left]?:
            return CGPoint(x: 0,
                           y: 0)
        case [.top, .right]?:
            return CGPoint(x: containerView.bounds.width - view.frame.width,
                           y: 0)
        case [.bottom, .left]?:
            return CGPoint(x: 0,
                           y: containerView.bounds.height - view.frame.height)
        case [.bottom, .right]?:
            return CGPoint(x: containerView.bounds.width - view.frame.width,
                           y: containerView.bounds.height - view.frame.height)
        default:
            return CGPoint(x: containerView.bounds.width / 2 - view.frame.width / 2,
                           y: containerView.bounds.height / 2 - view.frame.height / 2)
        }
    }
}
