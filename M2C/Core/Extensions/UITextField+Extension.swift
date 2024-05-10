//
//  UITextField+Extension.swift
//  M2C
//
//  Created by Abdul Samad Butt on 26/07/2022.
//

import Foundation
import UIKit

extension UITextField {
    
    @IBInspectable var placeHolderColor: UIColor?{
        get { return self.placeHolderColor }
        set { self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!]) }
    }
    
    @IBInspectable var leftPadding: CGFloat{
        get {
            return leftView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }
    
    @IBInspectable var rightPadding: CGFloat {
        get {
            return rightView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }
    
    func setPlaceHolderColor(color:UIColor) {
        self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
    
    func addRedAsterik() {
        let text = self.placeholder ?? ""
        let textString = NSMutableAttributedString(string: text)
        let asterik = NSAttributedString(string: "*", attributes: [.foregroundColor: UIColor.red])
        textString.append(asterik)
        self.attributedPlaceholder = textString
    }
    
    func addPadding(leftPoints: Int, rightPoints: Int) {
        let paddingView : UIView = UIView()
        paddingView.frame = CGRect(x:0, y:0, width:leftPoints , height: Int(self.frame.size.height))
        paddingView.backgroundColor = .clear
        self.leftView = paddingView
        self.rightView = paddingView
        self.leftViewMode = .always
        self.tintColor = UIColor.fenrisBlue
        self.returnKeyType = .next
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: rightPoints, height: Int(self.frame.size.height)))
        rightPaddingView.backgroundColor = .clear
        self.rightView = rightPaddingView
        self.rightViewMode = .always
    }
    
    /* Input amount only cannot start form 0 */
    func inputAmountOnly(){
        self.keyboardType = .numberPad
        if self.text?.first == "0"{
            self.text = ""
        }
        if !self.text!.isEmpty{
            if  self.text!.last == "0" || self.text!.last == "1" || self.text!.last == "2" || self.text!.last == "3" || self.text!.last == "4" || self.text!.last == "5" || self.text!.last == "6" || self.text!.last == "7" || self.text!.last == "8" || self.text!.last == "9" {
                
            }else{
                self.text?.removeLast()
            }
        }
    }
    
    /* Input Numbers only can start form 0 */
    func inputNumbersOnly(){
        self.keyboardType = .numberPad
        if !self.text!.isEmpty{
            if  self.text!.last == "0" || self.text!.last == "1" || self.text!.last == "2" || self.text!.last == "3" || self.text!.last == "4" || self.text!.last == "5" || self.text!.last == "6" || self.text!.last == "7" || self.text!.last == "8" || self.text!.last == "9" {
                
            }else{
                self.text?.removeLast()
            }
        }
    }
}


class StopPasteActionTextField: UITextField {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}

