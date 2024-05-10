//
//  UserDefaults.swift
//  M2C
//
//  Created by Abdul Samad Butt on 22/07/2022.
//

import Foundation

extension UserDefaults{
    
    func set<T: Encodable>(encodable: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            set(data, forKey: key)
        }
    }
    
    func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = object(forKey: key) as? Data,
           let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        return nil
    }
    
    func saveValue(value: Any, key: String){
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func getValue(key: String) -> Any{
//        return UserDefaults.standard.string(forKey: key) ?? ""
        return UserDefaults.standard.object(forKey: key) as Any
    }
    
    func deleteValue(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    func saveObject(value: Any, key: String){
        
    }
    
    func save<T:Encodable>(customObject object: T, inKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            self.set(encoded, forKey: key)
        }
    }
    
    func retrieve<T:Decodable>(object type:T.Type, fromKey key: String) -> T? {
        if let data = self.data(forKey: key) {
            let decoder = JSONDecoder()
            if let object = try? decoder.decode(type, from: data) {
                return object
            }else {
                print("Couldnt decode object")
                return nil
            }
        } else {
            print("Couldnt find key")
            return nil
        }
    }
    
    func getSavedVideoSettings(key: String) -> VideoRecordingSettings {
        var videoSettings = VideoRecordingSettings()
        if let data = userDefault.object(forKey: UDKey.videoSettings) as? Data {
            videoSettings = try! NSKeyedUnarchiver.unarchivedObject(ofClass: VideoRecordingSettings.self, from: data)!
            return videoSettings
        }

        return videoSettings
    }
    
    func saveUser(user: LoginUser){
        //To save the object
        do {
            let encodedUser = try NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: true)
            userDefault.set(encodedUser, forKey: UDKey.savedUser)
            userDefault.synchronize()
        } catch {
            print("Unable to save user")
        }
    }
}
