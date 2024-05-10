//
//  RecordingHistoryVC.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 17/05/2022.
//

import UIKit
import Fastis
import AVKit
import Photos
import Starscream

class RecordingHistoryVC: BaseVC, UIGestureRecognizerDelegate {
    
    //MARK: OUTLETS
    @IBOutlet weak var btnRemoveFromDate: UIButton!
    @IBOutlet weak var btnRemoveToDate: UIButton!
    @IBOutlet weak var viewTableParent: UIView!
    @IBOutlet weak var viewDateRange: UIStackView!
    @IBOutlet weak var viewReport: UIView!
    @IBOutlet weak var viewNoVideosFound: UIView!
    @IBOutlet weak var txtToDate: UITextField!
    @IBOutlet weak var txtFromDate: UITextField!
    @IBOutlet weak var lblTotalVideos: UILabel!
    @IBOutlet weak var tblRecordings: UITableView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var viewUserImage: UIView!
    
    //MARK: VARIABLES
    var videoPlayer: AVPlayerViewController?
    var isRecordingExpanded = false
    var indexOfExpandedSection = IndexPath(row: -1, section: -1)
    var sectionWiseCapture = [String : [CaptureModel]]()
    var dateWiseCaptures = [String:[CaptureModel]]()
    var captureDates = [Date]()
    var countPerSection = [Int]()
    var fromDate = "01/01/2022".dateFromStringInSlashes()
    var toDate = Date()//"01/01/2022".dateFromStringInSlashes()
    var isFilterApplied = false
    var filteredCaptureDates = [Date]()
    let fastisController = FastisController(mode: .single)
    var player = AVPlayer()
    var serverVideos = [CaptureModel]()
    var captureToDelete = CaptureModel()
    var socket: WebSocket?
    var isConnected = false
//    var userId: String?
    var striker: Striker?
    
    // SECTIONS TO BE DISPLAYED
    var sectionsToBeDisplayed = [String]()
    var countToBeDisplayed: [Int] = [0,0,0,0,0]
    
    
    //MARK: VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getVideos()
        NotificationCenter.default.addObserver(self, selector: #selector(self.coreDataVideoDeleted), name: .coreDataVideoDeleted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.serverVideoDeleted), name: .serverVideoDeleted, object: nil)
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideIndicator()
//        self.configure()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        socket?.disconnect()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning received in RecordingReportViewController")
    }
    
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewWillDisappear(animated)
    //        self.dateWiseCaptures.removeAll()
    //        self.sectionWiseCapture.removeAll()
    //        self.captureDates.removeAll()
    //        self.countPerSection.removeAll()
    //        self.tblRecordings.dataSource = nil
    //        self.tblRecordings.delegate = nil
    //    }
    
    deinit {
        self.dateWiseCaptures.removeAll()
        self.sectionWiseCapture.removeAll()
        self.captureDates.removeAll()
        self.countPerSection.removeAll()
        self.tblRecordings.dataSource = nil
        self.tblRecordings.delegate = nil
    }
    
    func setupUI(){
        // If striker is selected
        if let striker = Global.shared.selectedStriker {
            self.imgUser.downloadImage(imageUrl: striker.userpicture, placeHolder: "smStrikerCoach")
            self.viewUserImage.unhide()
        }else{
            viewUserImage.hide()
        }
    }
    
    @objc func coreDataVideoDeleted(notification: Notification) {
        getCaptures()
        self.dateWiseCaptures.removeAll()
        configure()
        
        tblRecordings.reloadData()
    }
    
