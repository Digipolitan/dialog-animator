//
//  DemoViewController.swift
//  DGDialogAnimatorSample-iOS
//
//  Created by Julien Sarazin on 18/01/2017.
//  Copyright © 2017 Digipolitan. All rights reserved.
//

import UIKit
import DGDialogAnimator

class DemoViewController: UIViewController {
	var toast: Toast!
	var options: DGDialogAnimator.Options?
	var from: DGDialogAnimator.Position?
	var to: DGDialogAnimator.Position?

    override func viewDidLoad() {
        super.viewDidLoad()
		self.toast = Bundle.main.loadNibNamed(String(describing: Toast.self), owner: self, options: nil)?.first as? Toast
		self.toast.frame.size = CGSize(width: self.view.bounds.width, height: 80)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	@IBAction func didTouchShow(_ sender: Any) {
		print("self.options: \(self.options)")
		let container: UIView? = (self.options?.coverStatusBar ?? false) ? nil : self.view
        DGDialogAnimator.default.animate(view: self.toast, in: container, with: self.options, path: DGDialogAnimator.AnimationPath(initial: from!, intermediate: to!))
	}
}
