/*
 CSApiHttpRequest.swift
 *  This extension class is used for CSApiHttpRequest Details
 * @category   Daimler
 * @package    com.contus.Daimler
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2018 Contus. All rights reserved.
 *
 */
import UIKit
import Alamofire
class CSApiHttpRequest: NSObject {
    // MARK: Shared Instance
    static let sharedInstance: CSApiHttpRequest = {
        let instance = CSApiHttpRequest()
        return instance
    }()
    /// Cache policy
    var urlCache: URLCache!
    /// Session Manager
    var manager: SessionManager!
    /// Cache is need or not as a bool variable
    var isCache: Bool!
    /// Time Out Request
    let requestTimeout: TimeInterval = 60
    /// Cache Control
    struct CacheControl {
        static let publicControl = "public"
        static let privateControl = "private"
        static let maxAgeNonExpired = "max-age=60"
        static let maxAgeExpired = "max-age=0"
        static let noCache = "no-cache"
        static let noStore = "no-store"
        static var allValues: [String] {
            return [
                CacheControl.publicControl,
                CacheControl.privateControl,
                CacheControl.maxAgeNonExpired,
                CacheControl.maxAgeExpired,
                CacheControl.noCache,
                CacheControl.noStore
            ]
        }
    }
    /// To check network connectivity
    struct Connectivity {
        static let sharedInstance = NetworkReachabilityManager()!
        static var isConnectedToInternet: Bool {
            return self.sharedInstance.isReachable
        }
    }
    /// initalize the cache and Session Manager
    override init() {
        super.init()
        self.setUpCache()
        self.configureSessionManager()
    }
    //PRAGMA : - Private Methods
    // Setting Up Cache Property
    fileprivate func setUpCache() {
        urlCache = {
            let capacity = 5 * 1024 * 1024 // MBs capacity To 5MBS
            let urlCache = URLCache(memoryCapacity: capacity, diskCapacity: capacity, diskPath: nil)
            return urlCache
        }()
    }
    // Setting up Session Manager
    fileprivate func configureSessionManager() {
        manager = {
            let configuration: URLSessionConfiguration = {
                let configuration = URLSessionConfiguration.default
                configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
                configuration.requestCachePolicy = .useProtocolCachePolicy
                configuration.urlCache = urlCache
                return configuration
            }()
            let manager = SessionManager(configuration: configuration)
            return manager
        }()
    }
    //This method is used to return the static http header
    fileprivate func httpHeader(path: String) -> [String: String] {
        //Custom headers
        var header: [String: String] = [
            "Login-Type": "Mobile",
            "content-type": "application/json"
        ]
        return header
    }
    //Request Generator
    fileprivate func urlRequest(httpMethod: HTTPMethod,
                                path: String,
                                parameterSet: [String: Any]!,
                                cache: Bool)
        -> URLRequest {
            var parameters = [String: Any]()
            if parameterSet != nil {
                parameters = parameterSet
            }
            let baseUrl = path
            let url = URL(string: baseUrl)!
            var urlRequest: URLRequest!
            if cache {
                urlRequest = URLRequest(url: url,
                                        cachePolicy: .returnCacheDataElseLoad,
                                        timeoutInterval: requestTimeout)
            } else {
                urlRequest = URLRequest(url: url,
                                        cachePolicy: .reloadIgnoringLocalCacheData,
                                        timeoutInterval: requestTimeout)
            }
            ///cache contol parameters
            //            parameters["Cache-Control"] = CacheControl.publicControl
            urlRequest.httpMethod = httpMethod.rawValue
            urlRequest.allHTTPHeaderFields = self.httpHeader(path: path)
            do {
                return try URLEncoding.default.encode(urlRequest, with: parameters)
            } catch {
                return urlRequest
            }
    }
    //This method is used to execute the request and getting the response in completion block and error in error block
    fileprivate func executeRequestWithMethod(_ httpMethod: HTTPMethod,
                                              path: String,
                                              parameters: [String: Any]!,
                                              completionHandler: @escaping (_ response: AnyObject) -> Void,
                                              errorOccured: @escaping (_ error: NSError?) -> Void) {
        if httpMethod == .get {
            let urlRequest  = self.javaUrlRequest(httpMethod: httpMethod,
                                                  path: path,
                                                  parameterSet: parameters,
                                                  cache: isCache)
            let request = manager.request(urlRequest)
            request.validate(statusCode: 200..<500)
            request.responseJSON { response in
                // Setting network activity Indicator to hide
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                switch response.result {
                case .success :
                    if response.result.value != nil {
                        // send to completion block
                        completionHandler(response.data as AnyObject? ?? NSData())
                    }
                case .failure(let error):
                    // sending to failure block
                    print("Error get")
                    errorOccured(error as NSError?)
                }
            }
        } else if httpMethod == .post {
            let urlRequest  = self.javaUrlRequestPost(httpMethod: httpMethod,
                                                      path: path,
                                                      parameterSet: parameters,
                                                      cache: isCache)
            let request = manager.request(urlRequest)
            request.validate(statusCode: 200..<500)
            request.responseJSON { response in
                // Setting network activity Indicator to hide
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                switch response.result {
                case .success :
                    if response.result.value != nil {
                        // send to completion block
                        completionHandler(response.data as AnyObject? ?? NSData())
                    }
                case .failure(let error):
                    // sending to failure block
                    print("Error get")
                    errorOccured(error as NSError?)
                }
            }
        }
    }
    //PRAGMA :- Public Methods
    // Execute request with Cache Method
    func executeRequestWithCache(httpMethod: HTTPMethod,
                                 path: String,
                                 parameters: [String: Any]!,
                                 completionHandler: @escaping (_ response: AnyObject) -> Void,
                                 errorOccured: @escaping (_ error: NSError?) -> Void) {
        isCache = false
        self.executeRequestWithMethod(httpMethod,
                                      path: path, parameters: parameters,
                                      completionHandler: completionHandler,
                                      errorOccured: errorOccured)
    }
    // Execute Request with no cache
    func executeRequestWithMethod(httpMethod: HTTPMethod,
                                  path: String,
                                  parameters: [String: Any]!,
                                  completionHandler: @escaping (_ response: AnyObject) -> Void,
                                  errorOccured: @escaping (_ error: NSError?) -> Void) {
        isCache = false
        self.executeRequestWithMethod(httpMethod,
                                      path: path,
                                      parameters: parameters,
                                      completionHandler: completionHandler,
                                      errorOccured: errorOccured)
    }
    //This method is used to execute the request and getting the response in completion block and error in error block
    //Request Generator
    fileprivate func javaUrlRequest(httpMethod: HTTPMethod,
                                    path: String,
                                    parameterSet: [String: Any]!,
                                    cache: Bool)
        -> URLRequest {
            debugPrint("API ==>> ", path)
            let url = URL(string: path)!
            var urlRequest: URLRequest!
            if cache {
                urlRequest = URLRequest(url: url,
                                        cachePolicy: .returnCacheDataElseLoad,
                                        timeoutInterval: requestTimeout)
            } else {
                urlRequest = URLRequest(url: url,
                                        cachePolicy: .reloadIgnoringLocalCacheData,
                                        timeoutInterval: requestTimeout)
            }
            let postData = Data()
            urlRequest.httpMethod = httpMethod.rawValue
            urlRequest.allHTTPHeaderFields = self.httpHeader(path: path)
            urlRequest.httpBody = postData as Data
            return urlRequest
    }
    //This method is used to execute the request and getting the response in completion block and error in error block
    //Request Generator
    fileprivate func javaUrlRequestPost(httpMethod: HTTPMethod, path: String, parameterSet: [String: Any]!, cache: Bool)
        -> URLRequest {
            var parameters = [String: Any]()
            if parameterSet != nil {
                parameters = parameterSet
            }
            debugPrint("API ==>> ", path)
            let url = URL(string: path)!
            var urlRequest: URLRequest!
            if cache {
                urlRequest = URLRequest(url: url,
                                        cachePolicy: .returnCacheDataElseLoad,
                                        timeoutInterval: requestTimeout)
            } else {
                urlRequest = URLRequest(url: url,
                                        cachePolicy: .reloadIgnoringLocalCacheData,
                                        timeoutInterval: requestTimeout)
            }
            ///cache contol parameters
            //            parameters["Cache-Control"] = CacheControl.publicControl
            var postData = Data()
            do {
                postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
            }
            print(postData)
            urlRequest.httpMethod = httpMethod.rawValue
            urlRequest.allHTTPHeaderFields = self.httpHeader(path: path)
            urlRequest.httpBody = postData as Data
            return urlRequest
    }
}
extension CSApiHttpRequest {
    /// Video Thumb Upload Image
    ///
    /// - Parameters:
    ///   - path: url path to which video need to be upload
    ///   - profileImage: send UIImage to be Upload
    ///   - parameter: dictinoary values that need to sent to url
    ///   - completion: responce result handler
    ///   - errorOccured: error responce handler
    func multiPartImageUpLoad(path: String,
                              profileImage: [String: UIImage]?,
                              parameter: [String: Any]!,
                              completion: @escaping (_ response: AnyObject) -> Void,
                              errorOccured: @escaping (_ error: NSError?) -> Void) {
        // setting network activity Indicator to visible
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        // call Api bu alamofire library Base URL is default Url and append Url is the method or action used in api call
        let alamofireSession = Alamofire.SessionManager.default
        let baseUrl = path
        alamofireSession.session.configuration.timeoutIntervalForRequest = requestTimeout
        alamofireSession.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameter {
                multipartFormData.append(((value) as? String)!.data(using: .utf8)!, withName: key)
            }
            for (key, value) in profileImage! {
                multipartFormData.append(value.jpegData(compressionQuality: 0.5)!,
                                         withName: key,
                                         fileName: "image.jpeg",
                                         mimeType: "image/jpeg")
            }
        }, to: baseUrl,
           method: .post,
           headers: self.httpHeader(path: path),
           encodingCompletion: { (result) in
            // setting network activity Indicator to hide
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                upload.responseJSON { response in
                    // send to completion block
                    completion(response.data as AnyObject? ?? NSData())
                }
            case .failure(let encodingError):
                // sending to failure block
                errorOccured(encodingError as NSError?)
            }
        })
    }
}
