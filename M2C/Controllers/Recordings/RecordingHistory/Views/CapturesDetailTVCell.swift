//
//  CapturesDetailTVCell.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 18/05/2022.
//

import UIKit

protocol MoveToRespectiveVCFromHistory : AnyObject {
    func recordingReport(capture: CaptureModel)
    func recordingPreview(capture: CaptureModel)
}


class CapturesDetailTVCell: UITableViewCell {
    
    @IBOutlet weak var btnVisualization: UIButton!
    @IBOutlet weak var viewVisualise: UIView!
    @IBOutlet weak var viewReport: UIView!
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblRecordingName: UILabel!
    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var txtSwingType: UILabel!
    @IBOutlet weak var txtClubType: UILabel!
    
    var index: IndexPath = IndexPath(row: -1, section: -1)
    weak var delegate:playVideoDelegate?
    var captureData : CaptureModel?
    weak var navigateDelegate: MoveToRespectiveVCFromHistory?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(item: CaptureModel, index: IndexPath){
        self.captureData = item
        if Global.shared.loginUser?.roleName == "Striker"{
            viewReport.hide()
        }
        
        self.index = index
        self.lblRecordingName.text = item.videoName
        //        self.lblTime.text = item.time
        self.lblTime.text = ""
        self.txtClubType.text = item.clubTypeName
        self.txtSwingType.text = item.swingTypeName
        let thumbnail = item.thumbnail
        let image = UIImage(data: thumbnail)
        //            self.imgThumbnail.image = image
    }
    
    @IBAction func actionReport(_ sender: Any) {
        if let del = self.navigateDelegate{
            Global.shared.selectedCapture = self.captureData ?? CaptureModel()
            if let captureData = captureData {
                del.recordingReport(capture: captureData)
            }
        }
    }
    
    @IBAction func actionVisualization(_ sender: Any) {
        if let del = self.navigateDelegate{
            Global.shared.selectedCapture = self.captureData ?? CaptureModel()
            del.recordingPreview(capture: self.captureData ?? CaptureModel())
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    
}
