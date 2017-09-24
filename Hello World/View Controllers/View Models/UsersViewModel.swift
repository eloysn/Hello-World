//
//  UsersViewModel.swift
//  Hello World
//
//  Created by eloysn on 23/9/17.
//  Copyright © 2017 eloysn. All rights reserved.
//

import Foundation

struct UsersViewmodel {
    
    var users: [UserViewModel]
    
    
    var numberOfSections: Int {
        return 1
    }
    var numberOfUsers: Int? {
        
        return users.count
        
      
    }
    subscript( _ index: Int) -> UserViewModel {
    
        return users[index]
    }
    
    
    
}
