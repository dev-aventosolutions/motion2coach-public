//
//  RecordingTVCell.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 17/05/2022.
//

import UIKit
protocol playVideoDelegate: AnyObject{
    func playVideoWithUrl(url: String , videoName: String)
}

protocol MoveToRespectiveVC : AnyObject {
    func moveToReport(capture: CaptureModel)
    func moveToPreview(capture: CaptureModel)
}

class RecordingTVCell: UITableViewCell {
    
    //section
    @IBOutlet weak var tblCapturesPerDate: UITableView!
    @IBOutlet weak var lblRecordingDate: UILabel!
    @IBOutlet weak var imgBottomArrow: UIImageView!
    var index: IndexPath = IndexPath(row: -1, section: -1)
    var captures = [CaptureModel]()
    weak var delegate: playVideoDelegate?
    weak var navigateDelegate: MoveToRespectiveVC?
    @IBOutlet weak var viewCaptures: UIView!
    @IBOutlet weak var topDateView: UIView!
    @IBOutlet weak var heightViewCaptures: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    
    deinit {
        self.captures.removeAll()
        self.tblCapturesPerDate.dataSource = nil
        self.tblCapturesPerDate.delegate = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }
    
    func configure(data: [CaptureModel] , indexPath: IndexPath , isExpanded: Bool){
        self.captures = data
        if captures.count > 0{
            self.lblRecordingDate.text = data[0].datedAdded
        }
        self.index = indexPath
        if(isExpanded){
            self.imgBottomArrow.image = UIImage(systemName: "chevron.up")
            self.heightViewCaptures.constant = (75.0 * CGFloat(self.captures.count)) + 20
        } else {
            self.imgBottomArrow.image = UIImage(systemName: "chevron.down")
            self.heightViewCaptures.constant = 0.0
        }
        
        self.layoutIfNeeded()
        self.tblCapturesPerDate.delegate = self
        self.tblCapturesPerDate.dataSource = self
        self.tblCapturesPerDate.reloadData()
        
    }
    
}

//MARK: TABLE VIEW METHODS
extension RecordingTVCell : UITableViewDelegate , UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.captures.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view: CapturePerDateTableViewHeader = UIView.fromNib()
        //        view.setupHeader(title: recordingsHistorySections[section])
        view.setupHeader(num: captures.count)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CapturesDetailTVCell", for: indexPath) as! CapturesDetailTVCell
        cell.navigateDelegate = self
        cell.configure(item: self.captures[indexPath.row], index: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //send call back to play video
        if let del = self.delegate {
            if let cell = tableView.cellForRow(at: indexPath) as? CapturesDetailTVCell{
                if let data = cell.captureData{
                    Global.shared.selectedCapture = cell.captureData ?? CaptureModel()
                    del.playVideoWithUrl(url: data.videoUrl, videoName: data.videoName)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    private func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            if let captureCd = CoreDataManager.shared.fetchCaptures(at: indexPath.row){
    //                CoreDataManager.shared.deleteCapture(capture: captureCd)
    //                NotificationCenter.default.post(name: .coreDataVideoDeleted, object: self, userInfo: ["row": indexPath.row, "section": indexPath.section, "capture": captures[indexPath.row]])
    //                self.captures.remove(at: indexPath.row)
    //            }
    //            tblCapturesPerDate.reloadData()
    ////            tableView.reloadData()
    ////            objects.remove(at: indexPath.row)
    ////            tableView.deleteRows(at: [indexPath], with: .fade)
    //        } else if editingStyle == .insert {
    //
    //        }
    //    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            CoreDataManager.shared.deleteByName(name: self.captures[indexPath.row].videoName)
//            NotificationCenter.default.post(name: .coreDataVideoDeleted, object: self, userInfo: ["row": indexPath.row, "section": indexPath.section, "capture": captures[indexPath.row]])
            
            NotificationCenter.default.post(name: .serverVideoDeleted, object: self, userInfo: ["row": indexPath.row, "section": indexPath.section, "capture": captures[indexPath.row]])
            
            
//            self.captures.remove(at: indexPath.row)
//            tblCapturesPerDate.reloadData()
            
        } else if editingStyle == .insert {
            
        }
    }
}

// MARK: 
extension RecordingTVCell : MoveToRespectiveVCFromHistory{
    
    // To get report of recording
    func recordingReport(capture: CaptureModel) {
        if let del = self.navigateDelegate{
            del.moveToReport(capture: capture)
        }
    }
    
    func recordingPreview(capture: CaptureModel) {
        
        if let del = self.navigateDelegate{
            del.moveToPreview(capture: capture)
        }
    }
}



// MARK: Server Response
extension RecordingTVCell : ServerResponse{
    
    func onSuccess(json: JSON, val: String) {
        
    }
   
}
