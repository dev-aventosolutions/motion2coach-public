//
//  SignUpAddressVC.swift
//  M2C
//
//  Created by Abdul Samad Butt on 19/07/2022.
//

import UIKit

class SignUpAddressVC: BaseVC {

    @IBOutlet weak var inputZipCode: UITextField!
    @IBOutlet weak var inputHouseNumber: UITextField!
    @IBOutlet weak var inputStreet: UITextField!
    @IBOutlet weak var inputCity: UITextField!
    @IBOutlet weak var inputCountries: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var inputPhoneNum: UITextField!
    
    var arrCountries = [Country]()
    var selectedCountry: Country?
    var selectedCity: City?
    var arrCities = [City]()
    var pickerViewCountry = UIPickerView()
    private var countryPickerIndex:Int = 0
    var pickerViewCities = UIPickerView()
    private var cityPickerIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI(){
//        getCountries()
//        btnNext.makeButtonDeactive()
//        inputCountries.delegate = self
//        pickerViewCountry.delegate = self
//        pickerViewCountry.dataSource = self
//        inputCountries.inputView = pickerViewCountry
//        inputCountries.isUserInteractionEnabled = false
        self.pickerViewCities.delegate = self
        self.pickerViewCities.dataSource = self
        self.inputCity.delegate = self
        self.inputCity.inputView = pickerViewCities

        self.inputCity.isUserInteractionEnabled = false
        self.addAsteriksToFields()
    }
    
    func addAsteriksToFields() {
//        self.addRedAsterik(textField: inputZipCode)
//        self.addRedAsterik(textField: inputHouseNumber)
//        self.addRedAsterik(textField: inputStreet)
//        self.addRedAsterik(textField: inputCity)
//        self.addRedAsterik(textField: inputCountries)
//        self.addRedAsterik(textField: inputPhoneNum)
        
    }
    
    private func getCountries(){
        serverRequest.delegate = self
        serverRequest.requestGETAPI(vc: self, url: ServiceUrls.URLs.getCountries, method: .get, type: "countries", loading: false, headerType: .headerWithoutAuth)
    }
    
    private func getCities(countryId: String){
        GetCitiesRequest.shared.countryId = countryId
        
        serverRequest.delegate = self
        serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.getCities, params: GetCitiesRequest.shared.returnCitiesParams(), method: .post, type: "cities", loading: true, headerType: .headerWithoutAuth)
    }
    
    @IBAction func btnNextClicked(_ sender: Any) {
        SignUpRequest.shared.address = inputStreet.text ?? ""
        SignUpRequest.shared.houseNo = inputHouseNumber.text ?? ""
        SignUpRequest.shared.postCode = (inputZipCode.text!.isEmpty ? "0" : (inputZipCode.text ?? "0" ))
        SignUpRequest.shared.city = selectedCity?.id ?? "0"
        SignUpRequest.shared.contactNumber = inputPhoneNum.text ?? ""
        
        let vc = SignUpAccountInfoVC.initFrom(storyboard: .auth)
        pushViewController(vc: vc)
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        popViewController()
    }
    
    @IBAction func btnCountryClicked(_ sender: Any) {
        
        let vc = CountriesListViewController.initFrom(storyboard: .auth)
        vc.delegate = self
        vc.arrCountries = arrCountries
        present(vc, animated: true)
    }
    
    
    @IBAction func btnCitiesClicked(_ sender: Any) {
        if selectedCountry != nil{
            if !arrCities.isEmpty{
                let vc = GeneralListViewController.initFrom(storyboard: .auth)
                vc.headerTitle = "Cities"
                vc.delegate = self
                
                var data = [String]()
                arrCities.forEach({data.append($0.name ?? "")})
                vc.data = data
                present(vc, animated: true)
            }else{
                showPopupAlert(title: "", message: "Loading Cities")
            }
        }else{
            showPopupAlert(title: "", message: "Select a country!")
        }
    }
    
}

//MARK: GENERAL LIST METHODS
extension SignUpAddressVC: CountriesListProtocol, GeneralListProtocol{
    
    // On selecting Country
    func countrySelect(country: Country) {
        
        selectedCountry = country
        inputCountries.text = "\(selectedCountry?.sortName?.showFlag() ?? "")   \(selectedCountry?.name ?? "")"
        inputCity.text = ""
        selectedCity = nil
        arrCities.removeAll()
        self.getCities(countryId: selectedCountry?.id ?? "")
        
        validateTextFields()
    }
    
    // On selecting City
    func itemSelect(item: String, screenTitle: String) {
        if screenTitle == "Cities"{
            inputCity.text = item
            
            selectedCity = arrCities.first(where: {$0.name == item})
        }
        validateTextFields()
    }
}

extension SignUpAddressVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == pickerViewCountry{
            return 1
        }else if pickerView == pickerViewCities{
            return 1
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerViewCountry{
            return arrCountries.count
        }else if pickerView == pickerViewCities{
            return arrCities.count
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerViewCountry{
            return arrCountries[row].name
        }else if pickerView == pickerViewCities{
            return arrCities[row].name
        }else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerViewCountry{
            countryPickerIndex = row
        }else if pickerView == pickerViewCities{
            cityPickerIndex = row
        }
    }
    
}

extension SignUpAddressVC: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == inputCountries{
            
            inputCountries.text = arrCountries[countryPickerIndex].name
            selectedCountry = arrCountries[countryPickerIndex]
            
            if let id = selectedCountry?.id{
                getCities(countryId: id)
            }
        }else if textField == inputCity{
            if !arrCities.isEmpty{
                inputCity.text = arrCities[cityPickerIndex].name
                selectedCity = arrCities[cityPickerIndex]
            }else{
                selectedCity = nil
            }
        }
    }
    
    //MARK: VALIDATIONS
    @IBAction func textFieldDidChange(_ sender: Any) {
        validateTextFields()
    }
    
    fileprivate func validateTextFields(){
        inputZipCode.inputNumbersOnly()
        
//        if inputStreet.text!.isEmpty || inputHouseNumber.text!.isEmpty || inputZipCode.text!.isEmpty || inputCountries.text!.isEmpty || inputCity.text!.isEmpty || inputPhoneNum.text!.isEmpty {
//            // If textfields are empty
//            btnNext.makeButtonDeactive()
//        } else {
//            // Checking validation
//            if inputZipCode.text!.isValid(.numbers) {
//                btnNext.makeButtonActive()
//            }else{
//                // If any textfield is invalid
//                btnNext.makeButtonDeactive()
//            }
//        }
    }
}

extension SignUpAddressVC: ServerResponse{
    
    func onSuccess(data: Data, val: String) {
        
    }
    
    func onSuccess(json: JSON, val: String) {
        if val == "countries"{
            print(json)
            let arrCountryJSON = json.arrayValue
            arrCountries.removeAll()
            arrCountryJSON.forEach({ arrCountries.append(Country(json: $0)) })
            inputCountries.isUserInteractionEnabled = true
            pickerViewCountry.reloadAllComponents()
            
        }else if val == "cities"{
            let arrCityJSON = json.arrayValue
            inputCity.text?.removeAll()
            arrCities.removeAll()
            arrCityJSON.forEach({ arrCities.append(City(json: $0)) })
            inputCity.isUserInteractionEnabled = true
            pickerViewCities.reloadAllComponents()
            if let city = arrCities.first{
                inputCity.text = city.name
                selectedCity = city
            }
        }
        
    }
}
