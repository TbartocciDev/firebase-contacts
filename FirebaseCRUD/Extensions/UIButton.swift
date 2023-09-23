//
//  UIButton.swift
//  FirebaseCRUD
//
//  Created by Tommy Bartocci on 9/19/23.
//

import UIKit

extension UIButton {
    func enable() {
        self.backgroundColor = UIColor(named: "Main") ?? .red
        self.isEnabled = true
    }
    func disable() {
        self.backgroundColor = .systemGray5
        self.isEnabled = false
    }
}