    @objc func serverVideoDeleted(notification: Notification) {
        
        self.showPopupAlert(title: "Alert!", message: "Are you sure you want to delete the video?", btnOkTitle: "Yes", btnCancelTitle: "No" , onOK: {
            
            // Deleting the video
            if let userInfo = notification.userInfo{
                if let capture = userInfo["capture"] as? CaptureModel{
                    
                    self.captureToDelete = capture
                    DeleteVideoRequest.shared.loggedUserId = Global.shared.loginUser?.userId ?? ""
                    DeleteVideoRequest.shared.url = capture.videoUrl
                    
                    serverRequest.delegate = self
                    serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.deleteVideos, params: DeleteVideoRequest.shared.returnDeleteVideosRequestParams(), method: .post, type: "deleteVideo", loading: true, headerType: .headerWithAuth)
                }
            }
        })
        
    }
    
    //MARK: GET VIDEOS
    func getVideos(){
        
        if let striker = striker{
            GetVideoRequest.shared.userId = striker.userId
        }else{
            GetVideoRequest.shared.userId = Global.shared.loginUser?.userId ?? ""
        }
//        if let userId = userId{
//            GetVideoRequest.shared.userId = userId
//        }else{
//            GetVideoRequest.shared.userId = Global.shared.loginUser?.userId ?? ""
//        }
        
        GetVideoRequest.shared.loggedUserId = Global.shared.loginUser?.userId ?? ""
        GetVideoRequest.shared.videoId = "0"
        
        serverRequest.delegate = self
        serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.getVideos, params: GetVideoRequest.shared.returnGetVideosRequestParams(), method: .post, type: "getVideos", loading: true, headerType: .headerWithoutAuth)
    }
    
    func configure(){
        self.btnRemoveToDate.isHidden = true
        self.btnRemoveFromDate.isHidden = true
        //        (self.dateWiseCaptures , captureDates) = self.getCapturesWRTDate()
        self.checkNoRecordFound()
        self.getCountPerSection()
        self.txtToDate.delegate = self
        self.txtFromDate.delegate = self
        self.tblRecordings.estimatedRowHeight = 60
        self.tblRecordings.rowHeight = UITableView.automaticDimension
        self.tblRecordings.delegate = self
        self.tblRecordings.dataSource = self
        self.tblRecordings.reloadData()
        setupLongPressGesture()
//        self.lblTotalVideos.text = "Total Videos: \(CoreDataManager.shared.fetchCaptures()?.count ?? 0)"
        self.lblTotalVideos.text = "Total Videos: \(serverVideos.count)"
    }
    
    func setupLongPressGesture() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self
        self.tblRecordings.addGestureRecognizer(longPressGesture)
    }
    
    func checkNoRecordFound(){
        if((self.isFilterApplied ? self.filteredCaptureDates.count : self.captureDates.count) > 0){
            self.viewNoVideosFound.isHidden = true
            self.viewTableParent.isHidden = false
            self.lblTotalVideos.isHidden = false
        }
        else{
            self.viewNoVideosFound.isHidden = false
            self.viewTableParent.isHidden = true
            //            self.viewDateRange.isHidden = true
            self.lblTotalVideos.isHidden = true
        }
    }
    
    func filterOnFromDate(resultDate: Date? , isFromClearField: Bool){
        if(((resultDate ?? Date()) > Date()) && self.txtToDate.text!.isEmpty){
            self.alertWarning(title: "Oops", message: "Start date should be lesser than  todays date when end date is not selected")
            return
        }
        if((resultDate ?? Date()) > self.toDate){
            self.alertWarning(title: "Oops", message: "Start date should be lesser than the end date")
            return
        }
        self.fromDate = resultDate ?? Date()
        if(!isFromClearField){
            self.txtFromDate.text = " " + self.fromDate.toStringFromDate()
            self.btnRemoveFromDate.isHidden = false
            
        }
        filteredCaptureDates.removeAll()
        if(self.txtToDate.text!.isEmpty){
            let range = self.fromDate...Date()
            for date in self.captureDates{
                if(range.contains(date)){
                    
                    self.filteredCaptureDates.append(date)
                }
            }
        }
        else{
            let range = self.fromDate...self.toDate
            for date in self.captureDates{
                if(range.contains(date)){
                    
                    self.filteredCaptureDates.append(date)
                }
            }
        }
    }
    
    func filterOnToDate(resultDate: Date? , isFromClearField: Bool){
        if(self.txtFromDate.text!.isEmpty){
            self.alertWarning(title: "Oops", message: "Please select start date first")
            return
        } else if ((resultDate ?? Date()) < self.fromDate){
            self.alertWarning(title: "Oops", message: "End date should be greater than start date")
            return
        }
        self.toDate = resultDate ?? Date()
        if(!isFromClearField){
            self.txtToDate.text = " " + self.toDate.toStringFromDate()
            self.btnRemoveToDate.isHidden = false
        }
        filteredCaptureDates.removeAll()
        if(self.txtFromDate.text!.isEmpty){
            let range = (self.fastisController.initialValue ?? "01/01/2022".dateFromStringInSlashes())...self.toDate
            for date in self.captureDates{
                if(range.contains(date)){
                    
                    self.filteredCaptureDates.append(date)
                }
            }
        }
        else{
            let range = self.fromDate...self.toDate
            for date in self.captureDates{
                if(range.contains(date)){
                    
                    self.filteredCaptureDates.append(date)
                }
            }
        }
    }
    func chooseDate(isStartDate: Bool , titleExtension: String) {
        self.fastisController.view.center = self.view.center
        self.fastisController.preferredContentSize = CGSize(width: 0.0, height: 0.0)
        self.fastisController.title = "Choose \(titleExtension)"
        self.fastisController.initialValue = "01/01/2022".dateFromStringInSlashes()
        self.fastisController.allowToChooseNilDate = true
        self.fastisController.doneHandler = { resultDate in
            self.filteredCaptureDates.removeAll()
            self.isFilterApplied = true
            self.getCountPerSection()
            if(isStartDate){
                self.filterOnFromDate(resultDate: resultDate, isFromClearField: false)
            }
            else{
                self.filterOnToDate(resultDate: resultDate, isFromClearField: false)
            }
            self.getCountPerSection()
            self.tblRecordings.reloadData()
            self.checkNoRecordFound()
        }
        fastisController.present(above: self)
    }
    
    
    
    func checkFilterApplied(){
        if(self.txtFromDate.text!.isEmpty && self.txtToDate.text!.isEmpty){
            self.isFilterApplied = false
            
        }
        self.getCountPerSection()
        self.checkNoRecordFound()
        self.tblRecordings.delegate = self
        self.tblRecordings.dataSource = self
        self.tblRecordings.reloadData()
    }
    
    func getCountPerSection(){
        self.countPerSection.removeAll()
        self.sectionsToBeDisplayed.removeAll()
        self.countToBeDisplayed = [0,0,0,0,0]
        self.countPerSection.append(0)
        self.countPerSection.append(0)
        self.countPerSection.append(0)
        self.countPerSection.append(0)
        self.countPerSection.append(0)
        self.sectionWiseCapture = [String : [CaptureModel]]()
        
        for date in self.isFilterApplied ? self.filteredCaptureDates : self.captureDates{
            
            if (date.onlyDate() == Date().onlyDate()){
                // Setting up section to display
                if !sectionsToBeDisplayed.contains(recordingsHistorySections[0]){
                    sectionsToBeDisplayed.append(recordingsHistorySections[0])
                }
                
                //                self.countPerSection[0] = self.countPerSection[0] + 1
                //                self.countToBeDisplayed[sectionsToBeDisplayed.count - 1] = self.countPerSection[0]
                self.countToBeDisplayed[sectionsToBeDisplayed.count - 1] = self.countToBeDisplayed[sectionsToBeDisplayed.count - 1] + 1
                
                self.sectionWiseCapture[recordingsHistorySections[0]] = dateWiseCaptures[date.toStringFromDate()]
            }
            else if(date.onlyDate() == Date.yesterday.onlyDate()){
                // Setting up section to display
                if !sectionsToBeDisplayed.contains(recordingsHistorySections[1]){
                    sectionsToBeDisplayed.append(recordingsHistorySections[1])
                }
                
                //                self.countPerSection[1] = self.countPerSection[1] + 1
                //                self.countToBeDisplayed[sectionsToBeDisplayed.count - 1] = self.countPerSection[1]
                self.countToBeDisplayed[sectionsToBeDisplayed.count - 1] = self.countToBeDisplayed[sectionsToBeDisplayed.count - 1] + 1
                
                self.sectionWiseCapture[recordingsHistorySections[1]] = dateWiseCaptures[date.toStringFromDate()]
            }
            else if(date.onlyDate() == Date().earlierThisWeek.onlyDate()){
                // Setting up section to display
                if !sectionsToBeDisplayed.contains(recordingsHistorySections[2]){
                    sectionsToBeDisplayed.append(recordingsHistorySections[2])
                }
                
                //                self.countPerSection[2] = self.countPerSection[2] + 1
                //                self.countToBeDisplayed[sectionsToBeDisplayed.count - 1] = self.countPerSection[2]
                self.countToBeDisplayed[sectionsToBeDisplayed.count - 1] = self.countToBeDisplayed[sectionsToBeDisplayed.count - 1] + 1
                
                self.sectionWiseCapture[recordingsHistorySections[2]] = dateWiseCaptures[date.toStringFromDate()]
            }
            else if((date.thisMonth == Date().thisMonth) &&  (date.thisYear == Date().thisYear)){
                // Setting up section to display
                if !sectionsToBeDisplayed.contains(recordingsHistorySections[3]){
                    sectionsToBeDisplayed.append(recordingsHistorySections[3])
                }
                
                //                self.countPerSection[3] = self.countPerSection[3] + 1
                //                self.countToBeDisplayed[sectionsToBeDisplayed.count - 1] = self.countPerSection[3]
                self.countToBeDisplayed[sectionsToBeDisplayed.count - 1] = self.countToBeDisplayed[sectionsToBeDisplayed.count - 1] + 1
                
                self.sectionWiseCapture[recordingsHistorySections[sectionsToBeDisplayed.count - 1]] = dateWiseCaptures[date.toStringFromDate()]
            }
            else{
                // Setting up section to display
                if !sectionsToBeDisplayed.contains(recordingsHistorySections[4]){
                    sectionsToBeDisplayed.append(recordingsHistorySections[4])
                }
                
                //                self.countPerSection[4] = self.countPerSection[4] + 1
                //                self.countToBeDisplayed[sectionsToBeDisplayed.count - 1] = self.countPerSection[4]
                self.countToBeDisplayed[sectionsToBeDisplayed.count - 1] = self.countToBeDisplayed[sectionsToBeDisplayed.count - 1] + 1
                
                self.sectionWiseCapture[recordingsHistorySections[4]] = dateWiseCaptures[date.toStringFromDate()]
            }
        }
        
        print(sectionWiseCapture.count)
        tblRecordings.reloadData()
    }
    
    @available(iOS 14.2, *)
    func playVideo(videoURLText: String , videoName: String) {
        
        if !videoURLText.isEmpty {
            if let videoURL = URL(string: videoURLText){
                print("playing video at \(videoURL)")
                let videoPlayer = AVPlayer(url: videoURL)
                let videoPlayerViewController = AVPlayerViewController()
                videoPlayerViewController.player = videoPlayer
                videoPlayerViewController.canStartPictureInPictureAutomaticallyFromInline = true
                videoPlayerViewController.exitsFullScreenWhenPlaybackEnds = false
                self.present(videoPlayerViewController, animated: true) {
                    videoPlayerViewController.player?.play()
                }
            }
        }
    }
    
    @available(iOS 14.2, *)
    func playVideo(url: String) {
        
        if !url.isEmpty {
            if let videoURL = URL(string: url){
                print("playing video at \(videoURL)")
                let videoPlayer = AVPlayer(url: videoURL)
                let videoPlayerViewController = AVPlayerViewController()
                videoPlayerViewController.player = videoPlayer
                videoPlayerViewController.canStartPictureInPictureAutomaticallyFromInline = true
                videoPlayerViewController.exitsFullScreenWhenPlaybackEnds = false
                self.present(videoPlayerViewController, animated: true) {
                    videoPlayerViewController.player?.play()
                }
            }
        }
    }
    
    
