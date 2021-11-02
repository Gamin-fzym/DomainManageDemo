//
//  HomeAPI.swift
//  DomainManageDemo
//
//  Created by MaciOS on 2021/11/2.
//

import Foundation

enum HomeAPI {
    /// 首页
    case getHomeRoute(Params = [:])
    /// 商户小店
    case getOfflineShopList(Params = [:])
}

extension HomeAPI : APITargetType {
    
    
    var method: RequetMethod {
        return .post
    }
    
    var baseURL: String {
        return BASE_URL + "home/"
    }
    
    var path: String {
        switch self {
        case .getHomeRoute:
            return "getHomeRoute"
        case .getOfflineShopList:
            return "getOfflineShopList"
        }
    }
    
    var params: [String : Any] {
        switch self {
        case .getHomeRoute(let params):
            fallthrough
        case .getOfflineShopList(let params):
            return params
        }
    }
    
}
