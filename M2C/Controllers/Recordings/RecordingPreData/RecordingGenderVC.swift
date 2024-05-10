//
//  RecordingGenderVC.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 04/06/2022.
//

import UIKit

class RecordingGenderVC: BaseVC {

   
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var viewMale: UIView!
    @IBOutlet weak var viewFemale: UIView!
    @IBOutlet weak var viewMore: UIView!
    
    var selectedGender = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        // Do any additional setup after loading the view.
    }
    
    func configure(){
        self.btnContinue.isEnabled = false
        self.setBackgroundColorOgGenderButtons()
    }
    
    func setBackgroundColorOgGenderButtons(){
        if(self.selectedGender.isEmpty){
            self.noSelectionUIChanges()
        }
        else{
            self.btnContinue.isEnabled = true
            self.btnContinue.backgroundColor = UIColor(hexString: "#0069B4")
            switch selectedGender.lowercased(){
            case "m":
                self.viewMale.backgroundColor = UIColor(hexString: "#FFFFFF")
                self.viewMale.borderWidth = 1
                self.viewMale.borderColor = UIColor(hexString: "#0069B4")
                self.viewFemale.backgroundColor = UIColor(hexString: "#EBEBEB")
                self.viewMore.backgroundColor = UIColor(hexString: "#EBEBEB")
                self.viewFemale.borderWidth = 0
                self.viewMore.borderWidth = 0
            case "f":
                self.viewFemale.backgroundColor = UIColor(hexString: "#FFFFFF")
                self.viewFemale.borderWidth = 1
                self.viewFemale.borderColor = UIColor(hexString: "#0069B4")
                self.viewMale.backgroundColor = UIColor(hexString: "#EBEBEB")
                self.viewMore.backgroundColor = UIColor(hexString: "#EBEBEB")
                self.viewMale.borderWidth = 0
                self.viewMore.borderWidth = 0

            case "o":
                self.viewMore.backgroundColor = UIColor(hexString: "#FFFFFF")
                self.viewMore.borderWidth = 1
                self.viewMore.borderColor = UIColor(hexString: "#0069B4")
                self.viewMale.backgroundColor = UIColor(hexString: "#EBEBEB")
                self.viewFemale.backgroundColor = UIColor(hexString: "#EBEBEB")
                self.viewMale.borderWidth = 0
                self.viewFemale.borderWidth = 0

            default:
                self.noSelectionUIChanges()
            }
        }
    }
    
    func noSelectionUIChanges(){
        self.btnContinue.isEnabled = false
        self.btnContinue.backgroundColor = UIColor(hexString: "#978F91")
        self.viewMale.backgroundColor = UIColor(hexString: "#EBEBEB")
        self.viewFemale.backgroundColor = UIColor(hexString: "#EBEBEB")
        self.viewMore.backgroundColor = UIColor(hexString: "#EBEBEB")
        self.viewMale.borderWidth = 0
        self.viewFemale.borderWidth = 0
        self.viewMore.borderWidth = 0
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigateBack()
    }
    
    @IBAction func actionContinue(_ sender: Any) {
        self.navigateForward(storyBoard: SBRecordings, viewController: recordingWeightVCID)
    }
    @IBAction func actionMale(_ sender: Any) {
        self.selectedGender = "M"
        self.setBackgroundColorOgGenderButtons()
    }
    
    @IBAction func actionFemale(_ sender: Any) {
        self.selectedGender = "F"
        self.setBackgroundColorOgGenderButtons()
    }
    
    @IBAction func actionMore(_ sender: Any) {
        self.selectedGender = "O"
        self.setBackgroundColorOgGenderButtons()
    }

}
