//
//  CoachesListViewController.swift
//  M2C
//
//  Created by Abdul Samad Butt on 22/12/2022.
//

import UIKit

class CoachesListViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var stackViewNoItem: UIStackView!
    @IBOutlet weak var tableViewCoaches: UITableView!
    @IBOutlet weak var segmentControlCoaches: UISegmentedControl!
    
    //MARK: VARIABLES
    var arrApprovedCoaches: [Coach] = [Coach]()
    var arrPendingCoaches: [Coach] = [Coach]()
    var arrCoaches: [Coach] = [Coach]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.getApprovedCoaches()
        }
    }
    
    
    //MARK: HELPERS
    func setupUI(){
        self.stackViewNoItem.hide()
        self.tableViewCoaches.hide()
        tableViewCoaches.delegate = self
        tableViewCoaches.dataSource = self
        segmentControlCoaches.defaultConfiguration()
        segmentControlCoaches.selectedConfiguration()
    }
    
    func getPendingCoaches(){
        let params: [String: Any] = ["loggedUserId" : Global.shared.loginUser?.userId as Any,
                                     "roleId" : Global.shared.loginUser?.roleId as Any,
                                     "accepted": false,
                                     "appVersion": (Bundle.main.releaseVersionNumber ?? ""),
                                     "deviceType": "iOS"]
        
        serverRequest.delegate = self
        serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.getAllowedUser, params: params, method: .post, type: "pending_coaches", loading: true, headerType: .headerWithAuth)
    }
    
    func getApprovedCoaches(){
        let params: [String: Any] = ["loggedUserId" : Global.shared.loginUser?.userId as Any,
                                     "roleId" : Global.shared.loginUser?.roleId as Any,
                                     "accepted": true,
                                     "appVersion": (Bundle.main.releaseVersionNumber ?? ""),
                                     "deviceType": "iOS"]
        
        serverRequest.delegate = self
        serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.getAllowedUser, params: params, method: .post, type: "accepted_coaches", loading: true, headerType: .headerWithAuth)
    }
    
    func rejectInvite(id: Int){
        let params: [String: Any] = ["loggedUserId" : Global.shared.loginUser?.userId as Any,
                                     "roleId" : Global.shared.loginUser?.roleId as Any,
                                     "otherUserId": id]
        
        serverRequest.delegate = self
        serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.removeCoach, params: params, method: .post, type: "reject_invite", loading: true, headerType: .headerWithAuth)
    }
    
    func acceptInvite(id: String){
        let params: [String: Any] = ["loggedUserId" : Global.shared.loginUser?.userId as Any,
                                     "userId" : id,
                                     "roleId": Global.shared.loginUser?.roleId as Any]
        
        serverRequest.delegate = self
        serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.acceptInvite, params: params, method: .post, type: "accept_invite", loading: true, headerType: .headerWithAuth)
    }
 
    //MARK: ACTIONS
    @IBAction func btnBackClicked(_ sender: Any) {
        self.popViewController()
    }
    
    @IBAction func segmentControlCoach(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            // For Accepted Coaches
            getApprovedCoaches()
            
        case 1:
            // For Pending coaches
            getPendingCoaches()
            
        default:
            break
        }
    }
    
}

extension CoachesListViewController: CoachProtocol{
    func acceptCoach(coach: Coach) {
        print("Coach Accepted")
        self.acceptInvite(id: coach.coachId)
    }
    
    func rejectCoach(coach: Coach) {
        print("Coach Rejected")
        self.rejectInvite(id: coach.coachId.toInt())
    }
    
}

//MARK: TABLE VIEW METHODS
extension CoachesListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCoaches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(with: CoachListTableViewCell.self, for: indexPath)
        cell.delegate = self
        
        if segmentControlCoaches.selectedSegmentIndex == 0{
            cell.setupCell(coach: arrCoaches[indexPath.row], status: "Approved")
        } else{
            cell.setupCell(coach: arrCoaches[indexPath.row], status: "Pending")
        }
        return cell
    }
    
}

//MARK: SERVER RESPONSE
extension CoachesListViewController: ServerResponse{
    
    func onSuccess(json: JSON, val: String) {
        print(json)
        
        arrCoaches.removeAll()
        arrApprovedCoaches.removeAll()
        arrPendingCoaches.removeAll()
        
        if val == "accepted_coaches"{
            
            let jsonArray = json.arrayValue
            jsonArray.forEach { each in
                let tempCoach = Coach(json: each)
                self.arrApprovedCoaches.append(tempCoach)
            }
            arrCoaches = arrApprovedCoaches
            
            if arrCoaches.isEmpty{
                stackViewNoItem.unhide()
            }else{
                stackViewNoItem.hide()
            }
            
        }else if val == "pending_coaches"{
            let jsonArray = json.arrayValue
            jsonArray.forEach { each in
                let tempCoach = Coach(json: each)
                self.arrPendingCoaches.append(tempCoach)
            }
            arrCoaches = arrPendingCoaches
            if arrCoaches.isEmpty{
                stackViewNoItem.unhide()
            }else{
                stackViewNoItem.hide()
            }
             
        }else if val == "accept_invite"{
            if segmentControlCoaches.selectedSegmentIndex == 0{
                getApprovedCoaches()
            } else{
                getPendingCoaches()
            }
            
        }else if val == "reject_invite"{
            if segmentControlCoaches.selectedSegmentIndex == 0{
                getApprovedCoaches()
            } else{
                getPendingCoaches()
            }
            
        }
        
        self.tableViewCoaches.unhide()
        self.tableViewCoaches.reloadData()
        
    }
    
}
