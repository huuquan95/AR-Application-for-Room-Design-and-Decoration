//
//  FloatingActionButton.swift
//  UIApp
//
//  Created by Darick on 3/9/18.
//  Copyright © 2018 Darick. All rights reserved.
//

import UIKit
class FloatingActionButton: UIButtonX {

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        UIView.animate(withDuration: 0.3, animations: {
            if self.transform == .identity{
                self.transform = CGAffineTransform(rotationAngle: 135 * (.pi/180))
                
            }
            else{
                self.transform = .identity
            }
        })
        return super.beginTracking(touch, with: event)
    }

}
