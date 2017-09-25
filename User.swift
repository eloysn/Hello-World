//
//  User.swift
//  Hello World
//
//  Created by eloysn on 20/9/17.
//  Copyright © 2017 eloysn. All rights reserved.
//

import Foundation

struct User: JSONDecodable {
    
    //MARK: - Init
    init?(dictionary: JSONDictionary) {
        
        guard let id = dictionary["id"] as? Int,
            let name = dictionary["name"] as? String,
            let birthdate = dictionary["birthdate"] as? String else {
             return nil
        }
        self.id = id
        self.name = name
        self.birthdate = birthdate
        
    }
    init(id: Int = 0, name: String, birthDate: String) {
        self.id = id
        self.name = name
        self.birthdate = birthDate
    }
    
    //MARK: - Properties
    let id: Int 
    let name: String
    let birthdate: String
    
    
    
    
    
}
