//
//  StringExtension.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 10/05/2022.
//

import Foundation
import UIKit

extension String {
    
    var bool: Bool? {
        switch self.lowercased() {
        case "true", "t", "yes", "y":
            return true
        case "false", "f", "no", "n", "":
            return false
        default:
            if let int = Int(self) {
                return int != 0
            }
            return nil
        }
    }
    
    /**This method gets size of a string with a particular font.
     */
    func size(usingFont font: UIFont) -> CGSize {
      return size(withAttributes: [.font: font])
    }
    
    func toDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func toDouble() -> Double{
        return Double(self) ?? 0.0
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: self)
    }
    
    func isValidPhone() -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }
    
    
    func convertHtml() -> NSAttributedString{
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do{
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
        }catch{
            return NSAttributedString()
        }
    }
    
    func getDataFromUserDefault() -> AnyObject?{
        var returnData:AnyObject?
        if let data = userDefault.object(forKey: self) as? Data{
            returnData =  (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as AnyObject
        }
        return returnData
    }
    
    func convertLbToKg() -> String{
        return (self.toDouble()*0.453592).toString(decimalPlaces: 2)
    }
    
    func convertFtToCm() -> String{
        return (self.toDouble()*30.48).toString(decimalPlaces: 2)
    }
    
    func toInt() -> Int{
        return Int(self) ?? 0
    }
    
    //**** For Date Formate ****
    
    
    func toString() -> String {
        return String(self)
    }
    
    func toFloat() -> Float {
        return Float(self) ?? 0.0
    }
    
    func dateFromString() -> Date{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateFormatter.timeZone = .current
        if let date = dateFormatter.date(from: self){
            return date
        }
        else{
            return Date()
        }
    }
    
    func fullDateFromString() -> Date{
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = .none

        if let date = dateFormatter.date(from: self){
            return date
        }
        else{
            return Date()
        }
    }
    
    func dateFromStringWithoutTime() -> Date{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateFormatter.timeZone = .none
        if let date = dateFormatter.date(from: self){
            return date
        }
        else{
            return Date()
        }
    }
    
    func dateFromStringInSlashes() -> Date{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = .current
        if let date = dateFormatter.date(from: self){
            return date
        }
        else{
            return Date()
        }
    }
    
    func replaceString(fromString:String, toString:String) -> String {
        return self.replacingOccurrences(of: fromString, with: toString)
    }
    
    func displayCharacters(n: Int) -> String{
        var counter = n
        var originalStr = self
        var outputStr: String = ""
        
        if originalStr.count > n{
            
            while counter > 0{
                if originalStr.first!.isNumber{
                    counter -= 1
                    if let char = originalStr.first{
                        outputStr.append(char)
                    }
                    originalStr.removeFirst()
                }else{
                    if let char = originalStr.first{
                        outputStr.append(char)
                    }
                    originalStr.removeFirst()
                }
            }
            return outputStr
        } else {
            return originalStr
        }
        
    }
    
    func stringToDateWithTime() -> Date{
        let formate = ISO8601DateFormatter()
        formate.timeZone = TimeZone.autoupdatingCurrent
        formate.formatOptions = [.withFullDate,.withFullTime,.withColonSeparatorInTime,.withTimeZone,.withColonSeparatorInTimeZone]
        
        
        return formate.date(from:self) ?? Date()
    }
    
    func showFlag() -> String{
        
        return String(String.UnicodeScalarView(
            self.unicodeScalars.compactMap(
                { UnicodeScalar(127397 + $0.value) })))
    }
    
    
    func dateFromISOString() -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate,
                                   .withTime,
                                   .withDashSeparatorInDate,
                                   .withColonSeparatorInTime]
        let formatterDate = formatter.date(from: self)
        
        return formatterDate
    }
    
    
    // MARK: Reg Expressions
    enum ValidityType {
        case email
        case name
        case numbers
        case containsSpecialChar
        case containsOneNumber
        case containsOneUpperCase
        case containsOnelowerCase
    }
    
    
    func isValid(_ validityType : ValidityType) -> Bool
    {
        let format = "SELF MATCHES %@"
        var regex = ""
        
        switch validityType
        {
        case .email:
            regex = "^[A-Za-z\\d]+([-_.][A-Za-z\\d]+)*@([A-Za-z\\d]+[-.])+[A-Za-z\\d]{2,4}$"
            
        case .name:
            regex = "^[a-zA-Z0-9 ]*$"
            
        case .numbers:
            regex = "^[1-9][0-9]*$"
            
        case .containsSpecialChar:
            regex = "[!@#$%&*()_+=|<>?{}\\[\\]~-]"
            
        case .containsOnelowerCase:
            regex = ".*[a-z]+.*"
            
        case .containsOneUpperCase:
            regex = ".*[A-Z]+.*"
            
        case .containsOneNumber:
            regex = ".*[0-9]+.*"
            
        }
        
        return NSPredicate(format: format, regex).evaluate(with: self)
    }
    
    
    //set lable height with respect to text
    func sizeWithConstrainedHeight(height: CGFloat, font: UIFont) -> CGSize {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return CGSize(width: boundingBox.width, height: boundingBox.height)
    }
    
    //set lable Weight with respect to text
    func sizeWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGSize {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return CGSize(width: boundingBox.width, height: boundingBox.height)
    }
    
    func dateTimeChangeFormat (inDateFormat: String, outDateFormat: String) -> String {
        let inFormatter = DateFormatter()
        inFormatter.locale = Locale(identifier: "en_US_POSIX")
        inFormatter.dateFormat = inDateFormat
        
        let outFormatter = DateFormatter()
        outFormatter.locale = Locale(identifier: "en_US_POSIX")
        outFormatter.dateFormat = outDateFormat
        
        let inStr = self
        let date = inFormatter.date(from: inStr)!
        return outFormatter.string(from: date)
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}

extension NSMutableAttributedString{
    
    // If no text is send, then the style will be applied to full text
    func setColorForText(_ textToFind: String?, with color: UIColor) {
        
        let range:NSRange?
        if let text = textToFind{
            range = self.mutableString.range(of: text, options: .caseInsensitive)
        }else{
            range = NSMakeRange(0, self.length)
        }
        if range!.location != NSNotFound {
            addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range!)
        }
    }
    
    var fontSize:CGFloat { return 14 }
    var boldFont:UIFont { return UIFont(name: "OpenSans-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont:UIFont { return UIFont(name: "OpenSans-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}
    
    func bold(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normal(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    /* Other styling methods */
    func blueForeground(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  boldFont,
            .backgroundColor : UIColor(hexString: "#E5E5E5"),
            .foregroundColor : UIColor(hexString: "#0069B4")
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    /* Other styling methods */
    func blueBoldForeground(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  boldFont,
            .foregroundColor : UIColor(hexString: "#0069B4")
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    /* Other styling methods */
    func blackForeground(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor(hexString: "#000000")
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func blackHighlight(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black
            
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func underlined(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue
            
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
