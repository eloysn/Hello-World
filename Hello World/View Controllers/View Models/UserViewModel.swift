//
//  UserViewModel.swift
//  Hello World
//
//  Created by eloysn on 23/9/17.
//  Copyright © 2017 eloysn. All rights reserved.
//

import Foundation

struct UserViewModel {
    
    let user: User
    
    var id: Int {
        return user.id
    }
    var name: String {
        return user.name
    }
    var birthDate: String? {
      return date?.stringFromDate()
    }
    
    var date: Date? {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
            return  dateFormatter.date(from: user.birthdate)
           
        }
        set {
            date = newValue
        }
    }
}