//    func mapServerCapturesWRTDate() -> ([String:[CaptureModel]] , [Date]){
//
//        Global.shared.allCaptures.removeAll()
//        Global.shared.allCaptures = self.serverVideos
//        let captures = Global.shared.allCaptures
//        let dateWiseCaptures = Dictionary(grouping: captures, by: { $0.createdAt})
//        let dates = dateWiseCaptures.keys
//        var datesInDateFormat = [Date]()
//        for date in dates{
//            print(date)
//            datesInDateFormat.insert(date.dateFromString() , at: 0)
//            self.captureDates.append(date.dateFromString())
//        }
//        return (dateWiseCaptures, datesInDateFormat.sorted().reversed())
//    }
    
    func mapServerCapturesWRTDate() -> ([String:[CaptureModel]] , [Date]){

        Global.shared.allCaptures.removeAll()
        Global.shared.allCaptures = self.serverVideos
        let captures = Global.shared.allCaptures.sorted(by: { $0.createdAt > $1.createdAt })
        let dateWiseCaptures = Dictionary(grouping: captures, by: { $0.datedAdded})
        let dates = dateWiseCaptures.keys
        var datesInDateFormat = [Date]()
        for date in dates{
//            print(date)
            datesInDateFormat.insert(date.dateFromString() , at: 0)
        }
        return (dateWiseCaptures , datesInDateFormat.sorted().reversed())
    }
    
    // MARK: ACTIONS
    @IBAction func actionBack(_ sender: Any) {
        self.navigateBack()
    }
    
    @IBAction func actionRemoveFromDate(_ sender: Any) {
        self.btnRemoveFromDate.isHidden = true
        self.txtFromDate.text = ""
        self.fromDate = "01/01/2022".dateFromStringInSlashes()
        self.btnRemoveToDate.isHidden = true
        self.txtToDate.text = ""
        self.toDate = Date()
        self.filterOnFromDate(resultDate: self.fromDate, isFromClearField: true)
        self.checkFilterApplied()
        
    }
    
    @IBAction func actionRemoveToDate(_ sender: Any) {
        self.btnRemoveToDate.isHidden = true
        self.txtToDate.text = ""
        self.toDate = Date()//"01/01/2022".dateFromStringInSlashes()
        
        self.filterOnToDate(resultDate: self.toDate, isFromClearField: true)
        self.checkFilterApplied()
        
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
    
    @IBAction func actionFromDate(_ sender: Any) {
        self.chooseDate(isStartDate: true, titleExtension: "From Date")
    }
    @IBAction func actionToDate(_ sender: Any) {
        self.chooseDate(isStartDate: false, titleExtension: "To Date")
    }
    
    @IBAction func actionRecord(_ sender: Any) {
        if let hasData = userDefault.value(forKey: hasPreRecordingData) as? Bool{
            if(hasData){
                self.navigateForward(storyBoard: SBRecordings, viewController: recordSwingOptionsVCID)
            }
            else{
                self.navigateForward(storyBoard: SBRecordings, viewController: recordingDOBVCID)
            }
        }
        else{
            self.navigateForward(storyBoard: SBRecordings, viewController: recordingDOBVCID)
        }
    }
}

