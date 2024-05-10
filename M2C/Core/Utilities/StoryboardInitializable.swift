//
//  StoryboardInitializable.swift
//  ODIE
//
//  Created by Abdul Samad on 05/10/2021.
//

import Foundation
import UIKit

protocol StoryboardInitializable: AnyObject {
    static var storyboardIdentifier: String { get }
}

extension StoryboardInitializable where Self: UIViewController {

    static var storyboardIdentifier: String {
        return String(describing: Self.self)
    }

    static func initFromStoryboard(name: String = "Main") -> Self {
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }

    static func initFrom(storyboard: UIStoryboard.Storyboard) -> Self {
        return initFromStoryboard(name: storyboard.filename)
    }
}

