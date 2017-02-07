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
	@IBOutlet weak var lblDuration: UILabel!
	@IBOutlet weak var lblHold: UILabel!

	var blurEffects: [UIBlurEffectStyle?] = [.light, .dark, .extraLight, nil]
	var options = DGDialogAnimator.Options()

    override func viewDidLoad() {
        super.viewDidLoad()
		options.backdrop = true
		options.blurEffectStyle = .dark
		self.lblDuration.text = "\(self.options.animationDuration)"
		self.lblHold.text = "\(self.options.dismissDelay)"
    }

	// MARK: Actions
	@IBAction func didChangeBackdrop(_ sender: Any) {
		self.options.backdrop = self.backdropSegment.selectedSegmentIndex == 0
	}

	@IBAction func didChangeBlurEffect(_ sender: Any) {
		self.options.blurEffectStyle = self.blurEffects[self.blurEffectSegment.selectedSegmentIndex]
		if options.blurEffectStyle == nil {
			self.blurIntensitySlider.value = 0
			self.blurIntensitySlider.isEnabled = false
		} else {
			self.blurIntensitySlider.isEnabled = true
		}
	}

	@IBAction func didChangeBlurIntensity(_ sender: Any) {
	}

	@IBAction func didChangeCoverStatusBar(_ sender: Any) {
		self.options.coverStatusBar = self.coverStatusBarSegment.selectedSegmentIndex == 0
	}

	@IBAction func didChangeAnimationDuration(_ sender: Any) {
		self.options.animationDuration = Double(self.animationDurationSlider.value)
		self.lblDuration.text = String(format: "%.2f", self.options.animationDuration)
	}

	@IBAction func didChangeHoldDuration(_ sender: Any) {
		self.options.dismissDelay = Double(self.holdDurationSlider.value)
		self.lblHold.text = String(format: "%.2f", self.options.dismissDelay)
	}

	@IBAction func didChangeIsWaiting(_ sender: Any) {
		self.options.hold = self.waitingSegment.selectedSegmentIndex == 0
		if self.options.hold {
			self.holdDurationSlider.isEnabled = false
			self.holdDurationSlider.value = 0
			self.options.dismissDelay = 0
		} else {
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
