//
//  RecordingOptionsViewController.swift
//  M2C
//
//  Created by Fenris GMBH on 13/02/2023.
//

import UIKit

class SelectySwingTypeViewController: BaseVC {

    //MARK: OUTLETS
    
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var viewStrikerDetails: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var txtStrikerName: UILabel!
    @IBOutlet weak var txtStrikerHandedness: UILabel!
    @IBOutlet weak var heightStrikerView: NSLayoutConstraint!
    
    //MARK: VARIABLES
    var screenTitle: String = ""
    
    //MARK: VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupUI()
    }
    
    func setupUI(){
        self.txtTitle.text = screenTitle
        
        // If striker is selected
        if let striker = Global.shared.selectedStriker {
            self.imgUser.downloadImage(imageUrl: striker.userpicture, placeHolder: "striker.placeholder")
            self.txtStrikerName.text = striker.userfirstName
            self.viewStrikerDetails.unhide()
            self.heightStrikerView.constant = 93
            if striker.userPlayerType.localizedStandardContains("right"){
                self.txtStrikerHandedness.text = "Right Handed"
            }else if striker.userPlayerType.localizedStandardContains("left"){
                self.txtStrikerHandedness.text = "Left Handed"
            }
            
            
        }else{
            viewStrikerDetails.hide()
            self.heightStrikerView.constant = 0
        }
    }
    
    
    
    //MARK: ACTIONS
    
    @IBAction func btnFullSwingClicked(_ sender: Any) {
        
        let vc = SelectOrientationViewController.initFrom(storyboard: .captures)
        Global.shared.selectedSwingType = SwingType(id: "1", name: "fullSwing")
        Global.shared.selectedClubType = ClubType(id: "1", name: "Iron")
        vc.isRecord = true
        pushViewController(vc: vc)
    }
    
    @IBAction func btnShortGameClicked(_ sender: Any) {
        let vc = SelectOrientationViewController.initFrom(storyboard: .captures)
        Global.shared.selectedSwingType = SwingType(id: "2", name: "shortGame")
        Global.shared.selectedClubType = ClubType(id: "1", name: "Iron")
        vc.isRecord = true
        pushViewController(vc: vc)
    }
    
    @IBAction func btnPuttingClicked(_ sender: Any) {
        let vc = SelectOrientationViewController.initFrom(storyboard: .captures)
        Global.shared.selectedSwingType = SwingType(id: "3", name: "putting")
        Global.shared.selectedClubType = ClubType(id: "1", name: "Iron")
        vc.isRecord = true
        pushViewController(vc: vc)
    }
    
    
    @IBAction func btnBunkerClicked(_ sender: Any) {
        let vc = SelectOrientationViewController.initFrom(storyboard: .captures)
        Global.shared.selectedSwingType = SwingType(id: "4", name: "bunker")
        Global.shared.selectedClubType = ClubType(id: "1", name: "Iron")
        vc.isRecord = true
        pushViewController(vc: vc)
    }
    
    
    
    @IBAction func btnStrikerClicked(_ sender: Any) {
        if let viewControllers = self.navigationController?.viewControllers {
            if viewControllers.contains(where: {
                return $0 is StrikersListViewController
            }){
                print("VC is in the stack")
                //Write your code here
                self.popBackToStrikersList()
            }else{
                print("VC is not in the stack")
                let vc = StrikersListViewController.initFrom(storyboard: .dashboard)
                self.pushViewController(vc: vc)
            }
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigateBack()
    }
}
