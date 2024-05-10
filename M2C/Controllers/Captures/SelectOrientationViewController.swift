//
//  SelectOrientationViewController.swift
//  M2C
//
//  Created by Abdul Samad Butt on 10/08/2022.
//

import UIKit

class SelectOrientationViewController: BaseVC {
    
    //MARK: OUTLETS
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var btnRightHanded: UIButton!
    @IBOutlet weak var btnLeftHanded: UIButton!
//    @IBOutlet weak var txtReminder: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var viewStriker: UIView!
    @IBOutlet weak var txtStrikerName: UILabel!
    @IBOutlet weak var txtStrikerHandedness: UILabel!
    @IBOutlet weak var inputHeight: UITextField!
    @IBOutlet weak var inputWeight: UITextField!
    @IBOutlet weak var inputHeightUnit: UITextField!
    @IBOutlet weak var inputWeightUnit: UITextField!
    @IBOutlet weak var stackViewWeightHeight: UIStackView!
    @IBOutlet weak var scrollViewContent: UIScrollView!
    @IBOutlet weak var heightStrikerView: NSLayoutConstraint!
    @IBOutlet weak var txtHeightTitle: UILabel!
    @IBOutlet weak var txtWeightTitle: UILabel!
    
    //MARK: VARIABLES
    var isLive: Bool = false
    var isRecord: Bool = false
    var arrPlayerOrienations = [PlayerOrientation]()
    var pickerPlayerType = UIPickerView()
    var selectedPlayerType: PlayerType?
    var selectedWeightUnit = "kg"
    var selectedHeighUnit = "cm"
    private var playerTypePickerIndex: Int = 0
    
    //MARK: VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getOrientations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Will Appear")
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Did Appear")
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func setupUI(){
        
//        self.inputWeight.keyboardType = .asciiCapableNumberPad
        
        self.addRedAsterik(textField: inputWeight)
        self.addRedAsterik(textField: inputHeight)
        
        // If striker is selected
        if let striker = Global.shared.selectedStriker {
            self.imgUser.downloadImage(imageUrl: striker.userpicture, placeHolder: "striker.placeholder")
            self.viewStriker.unhide()
            self.heightStrikerView.constant = 90
            
            self.txtStrikerHandedness.text = striker.userPlayerType
            self.txtStrikerName.text = striker.userfirstName
            self.inputHeight.text = striker.height
            self.inputWeight.text = striker.weight
            if striker.userPlayerType.localizedStandardContains("right"){
                self.txtStrikerHandedness.text = "Right Handed"
            }else if striker.userPlayerType.localizedStandardContains("left"){
                self.txtStrikerHandedness.text = "Left Handed"
            }
        }else{
            // If Coach is recording video for himself
            viewStriker.hide()
            self.heightStrikerView.constant = 0
            if let loginUser = Global.shared.loginUser{
                self.inputHeight.text = loginUser.height
                self.inputWeight.text = loginUser.weight
            }
        }
        
        // For left handed
        if Global.shared.loginUser?.playerTypeId == "1"{
            btnLeftHanded.makePlayerTypeButtonActive()
            btnRightHanded.makePlayerTypeButtonDeactive()
        } else if Global.shared.loginUser?.playerTypeId == "2" {
            // For right handed
            btnLeftHanded.makePlayerTypeButtonDeactive()
            btnRightHanded.makePlayerTypeButtonActive()
        } else {
            showPopupAlert(title: "Error", message: "No selected player type.", btnOkTitle: "Ok")
        }
        
//        self.txtReminder.attributedText = NSMutableAttributedString()
//            .blueBoldForeground("Reminder: ")
//            .blackForeground("Avoid swaying (too much lower body movement to the right) to maintain a stable lower body.")
        
        if isLive{
            txtTitle.text = "Select Orientation"
        }else if isRecord {
            txtTitle.text = "How will you be recording your swing?"
        }
        
    }
    
