//
//  CustomSideMenuNavigationController.swift
//  M2C
//
//  Created by Abdul Samad Butt on 09/09/2022.
//

import Foundation
import SideMenu

class CustomSideMenuNavigationController: SideMenuNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBarHidden(true, animated: false)

        self.presentationStyle = .menuSlideIn
        self.presentationStyle.backgroundColor = .black
        self.presentationStyle.presentingEndAlpha = 0.4

        self.statusBarEndAlpha = 0.0
        self.menuWidth = (UIScreen.main.bounds.width / 5) * 3.5
    }

}
