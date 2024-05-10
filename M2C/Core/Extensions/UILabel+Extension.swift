//
//  UILabel+Extension.swift
//  M2C
//
//  Created by Abdul Samad Butt on 22/07/2022.
//

import Foundation
import UIKit

extension UILabel{
    
    func startBlink() {
        UIView.animate(withDuration: 0.8,
                       delay:0.0,
                       options:[.allowUserInteraction, .curveEaseInOut, .autoreverse, .repeat],
                       animations: { self.alpha = 0 },
                       completion: nil)
    }
    
    func stopBlink() {
        layer.removeAllAnimations()
        alpha = 1
    }
    
    func setText(text:String,size:CGFloat){
        self.text = text
        self.font = UIFont(name: "Flexo-Regular", size: size)
    }
    
    func setHeaderTitle(text:String){
        self.text = text
        self.textAlignment = .center
        self.font = UIFont(name: "FlexoW01-Bold", size: 22)
    }
    
    func setFormatText(text:String!,isError:Bool,txtFld:UITextField, isPreLogin: Bool? = false){
        self.text = text
        self.textAlignment = .left
        
        if isPreLogin!{
            self.font = UIFont(name: "Flexo-Regular", size: 11)
        }else{
            self.font = UIFont(name: "Flexo-Regular", size: 11)
        }
        
        if isError{
            
        }else{
            
            self.textColor = UIColor.black
        }
        
    }
    
    var isTruncated: Bool {
        
        guard let labelText = text else {
            return false
        }
        
        let labelTextSize = (labelText as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil).size
        
        return labelTextSize.height > bounds.size.height
    }
    
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
    
    func setTextWithTypeAnimation(typedText: String, characterDelay: TimeInterval = 7.0, completion: @escaping(()->())) {
        text = ""
        var writingTask: DispatchWorkItem?
        writingTask = DispatchWorkItem { [weak weakSelf = self] in
            for character in typedText {
                DispatchQueue.main.async {
                    weakSelf?.text!.append(character)
                }
                Thread.sleep(forTimeInterval: characterDelay/100)
            }
            Thread.sleep(forTimeInterval: 5)
            completion()
        }
        
        if let task = writingTask {
            let queue = DispatchQueue(label: "typespeed", qos: DispatchQoS.userInteractive)
            queue.asyncAfter(deadline: .now() + 0.05, execute: task)
            
        }
    }
}
