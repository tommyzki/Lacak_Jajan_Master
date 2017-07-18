//
//  UserObject.swift
//  Lacak Jajan
//
//  Created by Tommy Miyazaki on 7/11/17.
//  Copyright © 2017 Tommyzki. All rights reserved.
//

import Foundation
import Alamofire
import Unbox
import SVProgressHUD

class UserObject: Unboxable {
    
    struct SerializationKeys {
        static let username = "username"
        static let password = "password"
        static let email    = "email"
        static let fullname = "fullname"
        static let kas      = "kas"
        static let tabungan = "tabungan"
        
    }
    
    typealias UserObjectResultHandler = (Bool, Error?) -> Void
    typealias UserObjectFetchResultHandler = (UserObject?, Error?) -> Void
    typealias UserObjectArrayFetchResultHandler = ([UserObject]?, Error) -> Void
    
    var username = ""
    var password = ""
    var email    = ""
    var fullname = ""
    var kas      = 0
    var tabungan = 0
    
    init() {
        
    }
    
    required init(unboxer: Unboxer) throws {
    
        username = (try? unboxer.unbox(key: SerializationKeys.username)) ?? ""
        password = (try? unboxer.unbox(key: SerializationKeys.password)) ?? ""
        email    = (try? unboxer.unbox(key: SerializationKeys.email)) ?? ""
        fullname = (try? unboxer.unbox(key: SerializationKeys.fullname)) ?? ""
        kas      = (try? unboxer.unbox(key: SerializationKeys.kas)) ?? 0
        tabungan = (try? unboxer.unbox(key: SerializationKeys.tabungan)) ?? 0
    }
    
    static func fetchUserData(username: String, result: UserObjectFetchResultHandler?) {
        SVProgressHUD.show()
        let params: Parameters = [taskDefault: fetchUserDataDefault, SerializationKeys.username: username]
        
        Alamofire.request(URLService, method: .post, parameters: params).responseJSON { response in
            let response: (user: UserObject?, error: Error?) = Application.validateObjectResponse(response)
            if let user = response.user {
                result?(user, nil)
            } else {
                result?(nil, response.error)
            }
        }
    }
    
    static func createNewUser(username: String, password: String, email: String, fullname: String, result: UserObjectResultHandler?){
        SVProgressHUD.show()
        let params: Parameters = [taskDefault: createUserDefault, SerializationKeys.username: username, SerializationKeys.password: password, SerializationKeys.email: email, SerializationKeys.fullname: fullname]
        
        Alamofire.request(URLService, method: .post, parameters: params).responseJSON { response in
            let (dictionary, error) = Application.validateResponse(response)
            if let _ = dictionary {
                result?(true, nil)
            } else {
                result?(false, error)
            }
        }
    }
    
}

