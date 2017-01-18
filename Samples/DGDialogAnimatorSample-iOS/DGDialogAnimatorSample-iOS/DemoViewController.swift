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
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.toast = Bundle.main.loadNibNamed(String(describing: Toast.self), owner: self, options: nil)?.first as? Toast
		self.toast.frame.size = CGSize(width: self.view.bounds.width, height: 100)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	@IBAction func didTouchOnShow(_ sender: Any) {
		let container: UIView? = (self.options?.coverStatusBar ?? false) ? nil : self.view
		DGDialogAnimator.default.animate(view: self.toast, in: container, with: self.options, from: .top, to: .top)
	}

	@IBAction func didTouchOnInfo(_ sender: Any){
		guard let controller = self.navigationController?.viewControllers.first else {
			return
		}

		DGDialogAnimator.default.animate(view: controller.view, in: self.view, with: nil, from: .bottom)
	}
}
