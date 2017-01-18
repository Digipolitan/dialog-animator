//
//  ViewController.swift
//  Toast
//
//  Created by Julien Sarazin on 27/12/2016.
//  Copyright © 2016 Digipolitan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet weak var container: UIView!
	var toast: Toast!
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.toast = Bundle.main.loadNibNamed(String(describing: Toast.self), owner: self, options: nil)!.first as! Toast
		toast.label.text = "Something to notify"

		toast.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 65)

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func show(_ sender: Any) {
		var options = DGToastAnimator.Options()
		options.coverStatusBar = true
//		options.blur = .dark
		options.blurIntensity = 1
		options.waiting = true
//		options.backDrop = true
		options.hold = 3
		options.enterAnimationOptions = .curveEaseIn
		options.leaveAnimationOptions = .curveEaseOut
//		AnimatorManager.default.animate(view: self.toast, in: nil, with: options, initialPoint: CGPoint(x: 20, y: 800), finalPoint: CGPoint(x: 250, y: 100))
		DGToastAnimator.default.animate(view: self.toast, in: nil, with: options, from: [.top, .left], to: [.top, .right])
	}
}