    func getOrientations(){
        if let user = Global.shared.loginUser{
            GetOrientationRequest.shared.loggedUserId = user.userId
            
            serverRequest.delegate = self
            serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.getOrientations, params: GetOrientationRequest.shared.returnGetOrientationRequestParams(), method: .post, type: "orientations", loading: true, headerType: .headerWithAuth)
        }
        
    }
    
    //MARK: ACTIONS
    @IBAction func btnLeftHandedClicked(_ sender: Any) {
        Global.shared.loginUser?.playerTypeId = "1"
        btnLeftHanded.makePlayerTypeButtonActive()
        btnRightHanded.makePlayerTypeButtonDeactive()
    }
    
    @IBAction func btnRightHandedClicked(_ sender: Any) {
        Global.shared.loginUser?.playerTypeId = "2"
        btnLeftHanded.makePlayerTypeButtonDeactive()
        btnRightHanded.makePlayerTypeButtonActive()
    }
    
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.popViewController()
        self.dismiss(animated: true)
    }
    
    @IBAction func btnFaceOnClicked(_ sender: Any) {
        
        // If striker is selected
        if Global.shared.selectedStriker != nil {
            
            // In case of striker weight and height is mandatory
            if (inputHeight.text!.isEmpty) || (inputWeight.text!.isEmpty){
                self.showPopupAlert(title: "Error!", message: "Please enter weight and height.", btnOkTitle: "Ok")
            }else{
                Global.shared.selectedStriker?.weight = self.inputWeight.text ?? ""
                Global.shared.selectedStriker?.height = self.inputHeight.text ?? ""
                
                let vc = RecordingVC.initFrom(storyboard: .recording)
                vc.selectedOrientation = .faceOn
                self.arrPlayerOrienations.forEach({ if $0.name == "FaceOn"{
                    Global.shared.selectedOrientation = $0
                }})
                vc.delegate = self
                self.pushViewController(vc: vc)
            }
        }else{
            if isLive{
                let vc = LiveVC.initFrom(storyboard: .captures)
                self.pushViewController(vc: vc)
            } else if isRecord{
                
                // If coach is recording video for himself
                if (inputHeight.text!.isEmpty) || (inputWeight.text!.isEmpty){
                    self.showPopupAlert(title: "Error!", message: "Please enter weight and height.", btnOkTitle: "Ok")
                }else{
                    
                    // Saving weight and height for video
                    var weight = inputWeight.text ?? "0"
                    var height = inputHeight.text ?? "0"
                    
                    if selectedWeightUnit == "lb"{
                        weight = inputWeight.text?.convertLbToKg() ?? "0"
                    }
                    if selectedHeighUnit == "ft"{
                        height = inputHeight.text?.convertFtToCm() ?? "0"
                    }
                    
                    Global.shared.loginUser?.weight = weight
                    Global.shared.loginUser?.height = height
                    
                    guard let user = Global.shared.loginUser else {return}
                    userDefault.saveUser(user: user)
                    
                    let vc = RecordingVC.initFrom(storyboard: .recording)
                    vc.selectedOrientation = .faceOn
                    self.arrPlayerOrienations.forEach({ if $0.name == "FaceOn"{
                        Global.shared.selectedOrientation = $0
                    }})
                    vc.delegate = self
                    self.pushViewController(vc: vc)
                }
            }
        }
    }
        
        
    @IBAction func btnDownTheLineClicked(_ sender: Any) {
        
        // If striker is selected
        if Global.shared.selectedStriker != nil {
            
            // In case of striker weight and height is mandatory
            if (inputHeight.text!.isEmpty) || (inputWeight.text!.isEmpty){
                self.showPopupAlert(title: "Error!", message: "Please enter weight and height.", btnOkTitle: "Ok")
            }else{
                Global.shared.selectedStriker?.weight = self.inputWeight.text ?? ""
                Global.shared.selectedStriker?.height = self.inputHeight.text ?? ""
                
                let vc = RecordingVC.initFrom(storyboard: .recording)
                vc.selectedOrientation = .faceOn
                self.arrPlayerOrienations.forEach({ if $0.name == "DownTheLine"{
                    Global.shared.selectedOrientation = $0
                }})
                vc.delegate = self
                self.pushViewController(vc: vc)
            }
        }else{
            if isLive{
                let vc = LiveVC.initFrom(storyboard: .captures)
                self.pushViewController(vc: vc)
            } else if isRecord{
                
                // If coach is recording video for himself
                if (inputHeight.text!.isEmpty) || (inputWeight.text!.isEmpty){
                    self.showPopupAlert(title: "Error!", message: "Please enter weight and height.", btnOkTitle: "Ok")
                }else{
                    
                    // Saving weight and height for video
                    var weight = inputWeight.text ?? "0"
                    var height = inputHeight.text ?? "0"
                    
                    if selectedWeightUnit == "lb"{
                        weight = inputWeight.text?.convertLbToKg() ?? "0"
                    }
                    if selectedHeighUnit == "ft"{
                        height = inputHeight.text?.convertFtToCm() ?? "0"
                    }
                    
                    Global.shared.loginUser?.weight = weight
                    Global.shared.loginUser?.height = height
                    
                    guard let user = Global.shared.loginUser else {return}
                    userDefault.saveUser(user: user)
                    
                    let vc = RecordingVC.initFrom(storyboard: .recording)
                    vc.selectedOrientation = .faceOn
                    self.arrPlayerOrienations.forEach({ if $0.name == "DownTheLine"{
                        Global.shared.selectedOrientation = $0
                    }})
                    vc.delegate = self
                    self.pushViewController(vc: vc)
                }
            }
        }
    }
    
    @IBAction func btnStrikerClicked(_ sender: Any) {
        if let viewControllers = self.navigationController?.viewControllers
        {
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
    
    @IBAction func actionSelectHeightUnit(_ sender: Any) {
        self.inputWeight.resignFirstResponder()
        let alert = UIAlertController(title: "Select Unit", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "cm", style: .default , handler:{ (UIAlertAction)in
            self.selectedHeighUnit = "cm"
            self.inputHeightUnit.text = "cm"
            alert.dismiss(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "ft", style: .default , handler:{ (UIAlertAction)in
            self.selectedHeighUnit = "ft"
            self.inputHeightUnit.text = "ft"
            alert.dismiss(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("")
        }))
        
        //uncomment for iPad Support
        alert.popoverPresentationController?.sourceView = self.view
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    @IBAction func actionSelectWeightUnit(_ sender: Any) {
        self.inputHeight.resignFirstResponder()
        let alert = UIAlertController(title: "Select Unit", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "kg", style: .default , handler:{ (UIAlertAction)in
            self.selectedWeightUnit = "kg"
            self.inputWeightUnit.text = "kg"
            alert.dismiss(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "lb", style: .default , handler:{ (UIAlertAction)in
            self.selectedWeightUnit = "lb"
            self.inputWeightUnit.text = "lb"
            alert.dismiss(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("")
        }))
        
        //uncomment for iPad Support
        alert.popoverPresentationController?.sourceView = self.view
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
}

//MARK:
extension SelectOrientationViewController: RecordingVCProtocol{
    func showSession() {
        let vc = RecordingHistoryVC.initFrom(storyboard: .recording)
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

//MARK: SERVER RESPONSE
extension SelectOrientationViewController: ServerResponse{
    
    func onSuccess(json: JSON, val: String) {
        
        if val == "orientations"{
            let orientationJsonArray = json.arrayValue
            for each in orientationJsonArray{
                let temp : PlayerOrientation = PlayerOrientation(json: each)
                arrPlayerOrienations.append(temp)
            }
        }
        
    }
}
