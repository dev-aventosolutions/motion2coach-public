//
//  GoogleManager.swift
//  Shopavize
//
//  Created by Abdul Samad on 10/05/2021.
//

import Foundation
//import GooglePlaces
import CoreLocation
import StoreKit

//final class GoogleManager: NSObject, UINavigationControllerDelegate, GMSAutocompleteViewControllerDelegate {
//    
//    static let shared = GoogleManager()
//    var googlePalcesCallBack : ((GMSPlace, String) -> ())?
//    var currentLocation: CLLocation?
//    var suggestedAddress: String = ""
//
//    override init(){
//        super.init()
//        
//    }
//        
//    //MARK: Places Method
//    func getGooglePlaces(_ viewController: UIViewController, _ callback: @escaping ((GMSPlace, String) -> ())) {
//        googlePalcesCallBack = callback
//        let autocompleteController = GMSAutocompleteViewController()
//        autocompleteController.delegate = self
////         Specify a filter.
//        let filter = GMSAutocompleteFilter()
//        filter.country = "US"
//        autocompleteController.autocompleteFilter = filter
//    
//        viewController.present(autocompleteController, animated: true, completion: nil)
//    }
//    
//    func viewController(_ viewController: GMSAutocompleteViewController, didSelect prediction: GMSAutocompletePrediction) -> Bool {
//        suggestedAddress = prediction.attributedFullText.string
//        return true
//    }
//    
//    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        viewController.dismiss(animated: true) {
//            
//            self.googlePalcesCallBack!(place, self.suggestedAddress)
//        }
//    }
//    
//    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
//        print(error.localizedDescription)
//    }
//    
//    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
//        viewController.dismiss(animated: true, completion: nil)
//    }
//}
