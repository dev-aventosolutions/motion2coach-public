//
//  UISegmentControl+Extension.swift
//  M2C
//
//  Created by Abdul Samad Butt on 28/11/2022.
//

import Foundation
import UIKit

extension UISegmentedControl {
    
    func defaultConfiguration(font: UIFont = UIFont.systemFont(ofSize: 12), color: UIColor = UIColor.gray) {
        let defaultAttributes : [NSAttributedString.Key : Any] = [
            .foregroundColor : color,
            .font : font
        ]
        
        setTitleTextAttributes(defaultAttributes, for: .normal)
    }
    
    func selectedConfiguration(font: UIFont = UIFont.boldSystemFont(ofSize: 12), color: UIColor = UIColor.white) {
        let selectedAttributes : [NSAttributedString.Key : Any] = [
            .foregroundColor : color,
            .font : font
        ]
        
        setTitleTextAttributes(selectedAttributes, for: .selected)
    }
}
