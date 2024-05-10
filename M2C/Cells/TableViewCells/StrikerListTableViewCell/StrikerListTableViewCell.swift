//
//  StrikerListTableViewCell.swift
//  M2C
//
//  Created by Abdul Samad Butt on 22/12/2022.
//

import UIKit

protocol StrikerProtocol: AnyObject{
    func acceptStriker(striker: Striker)
    func rejectStriker(striker: Striker)
    func openHistory(striker: Striker)
}

class StrikerListTableViewCell: UITableViewCell {
    
    //MARK: OUTLETS
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var btnOpenHistory: UIButton!
    @IBOutlet weak var txtStrikerName: UILabel!
    @IBOutlet weak var imgStriker: UIImageView!
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var txtRole: UILabel!
    
    //MARK: VARIABLES
    var striker: Striker = Striker()
    var delegate: StrikerProtocol?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setupCell(striker: Striker, status: String){
        self.viewMain.layer.cornerRadius = 10
        self.viewMain.layer.shadowColor = UIColor.gray.cgColor
        self.viewMain.layer.shadowOpacity = 0.3
        self.viewMain.layer.shadowOffset = CGSize.zero
        self.viewMain.layer.shadowRadius = 5
        self.viewMain.layer.masksToBounds = false
        
        self.striker = striker
        self.txtStrikerName.text = striker.userfirstName + " " + striker.userlastName
        self.imgStriker.downloadImage(imageUrl: self.striker.userpicture, placeHolder: "striker.placeholder")
        self.txtRole.text = striker.userPlayerType
        
        if striker.userPlayerType.localizedStandardContains("right"){
            self.txtRole.text = "Right Handed"
        }else if striker.userPlayerType.localizedStandardContains("left"){
            self.txtRole.text = "Left Handed"
        }
        
        if let selectedStriker = Global.shared.selectedStriker{
            // Cell for selected striker
            
            if (self.striker.userId == selectedStriker.userId) && (status == "Approved") {
                self.txtStrikerName.textColor = .white
                self.txtRole.textColor = .white
                self.viewMain.backgroundColor = .fenrisBlue
                self.btnReject.tintColor = .white
                self.btnReject.setImage(UIImage(systemName: "x.circle"), for: .normal)
            }else{
                // Cell for normal striker
                self.txtStrikerName.textColor = .black
                self.txtRole.textColor = .fenrisGrey
                self.viewMain.backgroundColor = .white
                self.btnReject.setImage(UIImage(named: "reject.coach"), for: .normal)
                
            }
        }else{
            // Cell for normal striker
            self.txtStrikerName.textColor = .black
            self.txtRole.textColor = .fenrisGrey
            self.viewMain.backgroundColor = .white
            self.btnReject.setImage(UIImage(named: "reject.coach"), for: .normal)
            
        }
        
        
        if status == "Approved"{
            self.btnAccept.hide()
            self.btnOpenHistory.unhide()
        }else{
            self.btnAccept.unhide()
            self.btnOpenHistory.hide()
        }
    }
    
    @IBAction func btnRejectStrikerClicked(_ sender: Any) {
        
        if let del = delegate{
            del.rejectStriker(striker: self.striker)
        }
    }
    
    
    @IBAction func btnAcceptStrikerClicked(_ sender: Any) {
        
        if let del = delegate{
            del.acceptStriker(striker: self.striker)
        }
    }

    @IBAction func btnOpenHistoryClicked(_ sender: Any) {
        if let del = delegate{
            del.openHistory(striker: striker)
        }
    }
}
