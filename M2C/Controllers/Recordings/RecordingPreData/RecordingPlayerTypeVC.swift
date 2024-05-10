//
//  RecordingPlayerTypeVC.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 04/06/2022.
//

import UIKit

class RecordingPlayerTypeVC: BaseVC {

    @IBOutlet weak var viewAmeture: UIView!
    @IBOutlet weak var viewCoach: UIView!
    @IBOutlet weak var viewProfessional: UIView!
    @IBOutlet weak var btnContinue: UIButton!
    
    
    var selectedGender = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        
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
            case "a":
                self.viewAmeture.backgroundColor = UIColor(hexString: "#FFFFFF")
                self.viewAmeture.borderWidth = 1
                self.viewAmeture.borderColor = UIColor(hexString: "#0069B4")
                self.viewCoach.backgroundColor = UIColor(hexString: "#EBEBEB")
                self.viewProfessional.backgroundColor = UIColor(hexString: "#EBEBEB")
                self.viewCoach.borderWidth = 0
                self.viewProfessional.borderWidth = 0
            case "c":
                self.viewCoach.backgroundColor = UIColor(hexString: "#FFFFFF")
                self.viewCoach.borderWidth = 1
                self.viewCoach.borderColor = UIColor(hexString: "#0069B4")
                self.viewAmeture.backgroundColor = UIColor(hexString: "#EBEBEB")
                self.viewProfessional.backgroundColor = UIColor(hexString: "#EBEBEB")
                self.viewAmeture.borderWidth = 0
                self.viewProfessional.borderWidth = 0

            case "p":
                self.viewProfessional.backgroundColor = UIColor(hexString: "#FFFFFF")
                self.viewProfessional.borderWidth = 1
                self.viewProfessional.borderColor = UIColor(hexString: "#0069B4")
                self.viewAmeture.backgroundColor = UIColor(hexString: "#EBEBEB")
                self.viewCoach.backgroundColor = UIColor(hexString: "#EBEBEB")
                self.viewAmeture.borderWidth = 0
                self.viewCoach.borderWidth = 0

            default:
                self.noSelectionUIChanges()
            }
        }
    }
    
    func noSelectionUIChanges(){
        self.btnContinue.isEnabled = false
        self.btnContinue.backgroundColor = UIColor(hexString: "#978F91")
        self.viewAmeture.backgroundColor = UIColor(hexString: "#EBEBEB")
        self.viewCoach.backgroundColor = UIColor(hexString: "#EBEBEB")
        self.viewProfessional.backgroundColor = UIColor(hexString: "#EBEBEB")
        self.viewAmeture.borderWidth = 0
        self.viewCoach.borderWidth = 0
        self.viewProfessional.borderWidth = 0
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigateBack()
    }
    
    @IBAction func actionContinue(_ sender: Any) {
        userDefault.setValue(true, forKey: hasPreRecordingData)
        self.navigateForward(storyBoard: SBRecordings, viewController: recordSwingOptionsVCID)
    }
    
    @IBAction func actionAmeture(_ sender: Any) {
        self.selectedGender = "A"
        self.setBackgroundColorOgGenderButtons()
    }
    
    @IBAction func actionCoach(_ sender: Any) {
        self.selectedGender = "C"
        self.setBackgroundColorOgGenderButtons()
    }
    
    @IBAction func actionProfessional(_ sender: Any) {
        self.selectedGender = "P"
        self.setBackgroundColorOgGenderButtons()
    }
    
}