//MARK: TABLE VIEW METHODS
extension RecordingHistoryVC : UITableViewDelegate , UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //        return recordingsHistorySections.count
        
        //        return sectionWiseCapture.count
        return sectionsToBeDisplayed.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //        return self.countPerSection[section]
        return self.countToBeDisplayed[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordingTVCell", for: indexPath) as! RecordingTVCell
        
        var index = 0
        var iteration = 0
        for count in self.countToBeDisplayed{
            if(iteration < indexPath.section){
                index += count
                iteration += 1
            }
            else{
                break
            }
        }
        
        let keyForCapture = self.isFilterApplied ? self.filteredCaptureDates[index + indexPath.row].toStringFromDate() : captureDates[index + indexPath.row].toStringFromDate()
        
        //        self.captureDates[indexPath.row].toStringFromDate()
        
        let data = self.dateWiseCaptures[keyForCapture]
        
        if let value = data{
            cell.delegate = self
            cell.navigateDelegate = self
            cell.configure(data: value, indexPath: indexPath, isExpanded: indexOfExpandedSection == indexPath ? true : false)
        }
        cell.delegate = self
        return cell
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: self.tblRecordings)
            if let indexPath = tblRecordings.indexPathForRow(at: touchPoint) {
                
                self.showPopupAlert(title: "Alert!", message: "Are you sure you want to delete this session?", btnOkTitle: "ok", btnCancelTitle: "Cancel", onOK: {
                    // Delete the whole session here
                    if let captures = self.sectionWiseCapture[recordingsHistorySections[indexPath.section]] {
                        for element in captures {
                            CoreDataManager.shared.deleteByName(name: element.videoName)
                            NotificationCenter.default.post(name: .coreDataVideoDeleted, object: self, userInfo: ["row": indexPath.row, "section": indexPath.section, "capture": captures[indexPath.row]])
                        }
                    }
                }, onCancel:  {
                    self.dismiss(animated: true)
                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath != indexOfExpandedSection) {
            indexOfExpandedSection = indexPath
        } else{
            indexOfExpandedSection = IndexPath(row: -1, section: -1)
        }
        self.tblRecordings.delegate = self
        self.tblRecordings.dataSource = self
        self.tblRecordings.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view: RecordingsTableViewHeader = UIView.fromNib()
        //        view.setupHeader(title: recordingsHistorySections[section])
        view.setupHeader(title: sectionsToBeDisplayed[section])
        return view
    }
    
    
}

