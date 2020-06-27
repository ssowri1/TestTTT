//
//  ConverterModel.swift
//  Currency Value
//
//  Created by user on 26/04/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import ObjectMapper
class ConverterModel: NSObject {
    // API for Notification model
    //
    // - Parameters:
    //   - parentView: Any object
    //   - parameters
    class func fetchCurrencies(completionHandler: @escaping (_ response: ConverterApiModel) -> Void) {
        let path = "\(BASEURL)currencies"

        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(httpMethod: .get, path: path, parameters: nil, completionHandler: { (response) in
            // convert my data response to string
            let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
            // call the object mapper
            let responseData = Mapper<ConverterApiModel>().map(JSONString: content!)
            if responseData?.currencies.count != 0 {
                completionHandler(responseData!)
            }
        }, errorOccured: { errorOccured in
            // Faliure message
            debugPrint("Error ", errorOccured?.localizedDescription ?? "Something went wrong")
        })
    }
    // API for Notification model
    //
    // - Parameters:
    //   - parentView: Any object
    //   - parameters
    class func convertCurrencies(path: String, completionHandler: @escaping (_ response: ConverterResponse) -> Void) {
        print("path ", path)
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(httpMethod: .get, path: path, parameters: nil, completionHandler: { (response) in
            // convert my data response to string
            let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
            // call the object mapper
            let responseData = Mapper<ConverterResponse>().map(JSONString: content!)
            if responseData?.base?.isEmpty == false {
                completionHandler(responseData!)
            }
        }, errorOccured: { errorOccured in
            // Faliure message
            debugPrint("Error ", errorOccured?.localizedDescription ?? "Something went wrong")
        })
    }
}
