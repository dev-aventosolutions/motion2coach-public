//
//  PopupViewController.swift
//
//
//  Created by Abdul Samad on 19/01/2022.
//

import UIKit
import Foundation

class PopupViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var txtMessage: UILabel!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var viewCross: UIView!
    
    //MARK: VARIABLES
    var alertTitle: String = ""
    var alertMessage: String = ""
    var btnOkTitle: String = ""
    var btnCancelTitle: String = ""
    var hideCross : Bool = false
    var onOK: (() -> Void)?
    var onCancel: (() -> Void)?
    
    //MARK: VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        popupView.backgroundColor = UIColor.white
        txtTitle.text = alertTitle
        txtMessage.text = alertMessage
        showAnimate()
        
        btnOk.setTitle(btnOkTitle, for: .normal)
        btnCancel.setTitle(btnCancelTitle, for: .normal)
        
        btnOkTitle.isEmpty ? btnOk.hide() : btnOk.unhide()
        btnCancelTitle.isEmpty ? btnCancel.hide() : btnCancel.unhide()
        viewCross.isHidden = hideCross
    }
    
    //MARK: ACTIONS
    @IBAction func btnOkClicked(_ sender: Any) {
        onOK?()
        removeAnimate()
    }
    
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        onCancel?()
        removeAnimate()
    }
    
    @IBAction func btnCrossClicked(_ sender: Any) {
        removeAnimate()
    }
}

