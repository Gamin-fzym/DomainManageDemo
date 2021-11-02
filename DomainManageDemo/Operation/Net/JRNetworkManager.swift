//
//  JRNetworkManager.swift
//  DomainManageDemo
//
//  Created by MaciOS on 2021/11/1.
//

import Foundation
import Alamofire
import SwiftyJSON
import EZSwiftExtensions

enum NetworkStatus : String {
    case success = "00000"
    case networkError = "A0001"
    case otherError = "-1"
    case tokenError = "-2"
}

class JRNetworkManager: NSObject {
    
    private var sessionManager: Session?
    static let shared = JRNetworkManager()
    
    typealias CompletedBlock = ((JSON) -> Void)
    typealias FailedBlock = ((NetworkStatus, String) -> Void)
    
    private override init() {
        super.init()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        self.sessionManager = Session(configuration: configuration, delegate: SessionDelegate())
    }
    
    /// 判断是否联网
    static func isNetworkConnect() -> Bool {
        let networkStatue = NetworkReachabilityManager()
        return networkStatue?.isReachable ?? true
    }
    
    /// 取消
    func cancalAllRequest() {
        if let session = sessionManager {
            session.cancelAllRequests()
        }
    }
    
    /**
     Header
     属性名      数据类型    是否必须    说明
     token      String    否         登录成功后的token,用户身份的唯一标识
     appVersion String    是         APP版本号
     osType     String    是         操作系统类型1:iOS,2:Android,3:小程序,4:HarmonyOS,5:电脑端
     osVersion  String    否         操作系统版本
     device     String    否         设备型号,如:iphoneXS
     lng        String    否         经度
     lat        String    否         纬度
     timestamp  Long      否         请求时间戳(毫秒)
     */
    func requestHeader() -> HTTPHeaders {
        let token = AppUserDefaults.shared.token ?? ""
        let infoDictionary = Bundle.main.infoDictionary!
        let appVersion = infoDictionary["CFBundleShortVersionString"] as! String
        let osVersion = UIDevice.current.systemVersion
        let model = UIDevice.deviceModelReadable()
        let timeInterval: TimeInterval = NSDate().timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        let time = String(millisecond)
        let sign = ("JJJ20210901" + time + token).md5()

        let headers: HTTPHeaders = [
            "Content-Type" : "application/x-www-form-urlencoded; charset=utf-8",
            "token" : token,
            "appVersion" : appVersion,
            "osType" : "1",
            "osVersion" : osVersion,
            "device" : model,
            "timestamp" : time,
            "sign" : sign,
        ]
        return headers
    }
    
    /// 网络请求
    /// - Parameters:
    ///   - target: 路由 遵守APITargetType枚举类型
    ///   - completed: 请求成功返回数据
    ///   - failed: 请求失败返回数据
    func request(_ target: APITargetType, completed: @escaping CompletedBlock, failed: @escaping FailedBlock) {
        let url = target.baseURL + target.path
        AlertHUD.showText(url)
        switch target.method {
        case .post:
            if enterEncodablePOST(url: url) {
                EncodablePOST(url: url, params: target.params, headers: requestHeader(), completed: completed, failed: failed)
            } else {
                POST(url: url, params: target.params, headers: requestHeader(), completed: completed, failed: failed)
            }
        default:
            break
        }
    }
    
