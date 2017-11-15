//
//  DialogWindow.swift
//  DGDialogAnimator
//
//  Created by Benoit BRIATTE on 06/02/2017.
//  Copyright © 2017 Digipolitan. All rights reserved.
//

import UIKit

class DialogWindow: UIWindow {

    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard self.subviews.count == 2 else { // include UIViewController view and dialog
            return super.point(inside: point, with: event)
        }
        let dialog = self.subviews[1]
        return dialog.frame.contains(point)
    }
}
