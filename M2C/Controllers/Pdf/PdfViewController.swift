//
//  PdfViewController.swift
//  M2C
//
//  Created by Abdul Samad Butt on 17/10/2022.
//

import UIKit
import PDFKit

class PdfViewController: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var viewPdf: PDFView!
    
    
    //MARK: VARIABLES
    var capture: CaptureModel?
    var pdfDocument: PDFDocument?
    
    //MARK: VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let capture = capture{
            
            var userId: String = ""
            
            // For getting highlight points from history.
            var videoId = capture.overlayUrl.components(separatedBy: "/").last?.replaceString(fromString: ".mp4", toString: "") ?? ""
            var fileId: String = "\(Global.shared.loginUser?.email.lowercased() ?? "")/\(videoId).json"
            
            if let striker = Global.shared.selectedStriker {
                userId = striker.userId
                fileId = "\(striker.useremail.lowercased())/\(videoId).json"
            } else{
                userId = Global.shared.loginUser?.userId ?? ""
                fileId = "\(Global.shared.loginUser?.email.lowercased() ?? "")/\(videoId).json"
            }
            
            
            let params = ["loggedUserId" : userId, "fileId": fileId]
            
            ServiceManager.shared.getKinematicsReport(parameters: params) { response in
                print(response)
                if let url = response["url"].string{
                    
                    if let url = URL(string: url){
                        
                        if let pdfDocument = PDFDocument(url: url){
                            self.pdfDocument = pdfDocument
                            // After saving showing it on PDF View
                            self.viewPdf.displayMode = .singlePageContinuous
                            self.viewPdf.autoScales = true
                            self.viewPdf.displayDirection = .vertical
                            self.viewPdf.document = pdfDocument
                        }
                    }
                }
            } failure: { err in
                self.showPopupAlert(title: "Error", message: err.message, btnOkTitle: "Ok")
            }
        }
        
    }
    
    @IBAction func btnShareClicked(_ sender: Any) {
//        if self.pdfDocument != nil{
//
//        }
        sharePDF(self.pdfDocument ?? PDFDocument())
    }

    @IBAction func btnBackClicked(_ sender: Any) {
        popViewController()
    }
    
    func sharePDF(_ filePDF: PDFDocument) {
        if let pdfData = filePDF.dataRepresentation() {
            let objectsToShare = [pdfData]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

            self.present(activityVC, animated: true, completion: nil)
        }
    }
}
