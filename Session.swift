//
//  Session.swift
//  Hello World
//
//  Created by eloysn on 20/9/17.
//  Copyright © 2017 eloysn. All rights reserved.
//

import Foundation

enum Session {
    case getAllUser
    case getUserId(id: Int)
    case create(user: User)
    case update(user: User)
    case remove(id: Int)
    
}

extension Session: Resource {
    
    
    var method: Method {
        switch self {
        case .getAllUser, .getUserId, .remove:
            return .GET
        case .create, .update:
            return .POST
     
        }
    }
    
    var path: String {
        switch self {
        case .getUserId:
            return "get/"
        case .getAllUser:
            return "getall/"
        case .create:
            return "create/"
        case .update:
            return "update/"
        case .remove:
            return "remove/"
        }
    }
    
    
    var parameters: [String: String] {
        switch self {
        case let .getUserId(id), let .remove(id):
            return ["id":"\(id)"]
        case .getAllUser, .create, .update:
            return [:]
        
        }
    }
    
    var bodyObjects: [String : Any] {
        switch self {
        case .getUserId, .remove, .getAllUser:
            return [:]
        case let  .create(user), let .update(user):
            return ["id": user.id, "name": user.name, "birthdate": user.birthdate.description ]
        }
    }
    
    
    
    
    
    
    
}
