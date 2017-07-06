//
//  Historys.swift
//  Lacak Jajan
//
//  Created by Tommy Miyazaki on 6/9/17.
//  Copyright © 2017 Tommyzki. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD

class Historys{
    
    typealias JSONStandart = Dictionary<String, AnyObject>
    private var _dictData: [Dictionary<String, AnyObject>]?
    

    var dictData: [Dictionary<String, AnyObject>]{
        return _dictData ?? [["unknown":"unknown" as AnyObject]]
    }
    
    func loadHistory(loginusername: String, completed: @escaping (Bool)->()) {
        let todoEndpoint: String = "http://ayononton.esy.es/lacak_jajan/history.php?username=\(loginusername)"
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
            
            if let arrayDict = json.value as? [JSONStandart] {
                
                if (arrayDict.count > 0){
                    self._dictData = arrayDict
                } else {
                    self._dictData = [["unknown":"unknown" as AnyObject]]
                }
                kembalian = true
            }
            completed(kembalian)
        })
    }
    
    func addHistory(addusername: String, addtype: String, adddesc: String, addnominal: String, completed: @escaping (Bool)->()) {
        
        let todoEndpoint: String = "http://ayononton.esy.es/lacak_jajan/history.php"
        var kembalian = false
        SVProgressHUD.show()
        
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let adddate = "\(dateFormatter.string(from: date))"
        
        dateFormatter.dateFormat = "HH:mm"
        let addtime = "\(dateFormatter.string(from: date))"
        
        dateFormatter.dateFormat = "ddMMyyHHmmss"
        let addid = "\(dateFormatter.string(from: date))\(randomString(length: 3))"
        
        let parameters: Parameters = ["id": addid ,"username": addusername , "date":adddate, "time":addtime, "type":addtype, "desc":adddesc, "nominal":addnominal]
        
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
    
    func clearHistory(completed: @escaping (Bool)->()) {
        
        let todoEndpoint: String = "http://ayononton.esy.es/lacak_jajan/deleteHistory.php"
        var kembalian = false
        SVProgressHUD.show()
        
        let parameters: Parameters = [:]
        
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
    
    // MARK: - Generate Random Number
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

