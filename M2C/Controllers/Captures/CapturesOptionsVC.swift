//
//  CapturesOptionsVC.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 14/06/2022.
//

import UIKit

class CapturesOptionsVC: BaseVC {
    
    @IBOutlet weak var viewStrikerDetails: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var txtStrikerName: UILabel!
    @IBOutlet weak var txtStrikerHandedness: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupUI()
    }
    
    func setupUI(){
        // If striker is selected
        if let striker = Global.shared.selectedStriker {
            self.imgUser.downloadImage(imageUrl: striker.userpicture, placeHolder: "striker.placeholder")
            self.txtStrikerName.text = striker.userfirstName
            self.viewStrikerDetails.unhide()
            
            if striker.userPlayerType.localizedStandardContains("right"){
                self.txtStrikerHandedness.text = "Right Handed"
            }else if striker.userPlayerType.localizedStandardContains("left"){
                self.txtStrikerHandedness.text = "Left Handed"
            }
            
            
        }else{
            viewStrikerDetails.hide()
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigateBack()
    }
    
    @IBAction func actionLive(_ sender: Any) {
//        let vc = SelectOrientationViewController.initFrom(storyboard: .captures)
//        vc.isLive = true
//        self.pushViewController(vc: vc)
        
        let vc = LiveVC.initFrom(storyboard: .captures)
        self.pushViewController(vc: vc)
    }
    
    @IBAction func actionRecord(_ sender: UIButton) {
        
        let vc = SelectySwingTypeViewController.initFrom(storyboard: .captures)
        vc.screenTitle = sender.titleLabel?.text ?? "Back"
        self.pushViewController(vc: vc)
        
//        if let isWeightAdded = userDefault.getValue(key: UDKey.isRecordingWeightAdded) as? Bool{
//            let vc = SelectOrientationViewController.initFrom(storyboard: .captures)
//            vc.isRecord = true
//            pushViewController(vc: vc)
//        }else{
//            let vc = RecordingWeightVC.initFrom(storyboard: .recording)
//            vc.isRecord = true
//            self.pushViewController(vc: vc)
//        }
        
    }
    
    @IBAction func actionScan(_ sender: Any) {

        let vc = RecordingWeightVC.initFrom(storyboard: .recording)
        vc.isScan = true
        self.pushViewController(vc: vc)
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
    
}
