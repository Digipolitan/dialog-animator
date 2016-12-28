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

		toast.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 45)

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func show(_ sender: Any) {
		let options = AnimatorOptions()
		//options.coverStatusBar = true
		options.blur = .dark
		options.blurIntensity = 1
		options.waiting = true
		options.backDrop = true
		options.hold = 3
		AnimatorManager.default.animate(view: toast, in: self.view, with: options, from: .top)
	}
}
