//
//  CoachListTableViewCell.swift
//  M2C
//
//  Created by Abdul Samad Butt on 22/12/2022.
//

import UIKit

protocol CoachProtocol: AnyObject{
    func acceptCoach(coach: Coach)
    func rejectCoach(coach: Coach)
}

class CoachListTableViewCell: UITableViewCell {

    //MARK: OUTLETS
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgCoach: UIImageView!
    @IBOutlet weak var txtCoachName: UILabel!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnReject: UIButton!
    
    //MARK: VARIABLES
    var delegate: CoachProtocol?
    var coach: Coach = Coach()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func setupCell(coach: Coach, status: String){
        viewMain.layer.cornerRadius = 10
        viewMain.layer.shadowColor = UIColor.gray.cgColor
        viewMain.layer.shadowOpacity = 0.3
        viewMain.layer.shadowOffset = CGSize.zero
        viewMain.layer.shadowRadius = 5
        viewMain.layer.masksToBounds = false
        
        self.coach = coach
        imgCoach.downloadImage(imageUrl: coach.coachpicture, placeHolder: "")
        txtCoachName.text = coach.coachfirstName + " " + coach.coachlastName
        
        if status == "Approved"{
            self.btnAccept.hide()
        }else{
            self.btnAccept.unhide()
        }
    }
    
    @IBAction func btnRejectClicked(_ sender: Any) {
        if let del = delegate{
            del.rejectCoach(coach: self.coach)
        }
    }
    
    
    @IBAction func btnAcceptClicked(_ sender: Any) {
        if let del = delegate{
            del.acceptCoach(coach: self.coach)
        }
    }
    
}
