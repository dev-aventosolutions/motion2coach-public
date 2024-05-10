//
//  UIButton+Extension.swift
//  M2C
//
//  Created by Abdul Samad Butt on 22/07/2022.
//

import Foundation
import UIKit

extension UIButton{
    
    func setGradientBackground(colors: [UIColor], axis: axis, cornerRadius: CGFloat) {
        self.setGradientBackgroundColor(colors: colors, axis: axis, cornerRadius: cornerRadius) { view in
            guard let btn = view as? UIButton, let imageView = btn.imageView else { return }
            btn.bringSubviewToFront(imageView) // To display imageview of button
        }
    }
    
    func makeButtonActive(){
        self.isUserInteractionEnabled = true
        self.titleLabel?.textColor = .white
        self.backgroundColor = .fenrisBlue
    }
    
    func makeButtonDeactive(){
        self.isUserInteractionEnabled = false
        self.titleLabel?.textColor = .white
        self.backgroundColor = UIColor.buttonDeactiveColor
    }
    
    func makePlayerTypeButtonDeactive(){
        self.setTitleColor(.fenrisGrey, for: .normal)
        self.backgroundColor = UIColor.clear
    }
    
    func makePlayerTypeButtonActive(){
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = UIColor.fenrisBlue
    }
    
    func centerButtonImageAndTitle() {
        let titleSize = self.titleLabel?.frame.size ?? .zero
        let imageSize = self.imageView?.frame.size  ?? .zero
        let spacing: CGFloat = 6.0
        self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing),left: 0, bottom: 0, right:  -titleSize.width)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0)
    }
}

@IBDesignable extension UIButton {
    
    @IBInspectable var vertical: Bool {
        set {
            if newValue == true{
                centerButtonImageAndTitle()
            }
        }
        get {
            return true
        }
    }
}

