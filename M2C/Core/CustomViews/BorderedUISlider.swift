//
//  BorderedUISlider.swift
//  M2C
//
//  Created by Abdul Samad Butt on 17/01/2023.
//

import Foundation
import UIKit

final class BorderedUISlider: UISlider {
    private var sliderBorder: CALayer = {
        let layer = CALayer()
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        return layer
    }()
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var result = super.trackRect(forBounds: bounds)
        result.origin.x = 0
        result.size.width = bounds.size.width
        result.size.height = 10 //added height for desired effect
        return result
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let rect = trackRect(forBounds: bounds)
        sliderBorder.removeFromSuperlayer()
        sliderBorder.frame = rect
        sliderBorder.cornerRadius = rect.height / 2
        layer.addSublayer(sliderBorder)
    }
    
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        return super.thumbRect(forBounds:
            bounds, trackRect: rect, value: value)
            .offsetBy(dx: 0/*Set_0_value_to_center_thumb*/, dy: 0)
    }
}
