//
//  CountriesListViewController.swift
//  M2C
//
//  Created by Abdul Samad Butt on 14/11/2022.
//

import UIKit

protocol CountriesListProtocol{
    func countrySelect(country: Country)
}

class CountriesListViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var tableViewCountries: UITableView!
    @IBOutlet weak var inputSearch: UITextField!
    
    
    //MARK: VARIABLESm
    var originalCountries: [Country] = [Country]()
    var arrCountries: [Country] = [Country]()
    var delegate: CountriesListProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalCountries = arrCountries
        inputSearch.delegate = self
        tableViewCountries.delegate = self
        tableViewCountries.dataSource = self
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate = nil
    }

    @IBAction func btnBackClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        if sender.text!.isEmpty{
            self.arrCountries = originalCountries
        }else{
            self.arrCountries = search(keyword: sender.text!)
        }
        tableViewCountries.reloadData()
    }
}

//MARK: UITABLEVIEW DELEGATE
extension CountriesListViewController: UITextFieldDelegate{
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text!.isEmpty{
            self.arrCountries = originalCountries
        }else{
            self.arrCountries = search(keyword: textField.text!)
        }
        tableViewCountries.reloadData()
    }
    
    /* Search the given keyword from TableView using contains */
    func search(keyword: String) -> [Country] {
        var searchResults = [Country]()

        self.originalCountries.forEach { country in

            if let name = country.name{
                if name.localizedCaseInsensitiveContains(keyword){
                    searchResults.append(country)
                }
            }
        }
        return searchResults
    }
    
}

//MARK: UITABLEVIEW DELEGATE
extension CountriesListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: GeneralListTableViewCell.self, for: indexPath)
        
        cell.setupCell(country: arrCountries[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let del = delegate{
            del.countrySelect(country: arrCountries[indexPath.row])
            dismiss(animated: true)
        }
    }
}
