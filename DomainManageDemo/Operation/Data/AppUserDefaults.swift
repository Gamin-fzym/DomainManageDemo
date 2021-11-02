//
//  HomeVC.swift
//  DomainManageDemo
//
//  Created by MaciOS on 2021/11/1.
//  缓存信息 可视化

import Foundation
import SwiftyUserDefaults

// MARK: 定义Key
extension DefaultsKeys {
    // token
    var token: DefaultsKey<String?>{.init("token", defaultValue: "")}
    // 域名列表
    var domainList: DefaultsKey<[String]?>{.init("domainList", defaultValue: [])}
    // 使用的域名 todo_zdm
    var useDomain: DefaultsKey<String?>{.init("useDomain", defaultValue: "http://test.api.com/")}
}

// MARK: 使用定义的key
class AppUserDefaults {
    //private init() { }
    static let shared: AppUserDefaults = AppUserDefaults()
    var token: String? {
        didSet { Defaults.token = token }
    }
    var domainList: [String]? {
        didSet {Defaults.domainList = domainList}
    }
    var useDomain: String? {
        didSet { Defaults.useDomain = useDomain}
    }
}

// MARK: 方法
extension AppUserDefaults {
    
    /// 从UserDefaults中加载缓存
    func loadFromUserDefaults() {
        self.token = Defaults.token
        self.domainList = Defaults.domainList
        self.useDomain = Defaults.useDomain
    }
    
    /// 清除UserDefaults中全部缓存数据
    func removeAll() {
        let userDefaults = UserDefaults()
        let dics = userDefaults.dictionaryRepresentation()
        for key in dics.keys {
            userDefaults.removeObject(forKey: key)
            userDefaults.synchronize()
        }
        userDefaults.synchronize()
    }
    
    /// 退出登录 清除用户数据
    func exitLoginAction(canToHome:Bool) {
        AppUserDefaults.shared.token = ""
        if (canToHome) {
            
        }
    }
    
}


