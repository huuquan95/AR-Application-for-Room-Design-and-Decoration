//
//  OptionActionButton.swift
//  AR Application for Room Design and Decoration
//
//  Created by Darick on 3/29/18.
//  Copyright © 2018 Quan (Quinto) H. DINH. All rights reserved.
//

import UIKit

class OptionActionButton: UIButton {

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        UIView.animate(withDuration: 0.3, animations: {
            if self.transform == .identity{
                self.transform = CGAffineTransform(rotationAngle: 135 * (.pi / 180))
            }
            else{
                self.transform = .identity
            }
        })
        return super.beginTracking(touch, with: event)
    }

}
