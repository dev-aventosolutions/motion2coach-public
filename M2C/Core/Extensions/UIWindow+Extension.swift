//
//  UIWindow+Extension.swift
//  M2C
//
//  Created by Abdul Samad Butt on 22/07/2022.
//

import Foundation
import UIKit

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