extension RecordingHistoryVC : playVideoDelegate{
    
    //MARK: PLAY VIDEO
    func playVideoWithUrl(url: String , videoName: String) {
        if #available(iOS 14.2, *) {
            
            // For checking id the video is in Documents Directory
            if let videoData = DocumentDirectory.getData(using: videoName).0, let videoLocalUrl = DocumentDirectory.getData(using: videoName).1 {
                print(videoData)
                
                let playerItem = AVPlayerItem(asset: videoData.toAVAsset())
                let videoPlayer = AVPlayer(playerItem: playerItem)
                let videoPlayerViewController = AVPlayerViewController()
                videoPlayerViewController.player = videoPlayer
                videoPlayerViewController.canStartPictureInPictureAutomaticallyFromInline = true
                videoPlayerViewController.exitsFullScreenWhenPlaybackEnds = false
                self.present(videoPlayerViewController, animated: true) {
                    videoPlayerViewController.player?.play()
                }
                
            }else{
                let params : [String: String] = ["url": Global.shared.selectedCapture.videoUrl]
                ServiceManager.shared.getOverlayVideo(parameters: params, success: { [self] response in
                    let data = response as? String
                    if let overlayUrl = data{
                        
                        self.hideIndicator()
                        self.playVideo(url: overlayUrl)
                        
                    }
                }, failure: { error in
                    self.showPopupAlert(title: "Error", message: error.message, btnOkTitle: "Ok")
                })
            }
            
        } else {
            
        }
    }
    
}

