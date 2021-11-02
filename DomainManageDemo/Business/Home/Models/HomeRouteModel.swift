//
//  HomeRouteModel.swift
//  DomainManageDemo
//
//  Created by MaciOS on 2021/11/1.
//

import Foundation
import SwiftyJSON

struct HomeRouteModel : BaseModel {
    typealias Element = HomeRouteModel
    var bannerList : [RouteModel] = []
    var menuList : [RouteModel] = []
    
    static func parseObject(json: JSON) -> HomeRouteModel {
        var model = HomeRouteModel()
        model.bannerList = RouteModel.parseList(jsonList: json["bannerList"])
        model.menuList = RouteModel.parseList(jsonList: json["menuList"])
        return model
    }
}

/// 路由Model
struct RouteModel: BaseModel, Equatable {
    typealias Element = RouteModel
    /// 跳转类型 0:不跳转，1:app内部跳转，2:H5 app端无导航, 3:h5 app端加导航
    var routeJumpType : String?
    /// 跳转地址
    var routeJumpPath : String?
    /// 路由名称
    var routeName : String?
    /// 路由icon
    var routeIcon : String?
    /// 数据json
    var routeData : String = ""
    /// 是否需要登录 0无 1需要登录
    var routeAuthType = ""
    
    static func parseObject(json: JSON) -> RouteModel{
        var vo = RouteModel()
        vo.routeJumpType = json["routeJumpType"].string
        vo.routeJumpPath = json["routeJumpPath"].string
        vo.routeName = json["routeName"].string
        vo.routeIcon = json["routeIcon"].string
        vo.routeData = json["routeData"].stringValue
        vo.routeAuthType = json["routeAuthType"].stringValue
        return vo
    }
}

