//
//  RecordingsTableViewHeader.swift
//  M2C
//
//  Created by Abdul Samad Butt on 09/09/2022.
//

import UIKit

class RecordingsTableViewHeader: UIView {

    @IBOutlet weak var txtTitle: UILabel!
    
    func setupHeader(title: String){
        txtTitle.text = title
    }
}
