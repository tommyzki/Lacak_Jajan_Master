//
//  Application.swift
//  Lacak Jajan
//
//  Created by Tommy Miyazaki on 7/11/17.
//  Copyright © 2017 Tommyzki. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON
import Unbox

var URLService: String {
    get {
        return Application.value(forKey: "url_service") ?? Application.Url.Service.local
    }
    set {
        Application.setValue(newValue, forKey: "url_service")
    }
}

let taskDefault   = "task"
let fetchUserDataDefault = "fetchUserData"

struct Application {
    struct Url {
        struct Service {
            static let local   = "http://localhost/mobile/lacak_jajan/userObject.php"
            static let hosting = "http://ayononton.esy.es/lacak_jajan/"
        }
    }
    
    @discardableResult
    static func setValue(_ value: Any, forKey key: String) -> Bool {
        UserDefaults.standard.setValue(value, forKey: key)
        return UserDefaults.standard.synchronize()
    }
    static func value<T>(forKey key: String) -> T? {
        return UserDefaults.standard.value(forKey: key) as? T
    }
}

extension Data {
    var stringValue: String {
        let string = String(data: self, encoding: .utf8)
        return string ?? String(describing: self)
    }
}

//Validate
extension Application {
    struct ResponseStatus {
        static let success = "success"
        static let failure = "failed"
        static let empty   = "empty"
    }
    
    enum ResponseError: LocalizedError {
        case objectCastFailure(error: Error)
        case jsonSerializationFailure(responseString: String, error: Error)
        case other(String)
    }
    
    static func validateResponse(_ response: DataResponse<Any>) -> ([String: Any]?, ResponseError?) {
        switch response.result {
        case .success(let value):
            let parsedJson = JSON(value)
            let root = parsedJson["root"]
            let data = root.dictionaryObject
            
            let status = root["status"].stringValue
            let message = root["message"].stringValue
            
            switch status {
            case ResponseStatus.success:
                return (data, nil)
            case ResponseStatus.failure:
                return (nil, constructFailureResponse(message: message))
            default:
                return (nil, constructFailureResponse(message: "Failed to parse response parameters. Unknown response was given."))
            }
        case .failure(let error):
            return (nil, constructJsonFailureResponse(data: response.data ?? Data(), error: error))
        }
    }
    static func validateObjectResponse<T: Unboxable>(_ response: DataResponse<Any>) -> (T?, Error?) {
        switch response.result {
        case .success(let value):
            let parsedJson = JSON(value)
            let root = parsedJson["root"]
            let data = root["data"]
            
            let status = root["status"].stringValue
            let message = root["message"].stringValue
            
            switch status {
            case ResponseStatus.success:
                if let dictionary = data.object as? UnboxableDictionary {
                    do {
                        return try (constructSuccessResponse(dictionary), nil)
                    } catch {
                        return (nil, constructCastFailureResponse(error: error))
                    }
                }
                return (nil, constructFailureResponse(message: "Failed to parse response parameters. Unknown response was given."))
            case ResponseStatus.failure:
                return (nil, constructFailureResponse(message: message))
            default:
                return (nil, constructFailureResponse(message: "Failed to parse response parameters. Unknown response was given."))
            }
        case .failure(let error):
            return (nil, constructJsonFailureResponse(data: response.data ?? Data(), error: error))
        }
    }
    static func validateObjectsResponse<T: Unboxable>(_ response: DataResponse<Any>) -> ([T]?, Error?) {
        switch response.result {
        case .success(let value):
            let parsedJson = JSON(value)
            let root = parsedJson["root"]
            let data = root["data"]
            let list = data["list"]
            
            let status = root["status"].stringValue
            let message = root["message"].stringValue
            
            switch status {
            case ResponseStatus.success:
                if let dictionaries = list.arrayObject as? [UnboxableDictionary] {
                    do {
                        return try (constructSuccessResponse(dictionaries), nil)
                    } catch {
                        return (nil, constructCastFailureResponse(error: error))
                    }
                }
                return (nil, constructFailureResponse(message: "Failed to parse response parameters. Unknown response was given1."))
            case ResponseStatus.failure:
                return (nil, constructFailureResponse(message: message))
            case ResponseStatus.empty:
                return ([], nil)
            default:
                return (nil, constructFailureResponse(message: "Failed to parse response parameters. Unknown response was given.2"))
            }
        case .failure(let error):
            return (nil, constructJsonFailureResponse(data: response.data ?? Data(), error: error))
        }
    }
    
    private static func constructSuccessResponse<T: Unboxable>(_ dictionary: UnboxableDictionary) throws -> T {
        let object: T = try unbox(dictionary: dictionary)
        return object
    }
    private static func constructSuccessResponse<T: Unboxable>(_ dictionaries: [UnboxableDictionary]) throws -> [T] {
        let objects: [T] = try unbox(dictionaries: dictionaries)
        return objects
    }
    
    private static func constructCastFailureResponse(error: Error) -> ResponseError {
        let error = ResponseError.objectCastFailure(error: error)
        return error
    }
    private static func constructJsonFailureResponse(data: Data, error: Error) -> ResponseError {
        let string = data.stringValue
        let error = ResponseError.jsonSerializationFailure(responseString: string, error: error)
        return error
    }
    private static func constructFailureResponse(message: String) -> ResponseError {
        let error = ResponseError.other(message)
        return error
    }
}
