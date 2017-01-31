//
//  ControlCenterTableViewController.swift
//
//
//  Created by Julien Sarazin on 19/01/2017.
//
//

import UIKit
import DGDialogAnimator

class ControlCenterViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!

	var actions: [IndexPath: (Void) -> (Void)] = [:]
	var confirmAlertController = ConfirmAlertController()
	var yesNoAlertController = YesNoAlertController()
	var intputAlertController = InputAlertController()
	var modalController = ModalController()

	let entries: [Int: [String]] = [
		0: [
			"Success",
			"Error",
			"Info",
			"Warning",
			"Custom"
		],
		1: [ "Confirm", "Yes/No", "Input"],
		2: [ "Light"]
	]

	override func viewDidLoad() {
		super.viewDidLoad()
		self.tableView.delegate = self
		self.tableView.dataSource = self

		var options = DGDialogAnimator.Options(dismissDelay: 5)

		self.actions = [
			IndexPath(row: 0, section: 0): { _ in
				options.hold = false
				options.dismissDelay = 5
				options.backdrop = false
				options.blurEffectStyle = nil

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
				options.hold = false
				options.backdrop = false
				options.blurEffectStyle = nil

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
				options.hold = false
				options.backdrop = false
				options.blurEffectStyle = nil

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
				options.hold = false
				options.backdrop = false
				options.blurEffectStyle = nil

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
				options.hold = true
				options.blurEffectStyle = nil

				self.tableView.isScrollEnabled = false
				self.confirmAlertController.view.frame.size = CGSize(width: self.view.bounds.width - 50, height: 200)
				DGDialogAnimator.default.animate(view: self.confirmAlertController.view, in: self.view, with: options, from: .bottom) {
					self.tableView.isScrollEnabled = true
				}
			},
			IndexPath(row: 1, section: 1): { _ in
				options.hold = true
				options.blurEffectStyle = nil

				self.tableView.isScrollEnabled = false
				self.yesNoAlertController.view.frame.size = CGSize(width: self.view.bounds.width - 50, height: 200)
				DGDialogAnimator.default.animate(view: self.yesNoAlertController.view, in: self.view, with: options, from: .bottom) {
					self.tableView.isScrollEnabled = true
				}
			},
			IndexPath(row: 2, section: 1): { _ in
				options.hold = true
				options.blurEffectStyle = nil

				self.tableView.isScrollEnabled = false
				self.intputAlertController.view.frame.size = CGSize(width: self.view.bounds.width - 50, height: 200)
				DGDialogAnimator.default.animate(view: self.intputAlertController.view, in: self.view, with: options, from: .bottom) {
					self.tableView.isScrollEnabled = true
				}
			},
			IndexPath(row: 0, section: 2): { _ in
				options.hold = true
				options.backdrop = true
				options.blurEffectStyle = .dark

				self.tableView.isScrollEnabled = false
				self.modalController.view.frame.size = CGSize(width: self.view.bounds.width - 20, height: 450)
				self.modalController.view.layer.cornerRadius = 5
				DGDialogAnimator.default.animate(view: self.modalController.view, in: self.view, with: options, from: .bottom, to: .bottom) {
					self.tableView.isScrollEnabled = true
				}
			}
		]
	}
}

extension ControlCenterViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return self.entries.count
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.entries[section]!.count
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return "Toasts"
		}
		if section == 1 {
			return "Alerts"
		}
		return "Modals"
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")!

		if indexPath.section == 0 && indexPath.row == 4 {
			cell.accessoryType = .disclosureIndicator
		}

		cell.textLabel?.text = self.entries[indexPath.section]?[indexPath.row]
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 0 && indexPath.row == 4 {
			self.performSegue(withIdentifier: "configuration", sender: nil)
		}

		guard let action = self.actions[indexPath] else {
			return
		}

		action()
	}
}