    /// Post请求
    /// - Parameters:
    ///   - url: 请求链接
    ///   - params: 参数
    ///   - headers: header信息
    ///   - completed: 请求成功返回数据
    ///   - failed: 请求失败返回数据
    fileprivate func POST(url: String,
                          params: [String : Any]?,
                          headers: HTTPHeaders,
                          completed: @escaping CompletedBlock,
                          failed: @escaping FailedBlock) {
        if !NetstatManager.shared.isNetworkConnect() {
            debugPrint(GlobalConfig.noNetAlert)
            DispatchQueue.main.async {
                failed(.networkError, GlobalConfig.noNetAlert)
            }
            AlertHUD.dismiss()
            //NetstatManager.shared.alert_noNetwrok()
            return
        }
        
        sessionManager?.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).validate().responseJSON { [weak self] (response) in
            guard let data = response.data else {
                DispatchQueue.main.async {
                    failed(.otherError, "服务器出错: \(response.error?.localizedDescription ?? "")")
                }
                return
            }
            guard let jsonData = try? JSON(data: data) else {
                debugPrint("数据出错：\(url)", String(data: data, encoding: .utf8) ?? "")
                DispatchQueue.main.async {
                    failed(.otherError, "数据出错")
                }
                return
            }
            let status = NetworkStatus(rawValue: jsonData["code"].stringValue)
            switch status {
                case .success:
                    completed(jsonData["data"])
                case .tokenError:
                    self?.cancalAllRequest()
                    AppUserDefaults.shared.exitLoginAction(canToHome: true)
                default:
                    DispatchQueue.main.async {
                        failed(.otherError, jsonData["msg"].stringValue)
                    }
            }
        }
    }
    
    /// 判断是否进入EncodablePOST请求
    fileprivate func enterEncodablePOST(url: String) -> Bool {
        if url.isBlank {
            return false
        }
        let keywords = ["test/test", "online_shop/setShoppingCart"]
        for value in keywords {
            if url.contains(value) {
                return true
            }
        }
        return false
    }
    
    /// Post请求  参数parameters必须符合Encodable协议
    /// - Parameters:
    ///   - url: 请求链接
    ///   - params: 参数
    ///   - headers: header信息
    ///   - completed: 请求成功返回数据
    ///   - failed: 请求失败返回数据
    fileprivate func EncodablePOST(url: String,
                          params: [String : Any]?,
                          headers: HTTPHeaders,
                          completed: @escaping CompletedBlock,
                          failed: @escaping FailedBlock) {
        if !NetstatManager.shared.isNetworkConnect() {
            debugPrint(GlobalConfig.noNetAlert)
            DispatchQueue.main.async {
                failed(.networkError, GlobalConfig.noNetAlert)
            }
        }
        
        if let guardParams = params, guardParams.keys.contains("list") {
            var parameters = PostEncodableParameters()
            if let tempParams = guardParams["list"] as? [[String : String]] {
                parameters.list = tempParams
            } else {
                DispatchQueue.main.async {
                    failed(.otherError, "数据出错")
                }
                return
            }
            
            AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers).response { [weak self] response in
                //debugPrint(response)
                guard let data = response.data else {
                    DispatchQueue.main.async {
                        failed(.otherError, "服务器出错: \(response.error?.localizedDescription ?? "")")
                    }
                    return
                }
                guard let jsonData = try? JSON(data: data) else {
                    debugPrint("数据出错：\(url)", String(data: data, encoding: .utf8) ?? "")
                    DispatchQueue.main.async {
                        failed(.otherError, "数据出错")
                    }
                    return
                }
                let status = NetworkStatus(rawValue: jsonData["code"].stringValue)
                switch status {
                    case .success:
                        completed(jsonData["data"])
                    case .tokenError:
                        self?.cancalAllRequest()
                        AppUserDefaults.shared.exitLoginAction(canToHome: true)
                    default:
                        DispatchQueue.main.async {
                            failed(.otherError, jsonData["msg"].stringValue)
                        }
                }
            }
        } else {
            DispatchQueue.main.async {
                failed(.otherError, "数据出错")
            }
            /*
            var ss = PostEncodableParameters()
            ss.page = params?["page"] as? String
            ss.pageSize = params?["pageSize"] as? String
            AF.request(url, method: .post, parameters: ss, encoder: JSONParameterEncoder.default, headers: headers).response { response in
                debugPrint(response)
            }
            */
        }
    }
    
}

extension JRNetworkManager {
    
    struct PostEncodableParameters: Encodable {
        var list: [[String : String]] = []
//        var page: String?
//        var pageSize: String?
    }
    
}
