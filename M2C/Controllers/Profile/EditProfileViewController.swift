//
//  EditProfileViewController.swift
//  M2C
//
//  Created by Abdul Samad Butt on 24/08/2022.
//

import UIKit

protocol EditProfileProtocol: AnyObject{
    func profileUpdated(user: UserDetails, profileImage: UIImage)
}

extension EditProfileProtocol{
    func profileUpdated(user: UserDetails, profileImage: UIImage){}
}

class EditProfileViewController: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var inputFirstName: UITextField!
    @IBOutlet weak var inputLastName: UITextField!
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputRole: UITextField!
    @IBOutlet weak var inputPhoneNum: UITextField!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var inputHandedness: UITextField!
    @IBOutlet weak var inputStreet: UITextField!
    @IBOutlet weak var inputHouseNum: UITextField!
    @IBOutlet weak var inputZipCode: UITextField!
    @IBOutlet weak var inputCountry: UITextField!
    @IBOutlet weak var inputCity: UITextField!
    @IBOutlet weak var inputHeight: UITextField!
    @IBOutlet weak var inputWeight: UITextField!
    
    
    //MARK: VARIABLES
    var userDetails = UserDetails()
    weak var delegate: EditProfileProtocol?
    var selectedCountry: Country?
    var arrCountries = [Country]()
    var selectedCity = City()
    var arrCities = [City]()
    var signedUrl: String = ""
    var publicUrl: String = ""
    var pickedImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        getMasterData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    private func setupUI(){
        // To load cities for the first time
        selectedCountry = Country()
        selectedCountry?.id = userDetails.countryId
        if let countryId = selectedCountry?.id {
            self.getCities(countryId: countryId)
        }
        
        self.inputHeight.inputNumbersOnly()
        self.inputWeight.inputNumbersOnly()
        
        self.inputFirstName.text = userDetails.firstName ?? ""
        self.inputLastName.text = userDetails.lastName ?? ""
        self.inputPhoneNum.text = userDetails.contactNumber
        self.inputEmail.text = userDetails.email
        self.inputRole.text = userDetails.role
        self.inputHandedness.text = userDetails.playerType
        self.inputStreet.text = userDetails.address
        self.inputHouseNum.text = userDetails.houseNo
        self.inputZipCode.text = userDetails.postCode
        self.inputCountry.text = userDetails.country
        self.inputCity.text = userDetails.city
        self.inputCountry.isUserInteractionEnabled = false
        self.inputCity.isUserInteractionEnabled = false
        self.selectedCity.id = userDetails.cityId
        self.imgUser.downloadImage(imageUrl: userDetails.picture, placeHolder: "smProfile")
        
        // If striker is selected
//        if let selectedStriker = Global.shared.selectedStriker{
//            inputWeight.text = selectedStriker.weight
//            inputHeight.text = selectedStriker.height
//        }else{
//            // If video is getting uploaded for user himself
//            inputWeight.text = Global.shared.loginUser?.weight
//            inputHeight.text = Global.shared.loginUser?.height
//        }
    }
    
    private func getMasterData(){
        
        serverRequest.delegate = self
        serverRequest.requestGETAPI(vc: self, url: ServiceUrls.URLs.getMasterData, method: .get, type: "master_data", loading: false, headerType: .headerWithoutAuth)
    }
    
    private func getCities(countryId: String){
        GetCitiesRequest.shared.countryId = countryId
        
        serverRequest.delegate = self
        serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.getCities, params: GetCitiesRequest.shared.returnCitiesParams(), method: .post, type: "cities", loading: true, headerType: .headerWithoutAuth)
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func btnCameraClicked(_ sender: Any) {
        ImagePickerManager().pickImage(self) { pickedImage in
            let image = pickedImage.resizeWithWidth(width: 700)
            self.pickedImage = image
            self.imgUser.image = image
        }
    }
    
    @IBAction func btnUpdateClicked(_ sender: Any) {
        
        if inputWeight.text!.isEmpty || inputHeight.text!.isEmpty{
            
            showPopupAlert(title: "Alert!", message: "Height or Weight cannot be empty")
        }else{
            // First check is there any update in profile picture. If there is any change then first get the public url
            if let image = pickedImage{
                // Step 1 of Image Upload
                UploadMediaRequest.shared.fileMimeType = image.pngRepresentationData?.mimeType ?? ""
                UploadMediaRequest.shared.fileName = SignUpRequest.shared.firstName + "uploaded" + ".png"
                
                serverRequest.delegate = self
                serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.uploadMedia, params: UploadMediaRequest.shared.returnUploadMediaParams(), method: .post, type: "uploadMedia", loading: true, headerType: .headerWithoutAuth)
                
            } else{
                UpdateUserRequest.shared.picture = userDetails.picture ?? ""
                self.updateUser()
            }
        }
        
    }
    
    private func updateUser(){
        UpdateUserRequest.shared.firstName = inputFirstName.text ?? ""
        UpdateUserRequest.shared.lastName = inputLastName.text ?? ""
        UpdateUserRequest.shared.contactNum = inputPhoneNum.text ?? ""
        UpdateUserRequest.shared.address = inputStreet.text ?? ""
        UpdateUserRequest.shared.houseNo = inputHouseNum.text ?? ""
        UpdateUserRequest.shared.postCode = inputZipCode.text ?? ""
        UpdateUserRequest.shared.city = selectedCity.id ?? "0"
        
        UpdateUserRequest.shared.roleId = userDetails.roleId ?? ""
        UpdateUserRequest.shared.genderId = userDetails.genderId ?? "4"
        UpdateUserRequest.shared.playerTypeId = userDetails.playerTypeId ?? ""
        UpdateUserRequest.shared.dateOfBirth = userDetails.dateOfBirth?.dateTimeChangeFormat(inDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", outDateFormat: "yyyy-MM-dd") ?? ""
        UpdateUserRequest.shared.email = userDetails.email ?? ""
        
        serverRequest.delegate = self
        serverRequest.requestWithHeaderandBody(vc: self, url: ServiceUrls.baseUrlM2c + ServiceUrls.URLs.updateUser, params: UpdateUserRequest.shared.returnUpdateUserRequestParams(), method: .post, type: "update", loading: true, headerType: .headerWithAuth)
    }
    
    
    @IBAction func btnCountryClicked(_ sender: Any) {
        let vc = CountriesListViewController.initFrom(storyboard: .auth)
        vc.delegate = self
        vc.arrCountries = arrCountries
        present(vc, animated: true)
    }
    
    @IBAction func btnCityClicked(_ sender: Any) {
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
    
    
    @IBAction func inputDidEndChange(_ sender: UITextField) {
        inputPhoneNum.inputNumbersOnly()
    }
}

//MARK: GENERAL LIST METHODS
extension EditProfileViewController: CountriesListProtocol, GeneralListProtocol{
    
    // On selecting Country
    func countrySelect(country: Country) {
        
        selectedCountry = country
        inputCountry.text = "\(selectedCountry?.sortName?.showFlag() ?? "")   \(selectedCountry?.name ?? "")"
        inputCity.text = ""
        self.getCities(countryId: selectedCountry?.id ?? "")
        
    }
    
    // On selecting City
    func itemSelect(item: String, screenTitle: String) {
        if screenTitle == "Cities"{
            inputCity.text = item
            
            selectedCity = arrCities.first(where: {$0.name == item}) ?? City()
        }
        
    }
}

//MARK: SERVER RESPONSE
extension EditProfileViewController: ServerResponse{
    
    func onSuccess(json: JSON, val: String) {
        if val == "update"{
            
            print(json)
            
            if let del = delegate{
                let userDetails = UserDetails(json: json)
                Global.shared.loginUser?.picturePath = userDetails.picture ?? ""
                Global.shared.loginUser?.firstName = userDetails.firstName ?? ""
                Global.shared.loginUser?.lastName = userDetails.lastName ?? ""
                
                // If striker is selected
//                if Global.shared.selectedStriker != nil{
//                    Global.shared.selectedStriker?.weight = inputWeight.text ?? "0"
//                    Global.shared.selectedStriker?.height = inputHeight.text ?? "0"
//                }else{
//                    // If video is getting uploaded for user himself
//                    Global.shared.loginUser?.weight = self.inputWeight.text ?? ""
//                    Global.shared.loginUser?.height = self.inputHeight.text ?? ""
//
//                    guard let user = Global.shared.loginUser else {return}
//                    userDefault.saveUser(user: user)
//                }
                
                del.profileUpdated(user: userDetails, profileImage: self.imgUser.image ?? UIImage())
            }
            
            self.dismiss(animated: true)
        } else if val == "master_data" {
            
            // For Countries
            arrCountries.removeAll()
            let countriesJsonArray = json["countries"].arrayValue
            countriesJsonArray.forEach({ arrCountries.append(Country(json: $0)) })
            inputCountry.isUserInteractionEnabled = false
            
        } else if val == "cities"{
            
            let arrCityJSON = json.arrayValue
            inputCity.text?.removeAll()
            arrCities.removeAll()
            arrCityJSON.forEach({ arrCities.append(City(json: $0)) })
            inputCity.text = arrCities.first(where: { $0.name == userDetails.city })?.name
            inputCity.isUserInteractionEnabled = true
            if let city = arrCities.first{
                selectedCity = city
                inputCity.text = city.name
            }
        }
        // For updating profile picture
        else if val == "uploadMedia"{
            self.publicUrl = json["publicUrl"].stringValue
            self.signedUrl = json["signedUrl"].stringValue
            
            // Step 2 of Image Upload
            if let imageData = pickedImage?.pngRepresentationData{
                ServiceManager.shared.multipartRequestForImage(vc: self, url: signedUrl, imageBinary: imageData, loading: true) { response in
                    
                    UpdateUserRequest.shared.picture = self.publicUrl
                    self.updateUser()
                    
                } failure: { error in
                    self.showPopupAlert(title: "Error", message: "Image Uploading Failed")
                }
            }
        }
        
    }
}
