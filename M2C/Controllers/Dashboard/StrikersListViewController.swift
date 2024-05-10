//
//  StrikersListViewController.swift
//  M2C
//
//  Created by Abdul Samad Butt on 22/12/2022.
//

import UIKit

class StrikersListViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var tableViewStriker: UITableView!
    @IBOutlet weak var stackViewNoItems: UIStackView!
    @IBOutlet weak var segmentControlStriker: UISegmentedControl!
    
    //MARK: VARIABLES
    var arrApprovedStrikers: [Striker] = [Striker]()
    var arrPendingStrikers: [Striker] = [Striker]()
    var arrStrikers: [Striker] = [Striker]()
    var userIdToDelete: Int?
    
    //MARK: VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.disableSwipeBackFromLeftEdge()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        setupUI()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.getApprovedStrikers()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableViewStriker.reloadData()
    }
    
    func setupUI(){
        self.stackViewNoItems.hide()
        tableViewStriker.delegate = self
        tableViewStriker.dataSource = self
        segmentControlStriker.defaultConfiguration()
        segmentControlStriker.selectedConfiguration()
        tableViewStriker.hide()
    }
    
    func getPendingStrikers(){
        let params: [String: Any] = ["loggedUserId" : Global.shared.loginUser?.userId as Any,
                                     "roleId" : Global.shared.loginUser?.roleId as Any,
                                     "accepted": false,
                                     "appVersion": (Bundle.main.releaseVersionNumber ?? ""),
                                     "deviceType": "iOS"]
        
        serverRequest.delegate = self
        serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.getAllowedUser, params: params, method: .post, type: "pending_strikers", loading: true, headerType: .headerWithAuth)
    }
    
    func getApprovedStrikers(){
        let params: [String: Any] = ["loggedUserId" : Global.shared.loginUser?.userId as Any,
                                     "roleId" : Global.shared.loginUser?.roleId as Any,
                                     "accepted": true,
                                     "appVersion": (Bundle.main.releaseVersionNumber ?? ""),
                                     "deviceType": "iOS"]
        
        serverRequest.delegate = self
        serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.getAllowedUser, params: params, method: .post, type: "approved_strikers", loading: true, headerType: .headerWithAuth)
    }
    
    func acceptInvite(userId: String){
        let params: [String: Any] = ["loggedUserId" : Global.shared.loginUser?.userId as Any,
                                     "userId" : userId,
                                     "roleId": Global.shared.loginUser?.roleId as Any]
        
        serverRequest.delegate = self
        serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.acceptInvite, params: params, method: .post, type: "accept_invite", loading: true, headerType: .headerWithAuth)
    }
    
    func rejectInvite(userId: Int){
        self.userIdToDelete = userId
        
        let params: [String: Any] = ["loggedUserId" : Global.shared.loginUser?.userId as Any,
                                     "roleId" : Global.shared.loginUser?.roleId as Any,
                                     "otherUserId": userId]
        
        serverRequest.delegate = self
        serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.removeCoach, params: params, method: .post, type: "reject_invite", loading: true, headerType: .headerWithAuth)
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
//        Global.shared.selectedStriker = nil
        self.popViewController()
    }
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            // For Accepted Strikers
            getApprovedStrikers()
            
        case 1:
            // For Pending Strikers
            getPendingStrikers()
            
        default:
            break
        }
    }
    
}

//MARK: TABLE VIEW METHODS
extension StrikersListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrStrikers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: StrikerListTableViewCell.self, for: indexPath)
        cell.delegate = self
        if segmentControlStriker.selectedSegmentIndex == 0{
            cell.setupCell(striker: arrStrikers[indexPath.row], status: "Approved")
        } else{
            cell.setupCell(striker: arrStrikers[indexPath.row], status: "Pending")
        }
        
        
        return cell
    }
    
}

//MARK: Striker Protocol
extension StrikersListViewController: StrikerProtocol{
    
    func acceptStriker(striker: Striker) {
        print("\(striker.useremail) accepted")
        self.acceptInvite(userId: striker.userId)
    }
    
    func rejectStriker(striker: Striker) {
        print("\(striker.useremail) rejected")
        
        self.showPopupAlert(title: "Alert!", message: "Are you sure you want to delete the striker", btnOkTitle: "Yes", btnCancelTitle: "No", onOK: {
            self.rejectInvite(userId: striker.userId.toInt())
        })
        
    }
    
    func openHistory(striker: Striker) {
        print("Open History")
        
        
        if Global.shared.selectedStriker != nil {
            
            // If striker is already selected then deselect the striker
            Global.shared.selectedStriker = nil
            self.tableViewStriker.reloadData()
            
        }else{
            // If striker is not selected then select the striker and move to next screen
            Global.shared.selectedStriker = striker
            
//            AppDelegate.app.moveToDashboard()
            let vc = DashbaordOptionsVC.initFrom(storyboard: .dashboard)
            self.pushViewController(vc: vc)
        }
        
        
    }
}

//MARK: SERVER RESPONSE
extension StrikersListViewController: ServerResponse{
    
    func onSuccess(json: JSON, val: String) {
        print(json)
        arrStrikers.removeAll()
        arrApprovedStrikers.removeAll()
        arrPendingStrikers.removeAll()
        
        if val == "approved_strikers"{
            
            let jsonArray = json.arrayValue
            jsonArray.forEach { each in
                let tempStriker = Striker(json: each)
                self.arrApprovedStrikers.append(tempStriker)
            }
            
            arrStrikers = arrApprovedStrikers
            if arrStrikers.isEmpty{
                stackViewNoItems.unhide()
            }else{
                stackViewNoItems.hide()
            }
            
        }else if val == "pending_strikers"{
            
            
            let jsonArray = json.arrayValue
            jsonArray.forEach { each in
                let tempStriker = Striker(json: each)
                self.arrPendingStrikers.append(tempStriker)
            }
            arrStrikers = arrPendingStrikers
            if arrStrikers.isEmpty{
                stackViewNoItems.unhide()
            }else{
                stackViewNoItems.hide()
            }
             
        }else if val == "accept_invite"{
            if segmentControlStriker.selectedSegmentIndex == 0{
                getApprovedStrikers()
            } else{
                getPendingStrikers()
            }
            
        }else if val == "reject_invite"{
            
            if Global.shared.selectedStriker?.userId == self.userIdToDelete?.toString() {
                Global.shared.selectedStriker = nil
            }
            
            if segmentControlStriker.selectedSegmentIndex == 0{
                getApprovedStrikers()
            } else{
                getPendingStrikers()
            }
            
        }
        
        self.tableViewStriker.unhide()
        self.tableViewStriker.reloadData()
        
    }
    
}
