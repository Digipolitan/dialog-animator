//
//  Toast.swift
//  Toast
//
//  Created by Julien Sarazin on 28/12/2016.
//  Copyright © 2016 Digipolitan. All rights reserved.
//

import UIKit

class Toast: UIView {

	@IBOutlet weak var label: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */


	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		AnimatorManager.default.dismiss()
	}
}
