//
//  CapturePerDateTableViewHeader.swift
//  M2C
//
//  Created by Abdul Samad Butt on 19/09/2022.
//

import Foundation
import UIKit

class CapturePerDateTableViewHeader: UIView{
    
    @IBOutlet weak var txtTitle: UILabel!
    
    
    func setupHeader(num: Int){
        txtTitle.text = "Recordings: \(num)"
    }
}