extension RecordingHistoryVC : UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == self.txtToDate && self.txtToDate.text!.isEmpty && !self.txtFromDate.text!.isEmpty){
            let range = self.fromDate...Date()
            for date in self.captureDates{
                if(range.contains(date)){
                    self.filteredCaptureDates.append(date)
                }
            }
        }
        else if(textField == self.txtFromDate && self.txtFromDate.text!.isEmpty && !self.txtToDate.text!.isEmpty){
            let range = "01/01/2022".dateFromStringInSlashes()...self.toDate
            for date in self.captureDates{
                if(range.contains(date)){
                    self.filteredCaptureDates.append(date)
                }
            }
        }
        self.getCountPerSection()
        self.checkNoRecordFound()
        self.tblRecordings.delegate = self
        self.tblRecordings.dataSource = self
        self.tblRecordings.reloadData()
    }
}

extension RecordingHistoryVC: MoveToRespectiveVC{
    func moveToReport(capture: CaptureModel) {
        let vc = PdfViewController.initFrom(storyboard: .recording)
        vc.capture = capture
        self.pushViewController(vc: vc)
    }
    
    func moveToPreview(capture: CaptureModel) {
        
        self.showIndicator(withTitle: "Checking Status")
        Global.shared.selectedCapture = capture
        Global.shared.selectedSwingType = SwingType(id: capture.swingTypeId.toString(), name: "")
        // Check socket here
        connectAndRequestSocket()
    }
    
