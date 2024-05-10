//
//  StoryBoard.swift
//  UPaisa
//
//  Created by MACBOOK on 12/05/2020.
//  Copyright © 2020 Zeeshan Ashraf. All rights reserved.
//

import Foundation
import UIKit
// MARK: StoryBoard
extension UIStoryboard {
    
    class func controller<T: UIViewController>() -> T {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: T.className) as! T
    }
}

public extension UIStoryboard {
   
    //MARK:- Define All App Storyboards here
    enum Storyboard: String {
        case auth = "Main"
        case general = "General"
        case recording = "Recordings"
        case sideMenu = "SideMenu"
        case popups = "PopUps"
        case dashboard = "Dashboard"
        case captures = "Captures"
        
        var filename: String {
            return rawValue
        }
    }
    
    convenience init(Storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: Storyboard.filename, bundle: bundle)
    }
   
}
