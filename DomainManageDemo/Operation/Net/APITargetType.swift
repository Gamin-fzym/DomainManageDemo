//
//  HomeVC.swift
//  DomainManageDemo
//
//  Created by MaciOS on 2021/11/1.
//

import Foundation

/// 服务器地址
var ROOT_URL: String {
    get {
        return AppUserDefaults.shared.useDomain ?? ""
    }
}
var BASE_URL: String {
    get {
        return ROOT_URL + "api/"
    }
}

/// 参数 [String: Any]
typealias Params = [String: Any]

/// 请求方式
enum RequetMethod : Int {
    case get = 0
    case post = 1
    case bodyPost = 2
    case uploadImage = 3
    case uploadMp4 = 4
}

/// 网络请求抽象层
protocol APITargetType {
    /// 请求方式
    var method : RequetMethod { get }
    /// 服务器地址
    var baseURL : String { get }
    /// 路由
    var path: String { get }
    /// 参数
    var params: [String : Any] { get }
}


/// demo
enum ExampleAPI {
    typealias Params = [String: Any]
    
    case test(Params = [:])
}

extension ExampleAPI : APITargetType {
    
    var method: RequetMethod {
        return .post
    }
    
    var baseURL: String {
        return BASE_URL
    }
    
    var path: String {
        switch self {
        case .test:
            return "test"
        }
    }
    
    var params: [String : Any] {
        switch self {
        case .test(let params):
            var param = params
            param["token"] = AppUserDefaults.shared.token ?? ""
            return param
        }
    }
    
}