    func connectAndRequestSocket() {
        var request = URLRequest(url: URL(string: ServiceUrls.socketUrl)!)
        request.httpShouldUsePipelining = true
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
    }
}

//MARK: Web Sockets
extension RecordingHistoryVC: WebSocketDelegate {
    
    func createAction() {
        
        let strChannel = "{ \"action\": \"status\",\"file_id\": \"\(Global.shared.selectedCapture.videoUrl)\" }"
        print(strChannel)
        self.socket?.write(string: strChannel)
    }
    
    func updateCurrentStatus(status: String) {
        self.hideIndicator()
        socket?.disconnect()
        
        if let dict = status.toDictionary(){
            let status = dict["status"] as! String
            
            if status == "uploaded"{
                self.showPopupAlert(title: "Processing", message: "Video has been uploaded. Please wait...")
                
            } else if status == "processing"{
                self.showPopupAlert(title: "Processing", message: "Generating results. Please wait...")
                
            }else if status == "done"{
                
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    let vc = RecordingOverlayPreviewViewController.initFrom(storyboard: .recording)
                    vc.strikerBase = self.striker
                    vc.capture = Global.shared.selectedCapture
                    self.pushViewController(vc: vc)
                }
                
            }else if status == "error"{
                self.showPopupAlert(title: "Error", message: "You have uploaded the video with wrong metadata. Please record again", btnOkTitle: "Ok", onOK:  {
                    self.socket?.disconnect()
                    AppDelegate.app.moveToDashboard()
                })
            }
        }
    }
    
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocket) {
        
        socket?.onEvent = { event in
            switch event {
                // handle events just like above...
            case .connected(let headers):
                self.isConnected = true
                self.createAction()
                print("websocket is connected: \(headers)")
            case .disconnected(let reason, let code):
                self.isConnected = false
                print("websocket is disconnected: \(reason) with code: \(code)")
            case .text(let string):
                print("Received text: \(string)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    self.createAction()
                    self.updateCurrentStatus(status: string)
                })
            case .binary(let data):
                print("Received data: \(data.count)")
            case .ping(_):
                break
            case .pong(_):
                break
            case .viabilityChanged(_):
                break
            case .reconnectSuggested(_):
                break
            case .cancelled:
                self.isConnected = false
            case .error(let error):
                self.isConnected = false
                print(error as Any)
            }
        }
    }
    
}

//MARK: SERVER RESPONSE
extension RecordingHistoryVC: ServerResponse{
    
    func onSuccess(json: JSON, val: String) {
        
        if val == "getVideos"{
            let arrRecordedVideosJson = json.arrayValue
            for each in arrRecordedVideosJson{
                let temp = CaptureModel(json: each)
                self.serverVideos.append(temp)
            }
            
            (self.dateWiseCaptures, captureDates) = mapServerCapturesWRTDate()
            configure()
            self.lblTotalVideos.text = "Total Videos: \(serverVideos.count)"
            print(serverVideos.count)
            
        } else if val == "deleteVideo"{
            
//            self.deleteVideo(at: captureToDelete.videoUrl)
            
            self.serverVideos.removeAll(where: { $0.id == self.captureToDelete.id })
            (self.dateWiseCaptures, captureDates) = mapServerCapturesWRTDate()
            configure()
            self.lblTotalVideos.text = "Total Videos: \(serverVideos.count)"
            print(serverVideos.count)
        }
    }
}
