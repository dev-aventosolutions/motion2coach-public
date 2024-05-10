//
//  ImageExtension.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 10/05/2022.
//

import Foundation
import SDWebImage
import Alamofire
import UIKit

extension UIImageView{
    
    func downloadImage(imageUrl : String!, placeHolder: String) {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = self.center
        self.addSubview(activityIndicator)
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        
        activityIndicator.startAnimating()
        
        if imageUrl != nil{
            let url = URL(string: imageUrl)
            self.sd_setImage(with: url, completed: { (image, err, type,url) in
                
                if err != nil {
                    self.sd_imageIndicator?.stopAnimatingIndicator()
                    self.image = UIImage(named: placeHolder)
                    print("Failed to download image",err?.localizedDescription as Any)
                } else{
                    self.image = image ?? UIImage(named: placeHolder)
                }
                self.sd_imageIndicator?.stopAnimatingIndicator()
                activityIndicator.stopAnimating()
            })
        }
    }

}
