//
//  DemoViewController.swift
//  DGDialogAnimatorSample-iOS
//
//  Created by Julien Sarazin on 18/01/2017.
//  Copyright © 2017 Digipolitan. All rights reserved.
//

import UIKit
import DGDialogAnimator

class ConfigurationViewController: UIViewController {
	@IBOutlet weak var backdropSegment: UISegmentedControl!
	@IBOutlet weak var blurEffectSegment: UISegmentedControl!
	@IBOutlet weak var blurIntensitySlider: UISlider!
	@IBOutlet weak var coverStatusBarSegment: UISegmentedControl!
	@IBOutlet weak var animationDurationSlider: UISlider!
	@IBOutlet weak var holdDurationSlider: UISlider!
	@IBOutlet weak var waitingSegment: UISegmentedControl!

	var blurEffects: [UIBlurEffectStyle?] = [.light, .dark, .extraLight, nil]
	var options = DGDialogAnimator.Options()

    override func viewDidLoad() {
        super.viewDidLoad()
		options.backDrop = true
		options.blurEffect = .dark
		options.blurIntensity = 1.0
		options.coverStatusBar = false
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	// MARK: Actions
	@IBAction func didChangeBackdrop(_ sender: Any) {
		self.options.backDrop = self.backdropSegment.selectedSegmentIndex == 0
	}

	@IBAction func didChangeBlurEffect(_ sender: Any) {
		self.options.blurEffect = self.blurEffects[self.blurEffectSegment.selectedSegmentIndex]
		if options.blurEffect == nil {
			options.blurIntensity = 0
			self.blurIntensitySlider.value = 0
			self.blurIntensitySlider.isEnabled = false
		}
		else {
			self.blurIntensitySlider.isEnabled = true
		}
	}

	@IBAction func didChangeBlurIntensity(_ sender: Any) {
		self.options.blurIntensity = CGFloat(self.blurIntensitySlider.value)
	}

	@IBAction func didChangeCoverStatusBar(_ sender: Any) {
		self.options.coverStatusBar = self.coverStatusBarSegment.selectedSegmentIndex == 0
	}

	@IBAction func didChangeAnimationDuration(_ sender: Any) {
		self.options.duration = Double(self.animationDurationSlider.value)
	}

	@IBAction func didChangeHoldDuration(_ sender: Any) {
		self.options.hold = Double(self.holdDurationSlider.value)
	}

	@IBAction func didChangeIsWaiting(_ sender: Any) {
		self.options.waiting = self.waitingSegment.selectedSegmentIndex == 0
		if self.options.waiting {
			self.holdDurationSlider.isEnabled = false
			self.holdDurationSlider.value = 0
			self.options.hold = 0
		}
		else {
			self.holdDurationSlider.isEnabled = true
		}
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let controller: PositionViewController = segue.destination as? PositionViewController else {
			return
		}

		controller.options = self.options
	}
}
