//
//  InputAlertController.swift
//  DGDialogAnimatorSample-iOS
//
//  Created by Julien Sarazin on 20/01/2017.
//  Copyright © 2017 Digipolitan. All rights reserved.
//

import UIKit
import DGDialogAnimator

class InputAlertController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		let blurEffect = UIBlurEffect(style: .light)

		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView.frame = self.view.bounds
		blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.view.insertSubview(blurEffectView, at: 0)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func dismiss(_ sender: Any) {
		DGDialogAnimator.default.dismiss()
	}
}
