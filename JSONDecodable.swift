//
//  JSONDecodable.swift
//  Hello World
//
//  Created by eloysn on 23/9/17.
//  Copyright © 2017 eloysn. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: Any]

protocol JSONDecodable {
    init?(dictionary: JSONDictionary)
}
