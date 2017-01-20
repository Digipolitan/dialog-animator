//
//  ControlCenterTableViewController.swift
//
//
//  Created by Julien Sarazin on 19/01/2017.
//
//

import UIKit
import DGDialogAnimator

class ControlCenterTableViewController: UITableViewController {
	var actions: [IndexPath: (Void) -> (Void)] = [:]
	var confirmAlertController = ConfirmAlertController()
	var yesNoAlertController = YesNoAlertController()
	var intputAlertController = InputAlertController()

	override func viewDidLoad() {
		super.viewDidLoad()



		var options = DGDialogAnimator.Options(coverStatusBar: false, hold: 5, duration: 0.3, options: .curveEaseIn)
		options.backDrop = true
		options.blurEffect = nil

		self.actions = [
			IndexPath(row: 0, section: 0): { _ in
				options.waiting = false
				guard let toast = Bundle.main.loadNibNamed(String(describing: Toast.self), owner: self, options: nil)?.first as? Toast else {
					return
				}

				toast.frame.size = CGSize(width: self.view.bounds.width, height: 50)
				toast.backgroundColor = UIColor(colorLiteralRed: 185/255,
				                                green: 200/255,
				                                blue: 162/255,
				                                alpha: 1)

				toast.label.text = "Congratulations! You succeeded in something!"
				DGDialogAnimator.default.animate(view: toast, in: self.view, with: options, from: .top, to: .top)
			},
			IndexPath(row: 1, section: 0): { _ in
				options.waiting = false
				guard let toast = Bundle.main.loadNibNamed(String(describing: Toast.self), owner: self, options: nil)?.first as? Toast else {
					return
				}

				toast.frame.size = CGSize(width: self.view.bounds.width, height: 50)
				toast.backgroundColor = UIColor(colorLiteralRed: 225/255,
				                                green: 109/255,
				                                blue: 91/255,
				                                alpha: 1)
				toast.label.text = "Error during the thing you tried to do."
				DGDialogAnimator.default.animate(view: toast, in: self.view, with: options, from: .top, to: .top)
			},
			IndexPath(row: 2, section: 0): { _ in
				options.waiting = false
				guard let toast = Bundle.main.loadNibNamed(String(describing: Toast.self), owner: self, options: nil)?.first as? Toast else {
					return
				}

				toast.frame.size = CGSize(width: self.view.bounds.width, height: 50)
				toast.backgroundColor = UIColor(colorLiteralRed: 151/255,
				                                green: 186/255,
				                                blue: 232/255,
				                                alpha: 1)
				toast.label.text = "You received a new message. Check your inbox"
				DGDialogAnimator.default.animate(view: toast, in: self.view, with: options, from: .top, to: .top)
			},
			IndexPath(row: 3, section: 0): { _ in
				options.waiting = false
				guard let toast = Bundle.main.loadNibNamed(String(describing: Toast.self), owner: self, options: nil)?.first as? Toast else {
					return
				}

				toast.frame.size = CGSize(width: self.view.bounds.width, height: 50)
				toast.backgroundColor = UIColor(colorLiteralRed: 240/255,
				                                green: 221/255,
				                                blue: 130/255,
				                                alpha: 1)
				toast.label.text = "Disconnected from the server. Modifications won't be saved"
				DGDialogAnimator.default.animate(view: toast, in: self.view, with: options, from: .top, to: .top)
			},
			IndexPath(row: 0, section: 1): { _ in
				options.waiting = true
				self.tableView.isScrollEnabled = false
				self.confirmAlertController.view.frame.size = CGSize(width: self.view.bounds.width - 50, height: 200)
				DGDialogAnimator.default.animate(view: self.confirmAlertController.view, in: self.view, with: options, from: .bottom) {
					self.tableView.isScrollEnabled = true
				}
			},
			IndexPath(row: 1, section: 1): { _ in
				options.waiting = true
				self.tableView.isScrollEnabled = false
				self.yesNoAlertController.view.frame.size = CGSize(width: self.view.bounds.width - 50, height: 200)
				DGDialogAnimator.default.animate(view: self.yesNoAlertController.view, in: self.view, with: options, from: .bottom) {
					self.tableView.isScrollEnabled = true
				}
			},
			IndexPath(row: 2, section: 1): { _ in
				options.waiting = true
				self.tableView.isScrollEnabled = false
				self.intputAlertController.view.frame.size = CGSize(width: self.view.bounds.width - 50, height: 200)
				DGDialogAnimator.default.animate(view: self.intputAlertController.view, in: self.view, with: options, from: .bottom) {
					self.tableView.isScrollEnabled = true
				}
			}
		]
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let action = self.actions[indexPath] else {
			return
		}
		
		action()
	}
	
}
