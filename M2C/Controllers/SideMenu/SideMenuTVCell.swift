//
//  SideMenuTVCell.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 19/05/2022.
//

import UIKit

class SideMenuTVCell: UITableViewCell {

    @IBOutlet weak var imgRightArrow: UIImageView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var separator: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(title: String){
        self.lblTitle.text = title
    }

}
