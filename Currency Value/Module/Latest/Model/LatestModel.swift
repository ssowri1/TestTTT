//
//  LatestModel.swift
//  Currency Value
//
//  Created by user on 24/04/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import ObjectMapper
class LatestModel: NSObject {
    // API for Notification model
    //
    // - Parameters:
    //   - parentView: Any object
    //   - parameters
    class func fetchLatestCurrencies(completionHandler: @escaping (_ response: LatestApiModel) -> Void) {
        let path = "\(BASEURL)latest"
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(httpMethod: .get, path: path, parameters: nil, completionHandler: { (response) in
            // convert my data response to string
            let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
            // call the object mapper
            let responseData = Mapper<LatestApiModel>().map(JSONString: content!)
            if responseData?.base?.count != 0 {
                completionHandler(responseData!)
            }
        }, errorOccured: { errorOccured in
            // Faliure message
            debugPrint("Error ", errorOccured?.localizedDescription ?? "Something went wrong")
        })
    }
}
