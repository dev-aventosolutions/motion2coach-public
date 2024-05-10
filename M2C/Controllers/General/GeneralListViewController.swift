//
//  GeneralListViewController.swift
//  M2C
//
//  Created by Abdul Samad Butt on 14/11/2022.
//

import UIKit

protocol GeneralListProtocol{
    func itemSelect(item: String, screenTitle: String)
}

class GeneralListViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var tableViewList: UITableView!
    @IBOutlet weak var txtHeader: UILabel!
    @IBOutlet weak var inputSearch: UITextField!
    
    
    //MARK: VARIABLES
    var originalData: [String] = [""]
    var data: [String] = [""]
    var delegate: GeneralListProtocol?
    var headerTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalData = data
        inputSearch.delegate = self
        tableViewList.delegate = self
        tableViewList.dataSource = self
        if let headerTitle = headerTitle {
            txtHeader.text = headerTitle
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate = nil
    }

    @IBAction func btnBackClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
}

//MARK: UITABLEVIEW DELEGATE
extension GeneralListViewController: UITextFieldDelegate{
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        if sender.text!.isEmpty{
            self.data = originalData
        }else{
            self.data = search(keyword: sender.text!)
        }
        tableViewList.reloadData()
    }
    
    /* Search the given keyword from TableView using contains */
    func search(keyword: String) -> [String] {
        var searchResults = [String]()
        
        self.originalData.forEach { searchString in
            if searchString.localizedCaseInsensitiveContains(keyword){
                searchResults.append(searchString)
            }
        }
        
        return searchResults
    }
}

//MARK: UITABLEVIEW DELEGATE
extension GeneralListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: GeneralListTableViewCell.self, for: indexPath)
        
        cell.setupCell(item: data[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let del = delegate{
            del.itemSelect(item: data[indexPath.row], screenTitle: headerTitle ?? "")
            dismiss(animated: true)
        }
    }
}
