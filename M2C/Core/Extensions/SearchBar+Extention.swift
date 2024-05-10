//
//  SearchBarExtention.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 10/05/2022.
//



import Foundation
import UIKit

extension UISearchBar {

    public var textField: UITextField? {
        if #available(iOS 13.0, *) {
            return self.searchTextField
        } else {
            let subViews = subviews.flatMap { $0.subviews }
            guard let textField = (subViews.filter { $0 is UITextField }).first as? UITextField else {
                return nil
            }
            return textField
        }
    }

    public var activityIndicator: UIActivityIndicatorView? {
        return textField?.leftView?.subviews.compactMap{ $0 as? UIActivityIndicatorView }.first
    }

    var isLoading: Bool {
        get {
            return activityIndicator != nil
        } set {
            if newValue {
                if activityIndicator == nil {
                    let newActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
                    newActivityIndicator.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                    newActivityIndicator.startAnimating()
                    
                    newActivityIndicator.backgroundColor = UIColor.clear
                    textField?.rightView?.addSubview(newActivityIndicator)
                    let leftViewSize = textField?.leftView?.frame.size ?? CGSize.zero
                    newActivityIndicator.center = CGPoint(x: leftViewSize.width/2, y: leftViewSize.height/2)
                }
            } else {
                activityIndicator?.removeFromSuperview()
            }
        }
    }
}
