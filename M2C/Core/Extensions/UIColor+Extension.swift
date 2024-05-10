//
//  ColorExtension.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 10/05/2022.
//

import Foundation
import UIKit
extension UIColor {
    
    // Primary Color
    static var primary : UIColor {
        return UIColor(named: "APP_Color_1")!
    }
    
    // Secondary Color
    static var secondary : UIColor {
        return UIColor(named: "APP_Color_2")!
    }
    
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static let backgroundColor = UIColor.rgb(r: 21, g: 22, b: 33)
    static let outlineStrokeColor = UIColor.rgb(r: 234, g: 46, b: 111)
    static let trackStrokeColor = UIColor.rgb(r: 56, g: 25, b: 49)
    static let pulsatingFillColor = UIColor.rgb(r: 86, g: 30, b: 63)
    
    
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    /**
     This method returns colors modified by percentage value of color represented by the current object.
     */
    func getModified(byPercentage percent: CGFloat) -> UIColor? {
        
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        // Returns the color comprised by percentage r g b values of the original color.
        let colorToReturn = UIColor(displayP3Red: min(red + percent / 100.0, 1.0), green: min(green + percent / 100.0, 1.0), blue: min(blue + percent / 100.0, 1.0), alpha: 1.0)
        return colorToReturn
    }
    
    class var editPositionsRedColor: UIColor{
        return UIColor(hexString: "#F63E50")
    }
    
    class var editPositionsGreenColor: UIColor{
        return UIColor(hexString: "#7BB728")
    }
    
    class var editPositionsYellowColor: UIColor{
        return UIColor(hexString: "#F4BD00")
    }
    
    class var positionsSelectedColor: UIColor{
        return UIColor(hexString: "#87AFD2")
    }
    
    class var fenrisBlue: UIColor{
        return UIColor(hexString: "#006AB3")
    }
    
    class var reportBlue: UIColor{
        return UIColor(hexString: "#006AB3")
    }
    
    class var reportYellow: UIColor{
        return UIColor(hexString: "#F4BD00")
    }
    
    class var reportGreen: UIColor{
        return UIColor(hexString: "#7BB728")
    }
    
    class var fenrisGrey: UIColor{
        return UIColor(hexString: "#ABA7AF")
    }
    
    class var buttonDeactiveColor: UIColor{
        return UIColor(hexString: "#8cb3d6")
    }
    
}
