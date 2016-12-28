//
//  AnimatorBlurView.swift
//  Toast
//
//  Created by Julien Sarazin on 28/12/2016.
//  Copyright © 2016 Digipolitan. All rights reserved.
//

import UIKit

class AnimatorBlurView: UIVisualEffectView {
	var backDrop: Bool = true
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		if self.backDrop {
			AnimatorManager.default.dismiss()
		}
		super.touchesEnded(touches, with: event)
	}
}
