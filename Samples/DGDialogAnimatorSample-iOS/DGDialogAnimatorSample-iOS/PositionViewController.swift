//
//  InitialPositionViewController.swift
//  DGDialogAnimatorSample-iOS
//
//  Created by Julien Sarazin on 19/01/2017.
//  Copyright © 2017 Digipolitan. All rights reserved.
//

import UIKit
import DGDialogAnimator

class PositionViewController: UIViewController {
	@IBOutlet var btns: [UIButton]!
	var options: DGDialogAnimator.Options?
	var initialPosition: DGDialogAnimator.Position = .top
	var finalPosition: DGDialogAnimator.Position = .top

	var position: DGDialogAnimator.Position {
		get {
			return title == "Initial Position" ? self.initialPosition : self.finalPosition
		}
		set {
			if self.title == "Initial Position" {
				self.initialPosition = newValue
			}
			else {
				self.finalPosition = newValue
			}
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "to" {
			let controller = segue.destination as? PositionViewController
			controller!.initialPosition = self.initialPosition
			controller!.options = self.options
		}
		else {
			let controller = segue.destination as? DemoViewController
			controller!.from = self.initialPosition
			controller!.to = self.finalPosition
			controller!.options = self.options
		}
	}

	func setBackgroundFromSelection(button: UIButton) {
		self.btns.forEach { (btn) in
			if btn == button {
				btn.backgroundColor = UIColor(colorLiteralRed: 255/255, green: 109/255, blue: 91/255, alpha: 1)
			}
			else {
				btn.backgroundColor = UIColor(colorLiteralRed: 78/255, green: 170/255, blue: 173/255, alpha: 1)
			}
		}
	}

	@IBAction func selectedTop(_ sender: UIButton) {
		self.position = .top
		self.setBackgroundFromSelection(button: sender)
	}

	@IBAction func selectedTopRight(_ sender: UIButton) {
		self.position = [.top, .right]
		self.setBackgroundFromSelection(button: sender)
	}

	@IBAction func selectedRight(_ sender: UIButton) {
		self.position = .right
		self.setBackgroundFromSelection(button: sender)
	}

	@IBAction func selectedBottomRight(_ sender: UIButton) {
		self.position = [.bottom, .right]
		self.setBackgroundFromSelection(button: sender)
	}

	@IBAction func selectedBottom(_ sender: UIButton) {
		self.position = .bottom
		self.setBackgroundFromSelection(button: sender)
	}

	@IBAction func selectedBottomLeft(_ sender: UIButton) {
		self.position = [.bottom, .left]
		self.setBackgroundFromSelection(button: sender)
	}

	@IBAction func selectedLeft(_ sender: UIButton) {
		self.position = .left
		self.setBackgroundFromSelection(button: sender)
	}

	@IBAction func selectedTopLeft(_ sender: UIButton) {
		self.position = [.top, .left]
		self.setBackgroundFromSelection(button: sender)
	}

}

