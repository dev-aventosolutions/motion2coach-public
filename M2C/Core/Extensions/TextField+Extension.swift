//
//  TextFieldExtension.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 10/05/2022.
//

import Foundation
import UIKit
private var __maxLengths = [UITextField: Int]()
extension UITextField {
    
    func setInputViewDatePicker(target: Any, selector: Selector, type : Int) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        if (type == 0) // for date only
        {
            datePicker.datePickerMode = .date //2
        }
        else if (type == 1) // for date and time
        {
            datePicker.datePickerMode = .dateAndTime //2
        }
        else if (type == 2) // for time only
        {
            datePicker.datePickerMode = .time //2
        }
        self.inputView = datePicker //3
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
    }
    
    
    func setInputViewDatePickerPreviousDate(target: Any, selector: Selector, type : Int) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        if (type == 0) // for date only
        {
            datePicker.datePickerMode = .date //2
        }
        else if (type == 1) // for date and time
        {
            datePicker.datePickerMode = .dateAndTime //2
        }
        else if (type == 2) // for time only
        {
            datePicker.datePickerMode = .time //2
        }
        self.inputView = datePicker //3
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.maximumDate = .yesterday
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
    }
    
    func setInputViewDatePickerWithMinMaxDate(target: Any, selector: Selector, type : Int,isNoFutureDate:Bool) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        
        
        
        
        if (type == 0) // for date only
        {
            if (!isNoFutureDate)
            {
                datePicker.minimumDate = Date()
            }
            else if isNoFutureDate
            {
                datePicker.maximumDate = Date()
            }
            
            datePicker.datePickerMode = .date //2
            
        }
        else if (type == 1) // for date and time
        {
            datePicker.datePickerMode = .dateAndTime //2
        }
        else if (type == 2) // for time only
        {
            datePicker.datePickerMode = .time
            if (!isNoFutureDate)
            {
                datePicker.minimumDate = Date()
            }
            else if isNoFutureDate
            {
                datePicker.maximumDate = Date()
            }
            
            //2
        }
        
        else if (type == 3) // for future years only
        {
            datePicker.datePickerMode = .date //2
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy"
            
            
        }
        
        self.inputView = datePicker //3
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
    
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
               return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = String((t?.prefix(maxLength))!)
    }
    
}




