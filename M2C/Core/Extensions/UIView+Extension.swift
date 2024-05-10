//
//  ViewExtension.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 10/05/2022.
//

import Foundation
import UIKit

//MARK: IBInspectable Extension
extension UIView {
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 5
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func addShadow(){
        
    }
    
    @IBInspectable var rotationDegrees: Float {
        get {
            let angle = NSNumber(value: self.rotationDegrees / 180.0 * Float.pi)
            layer.setValue(angle, forKeyPath: "transform.rotation.z")
            self.layoutIfNeeded()
            return self.rotationDegrees
        } set{
            let angle = NSNumber(value: newValue / 180.0 * Float.pi)
            layer.setValue(angle, forKeyPath: "transform.rotation.z")
            self.layoutIfNeeded()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
//            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var topLeft: Bool {
        get { return layer.maskedCorners.contains(.layerMinXMinYCorner) }
        set {
            if newValue { layer.maskedCorners.insert(.layerMinXMinYCorner) }
            else { layer.maskedCorners.remove(.layerMinXMinYCorner) }
        }
    }
    
    @IBInspectable var bottomLeft: Bool {
        get { return layer.maskedCorners.contains(.layerMinXMaxYCorner) }
        set {
            if newValue { layer.maskedCorners.insert(.layerMinXMaxYCorner) }
            else { layer.maskedCorners.remove(.layerMinXMaxYCorner) }
        }
    }
    
    @IBInspectable var topRight: Bool {
        get { return layer.maskedCorners.contains(.layerMaxXMinYCorner) }
        set {
            if newValue { layer.maskedCorners.insert(.layerMaxXMinYCorner) }
            else { layer.maskedCorners.remove(.layerMaxXMinYCorner) }
        }
    }
    
    @IBInspectable var bottomRight: Bool {
        get { return layer.maskedCorners.contains(.layerMaxXMaxYCorner) }
        set {
            if newValue { layer.maskedCorners.insert(.layerMaxXMaxYCorner) }
            else { layer.maskedCorners.remove(.layerMaxXMaxYCorner) }
        }
    }
    
    @IBInspectable var rotate: Bool {
        get { return true }
        set {
            if newValue { rotateView() }
            else { print("false") }
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    @IBInspectable var shadowOpacity: CGFloat {
        get { return CGFloat(layer.shadowOpacity) }
        set { layer.shadowOpacity = Float(newValue) }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let cgColor = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: cgColor)
        }
        set { layer.shadowColor = newValue?.cgColor }
    }
}

extension UIView{
    
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func rotateView() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func round() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height/2
    }
    
    func roundCorners(topLeft: Bool, topRight: Bool, bottomLeft: Bool, bottomRight: Bool){
        var corners: CACornerMask = CACornerMask()
        if topLeft{
            corners.insert(.layerMinXMinYCorner)
        }
        if topRight{
            corners.insert(.layerMaxXMinYCorner)
        }
        if bottomLeft{
            corners.insert(.layerMinXMaxYCorner)
        }
        if bottomRight{
            corners.insert(.layerMaxXMaxYCorner)
        }
        
        layer.maskedCorners = corners
    }
    
