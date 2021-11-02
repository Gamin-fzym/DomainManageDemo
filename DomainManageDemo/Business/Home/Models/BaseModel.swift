//
//  BaseModel.swift
//  DomainManageDemo
//
//  Created by MaciOS on 2021/11/1.
//

import Foundation
import SwiftyJSON

protocol BaseModel {
    
    associatedtype Element
    static func parseObject( json: JSON) -> Element
    
}

extension BaseModel {
    
    static func parseList(jsonList: JSON) -> [Element] {
        var voList = [Element]()
        if let jsonList = jsonList.array {
            for json in jsonList {
                voList.append(parseObject(json: json))
            }
        }
        return voList
    }
    
    static func parseList(jsonList: [JSON]) -> [Element] {
        var voList = [Element]()
        for json in jsonList {
            voList.append(parseObject(json: json))
        }
        return voList
    }
    
}
