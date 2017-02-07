//
//  Toast.swift
//  Toast
//
//  Created by Julien Sarazin on 28/12/2016.
//  Copyright © 2016 Digipolitan. All rights reserved.
//

import UIKit
import DGDialogAnimator

class Toast: UIView {
	@IBOutlet weak var label: UILabel!

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		DGDialogAnimator.default.dismiss()
	}
}