    func drawBorder(color: UIColor, width: CGFloat){
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func roundUpperCorners(corner:CGFloat!){
        self.layer.cornerRadius = corner
        self.clipsToBounds = false
        self.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }
    
    func animateFulView(duration: TimeInterval){
        UIView.animate(withDuration: duration) {
            self.layoutIfNeeded()
        }
    }
    
    func hideWithAnimation() {
        UIView.transition(with: self, duration: 0.4, options: .curveEaseOut, animations: {
            self.hide()
        })
    }
    
    func showWithAnimation() {
        UIView.transition(with: self, duration: 0.5, options: .curveLinear, animations: {
            self.unhide()
        })
    }
    
    func hide(){
//        DispatchQueue.main.async {
            self.isHidden = true
//        }
    }
    
    func unhide(){
        DispatchQueue.main.async {
            self.isHidden = false
        }
    }
    
    func show(){
//        DispatchQueue.main.async {
            self.isHidden = false
//        }
    }
    
    func addshadow(top: Bool, left: Bool, bottom: Bool, right: Bool, shadowRadius: CGFloat) {
        
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = UIColor.lightGray.cgColor
        let path = UIBezierPath()
        var x: CGFloat = 0
        var y: CGFloat = 0
        var viewWidth = self.frame.width
        var viewHeight = self.frame.height
        
        // here x, y, viewWidth, and viewHeight can be changed in
        // order to play around with the shadow paths.
        if (!top) {
            y+=(shadowRadius+1)
        }
        if (!bottom) {
            viewHeight-=(shadowRadius+1)
        }
        if (!left) {
            x+=(shadowRadius+1)
        }
        if (!right) {
            viewWidth-=(shadowRadius+1)
        }
        // selecting top most point
        path.move(to: CGPoint(x: x, y: y))
        // Move to the Bottom Left Corner, this will cover left edges
        /*
         |☐
         */
        path.addLine(to: CGPoint(x: x, y: viewHeight))
        // Move to the Bottom Right Corner, this will cover bottom edge
        /*
         ☐
         -
         */
        path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        // Move to the Top Right Corner, this will cover right edge
        /*
         ☐|
         */
        path.addLine(to: CGPoint(x: viewWidth, y: y))
        // Move back to the initial point, this will cover the top edge
        /*
         _
         ☐
         */
        path.close()
        self.layer.shadowPath = path.cgPath
    }
    
    func applyShadow(shadowColor: UIColor, shadowRadius: CGFloat){
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset =  CGSize.zero
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = shadowRadius
    }
    
    //    func applyShadow(shadowColor: UIColor, shadowRadius: CGFloat){
    //        self.layer.masksToBounds = false
    //        self.layer.shouldRasterize = true
    //        self.layer.rasterizationScale = UIScreen.main.scale
    //        self.layer.shadowColor = shadowColor.cgColor
    //        self.layer.shadowPath = CGPath(rect: self.bounds, transform: nil)
    //        self.layer.shadowOffset = CGSize(width: 10, height: 10)
    //        self.layer.shadowRadius = shadowRadius
    //        self.layer.shadowOpacity = 0.3
    //    }
    
    func takeScreenshot() -> UIImage {
        
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
    
    func showAnimate()
    {
        self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1.0
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.removeFromSuperview()
            }
        });
    }
    
    func shake(){
        UIDevice.vibrate()
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.08
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 5, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 5, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    
    //MARK: GRADIENT
    enum axis {
        case vertical, horizontal, custom(angle: CGFloat)
    }
    
    func setGradientBackgroundColor(colors: [UIColor], axis: axis, cornerRadius: CGFloat? = nil, apply: ((UIView) -> ())? = nil) {
        layer.sublayers?.filter { $0.name == "gradientLayer" }.forEach { $0.removeFromSuperlayer() }
        self.layoutIfNeeded()
        
        let cgColors = colors.map { $0.cgColor }
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = cgColors
        gradient.name = "gradientLayer"
        gradient.locations = [0.0, 1.0]
        
        switch axis {
        case .horizontal:
            gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        case .custom(let angle):
            calculatePoints(for: angle, gradient: gradient)
        default:
            break
        }
        
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
        
        guard let cornerRadius = cornerRadius else { return }
        
        let circularPath = CGMutablePath()
        
        circularPath.move(to: CGPoint.init(x: cornerRadius, y: 0))
        circularPath.addLine(to: CGPoint.init(x: self.bounds.width - cornerRadius, y: 0))
        circularPath.addQuadCurve(to: CGPoint.init(x: self.bounds.width, y: cornerRadius), control: CGPoint.init(x: self.bounds.width, y: 0))
        circularPath.addLine(to: CGPoint.init(x: self.bounds.width, y: self.bounds.height - cornerRadius))
        circularPath.addQuadCurve(to: CGPoint.init(x: self.bounds.width - cornerRadius, y: self.bounds.height), control: CGPoint.init(x: self.bounds.width, y: self.bounds.height))
        circularPath.addLine(to: CGPoint.init(x: cornerRadius, y: self.bounds.height))
        circularPath.addQuadCurve(to: CGPoint.init(x: 0, y: self.bounds.height - cornerRadius), control: CGPoint.init(x: 0, y: self.bounds.height))
        circularPath.addLine(to: CGPoint.init(x: 0, y: cornerRadius))
        circularPath.addQuadCurve(to: CGPoint.init(x: cornerRadius, y: 0), control: CGPoint.init(x: 0, y: 0))
        
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = circularPath
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        maskLayer.fillColor = UIColor.red.cgColor
        self.layer.mask = maskLayer
        
        apply?(self)
    }
    
    func calculatePoints(for angle: CGFloat, gradient: CAGradientLayer) {
        
        var ang = (-angle).truncatingRemainder(dividingBy: 360)
        if ang < 0 { ang = 360 + ang }
        let n: CGFloat = 0.5
        
        switch ang {
        case 0...45, 315...360:
            let a = CGPoint(x: 0, y: n * tanx(ang) + n)
            let b = CGPoint(x: 1, y: n * tanx(-ang) + n)
            gradient.startPoint = a
            gradient.endPoint = b
        case 45...135:
            let a = CGPoint(x: n * tanx(ang - 90) + n, y: 1)
            let b = CGPoint(x: n * tanx(-ang - 90) + n, y: 0)
            gradient.startPoint = a
            gradient.endPoint = b
        case 135...225:
            let a = CGPoint(x: 1, y: n * tanx(-ang) + n)
            let b = CGPoint(x: 0, y: n * tanx(ang) + n)
            gradient.startPoint = a
            gradient.endPoint = b
        case 225...315:
            let a = CGPoint(x: n * tanx(-ang - 90) + n, y: 0)
            let b = CGPoint(x: n * tanx(ang - 90) + n, y: 1)
            gradient.startPoint = a
            gradient.endPoint = b
        default:
            let a = CGPoint(x: 0, y: n)
            let b = CGPoint(x: 1, y: n)
            gradient.startPoint = a
            gradient.endPoint = b
            
        }
    }
    
    private func tanx(_ 𝜽: CGFloat) -> CGFloat {
        return tan(𝜽 * CGFloat.pi / 180)
    }
    
    //MARK: Blur Effects
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.alpha = 0.99
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
    
    func removeBlurEffect() {
        let blurredEffectViews = self.subviews.filter{$0 is UIVisualEffectView}
        blurredEffectViews.forEach{ blurView in
            blurView.removeFromSuperview()
        }
    }
}
