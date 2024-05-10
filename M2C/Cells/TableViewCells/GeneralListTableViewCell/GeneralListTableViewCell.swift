//
//  GeneralListTableViewCell.swift
//  M2C
//
//  Created by Abdul Samad Butt on 14/11/2022.
//

import UIKit

class GeneralListTableViewCell: UITableViewCell {

    @IBOutlet weak var txtItemName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupCell(item: String){
        txtItemName.text = item
    }
    
    func setupCell(country: Country){
        txtItemName.text = "\(country.sortName?.showFlag() ?? "")   \(country.name ?? "")"
    }

}
