//
//  AnimatorOptions.swift
//  Toast
//
//  Created by Julien Sarazin on 28/12/2016.
//  Copyright © 2016 Digipolitan. All rights reserved.
//

import UIKit

open class AnimatorOptions: NSObject {
	var coverStatusBar: Bool	= false
	var blur: Bool				= false
	var hold: TimeInterval		= 1.0
	var duration: TimeInterval	= 0.3

	var enterAnimationOptions: UIViewAnimationOptions = .curveEaseIn
	var leaveAnimationOptions: UIViewAnimationOptions = .curveEaseIn

	convenience init(coverStatusBar: Bool, blur: Bool, hold: TimeInterval, duration: TimeInterval, options: UIViewAnimationOptions) {
		self.init()
		self.coverStatusBar = coverStatusBar
		self.blur = blur
		self.hold = hold
		self.duration = duration
		self.enterAnimationOptions = options
		self.leaveAnimationOptions = options
	}
}
