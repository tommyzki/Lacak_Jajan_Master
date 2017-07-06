//
//  User.swift
//  Lacak Jajan
//
//  Created by Tommy Miyazaki on 5/13/17.
//  Copyright © 2017 Tommyzki. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD

class Users{
    
    private var _username: String?
    private var _password: String?
    private var _email: String?
    private var _fullname: String?
    private var _kas: Int?
    private var _tabungan: Int?
    typealias JSONStandart = Dictionary<String, AnyObject>
    
    var username: String {
        return _username ?? "unknown"
    }
    var email: String {
        return _email ?? "unknown"
    }
    var fullname: String {
        return _fullname ?? "unknown"
    }
    var kas: Int {
        return _kas ?? 0
    }
    var tabungan: Int {
        return _tabungan ?? 0
    }
    
    // Mark: - Load User Data
    func loadUser(loginusername: String, completed: @escaping (Bool)->()) {
        let todoEndpoint: String = "http://ayononton.esy.es/lacak_jajan/user.php?username=\(loginusername)"
        var kembalian = false
        SVProgressHUD.show()
        Alamofire.request(todoEndpoint, method: .get).responseJSON(completionHandler: { response in
            
            // check for errors
            guard response.result.error == nil else {
                SVProgressHUD.dismiss()
                // got an error in getting the data, need to handle it
                print("error calling GET")
                print(response.result.error!)
                return
            }
            // Set Users
            let json = response.result
            
            if let arrayDict = json.value as? [JSONStandart],
                let username = arrayDict[0]["username"] as? String,
                let password = arrayDict[0]["password"] as? String,
                let email = arrayDict[0]["email"] as? String,
                let fullname = arrayDict[0]["fullname"] as? String,
                let kas = arrayDict[0]["kas"] as? Int,
                let tabungan = arrayDict[0]["tabungan"] as? Int {
                
                    self._username = username
                    self._password = password
                    self._email = email
                    self._fullname = fullname
                    self._kas = kas
                    self._tabungan = tabungan
                    kembalian = true
                
            }
            completed(kembalian)
        })
    }
    
    // Mark: - Login Authenticate User Data
    func loginUser(loginusername: String, loginpassword: String, completed: @escaping (Bool)->()) {
        
        let todoEndpoint: String = "http://ayononton.esy.es/lacak_jajan/user.php?username=\(loginusername)"
        var kembalian = false
        SVProgressHUD.show()
        Alamofire.request(todoEndpoint, method: .get).responseJSON(completionHandler: { response in
                
            // check for errors
            guard response.result.error == nil else {
                SVProgressHUD.dismiss()
                // got an error in getting the data, need to handle it
                print("error calling GET")
                print(response.result.error!)
                return
            }
            // Set Users
            let json = response.result
            let arrayDicts = json.value as? [JSONStandart]
            if arrayDicts?.count != 0 {
                
                if let arrayDict = json.value as? [JSONStandart],
                    let username = arrayDict[0]["username"] as? String,
                    let password = arrayDict[0]["password"] as? String,
                    let email = arrayDict[0]["email"] as? String,
                    let fullname = arrayDict[0]["fullname"] as? String,
                    let kas = arrayDict[0]["kas"] as? Int,
                    let tabungan = arrayDict[0]["tabungan"] as? Int  {
                    
                    
                    if (username == loginusername && password == loginpassword){
                        self._username = username
                        self._password = password
                        self._email = email
                        self._fullname = fullname
                        self._kas = kas
                        self._tabungan = tabungan
                        kembalian = true
                    }
                }
            }
            completed(kembalian)
        })
    }
    
    // Mark: - Register User Data and Post to Host
    func registerUser(regusername: String, regpassword: String, regemail: String, regfullname: String, completed: @escaping (Bool)->()) {
        
        let todoEndpoint: String = "http://ayononton.esy.es/lacak_jajan/user.php"
        var kembalian = false
        SVProgressHUD.show()
        
        let parameters: Parameters = ["username": regusername , "password":regpassword, "email":regemail, "fullname":regfullname]
        Alamofire.request(todoEndpoint, method: .post, parameters: parameters).responseJSON(completionHandler: { response in
            // check for errors
            guard response.result.error == nil else {
                SVProgressHUD.dismiss()
                // got an error in getting the data, need to handle it
                print("error calling POST")
                print(response.result.error!)
                return
            }
            
            // Set Users
            kembalian = true
            completed(kembalian)
        })
        
    }
    
    // Mark : - Update User Data
    func updateUser(username: String, params: String, value: String, completed: @escaping (Bool)->()) {
        
        let todoEndpoint: String = "http://ayononton.esy.es/lacak_jajan/updateUser.php"
        var kembalian = false
        SVProgressHUD.show()
        
        let parameters: Parameters = ["username": username , "params":params, "value":value]
        
        Alamofire.request(todoEndpoint, method: .post, parameters: parameters).responseJSON(completionHandler: { response in
            
            // check for errors
            guard response.result.error == nil else {
                SVProgressHUD.dismiss()
                // got an error in getting the data, need to handle it
                print("error calling POST")
                print(response.result.error!)
                return
            }
            
            // Set Users
            kembalian = true
            completed(kembalian)
        })
        
    }
    
}
