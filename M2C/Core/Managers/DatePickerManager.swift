//
//  DatePickerManager.swift
//  Shopavize
//
//  Created by Abdul Samad on 19/05/2021.
//

import Foundation
import UIKit

class DatePickerManager: NSObject, UINavigationControllerDelegate {
    
    var pickDateCallback : ((Date) -> ())?
    
    override init(){
        super.init()
        
    }
    
    // Pick Image from Camera and gallery menu
    func pickDate(datePicker: UIDatePicker, _ callback: @escaping ((Date) -> ())) {
        pickDateCallback = callback
        
        let DP = UIDatePicker()
        DP.datePickerMode = UIDatePicker.Mode.date
        if #available(iOS 13.4, *) {
           datePicker.preferredDatePickerStyle = .wheels
        }
        
        DP.inputView?.backgroundColor = .white
        DP.addTarget(self, action: #selector(self.datePickerValueChanged(sender:)), for: .valueChanged)
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        self.pickDateCallback!(sender.date)
    }
}
