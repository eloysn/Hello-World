//
//  DataManager.swift
//  Hello World
//
//  Created by eloysn on 20/9/17.
//  Copyright © 2017 eloysn. All rights reserved.
//

import Foundation

final class ManagerSession {
    
    private let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
    
    private func data( resorce: Resource, completion: @escaping (Data?) -> Void)  {
        
        let task = session.dataTask(with: resorce.requestWithBaseURL()) { data, response, error in
            
            if let err = error  {
                print("error: \(err)")
                completion(nil)
                
            }else {
                if let response  = (response as? HTTPURLResponse)?.statusCode, 200...300 ~= response     {
                    
                    if let data = data {
                        completion(data)
                        
                    }
                    
                }else {
                    completion(nil)
                }
            }
            
        }
        
        task.resume()
    }
    private func decodeObject(resorce: Resource, completion: @escaping (JSONDictionary?) -> Void)  {
        
        data(resorce: resorce) { (data) in
            guard let data = data, let JSONObject =  try? JSONSerialization.jsonObject(with: data, options:[]), let dict = JSONObject as? JSONDictionary else {
                completion(nil)
                return
            }
            completion(dict)
        }
        
        
    }
    private func decodeObjects(resorce: Resource, completions: @escaping ([JSONDictionary]) -> Void)  {
        
        data(resorce: resorce) { (data) in
            guard let data = data, let JSONObject =  try? JSONSerialization.jsonObject(with: data, options:[]), let dict = JSONObject as? [JSONDictionary] else {
                completions([JSONDictionary]())
                return
            }
            completions(dict)
        }
        
        
    }
    
    func getUser(resorce: Resource, result: @escaping (User?) -> Void ) {
        
        decodeObject(resorce: resorce) { dict in
            guard let dict = dict else {
                result(nil)
                return
            }
            result(User(dictionary: dict))
        }
    }
    
    func getAllUsers(resource: Resource, result: @escaping ([User]) -> Void)  {
        var users = [User]()
        decodeObjects(resorce: resource) { dictionaries in
            users = dictionaries.flatMap{  User(dictionary: $0) }
            result(users)
            
        }
        
    }
    
    func removeUser(resource: Resource, completion: @escaping () -> Void)  {
        data(resorce: resource) { _ in
            completion()
        }
    }
    
    func createUser(resource: Resource, completion: @escaping (User?) -> Void)  {
        decodeObject(resorce: resource) { dict in
            guard let dict = dict else {
                completion(nil)
                return
            }
            completion(User(dictionary: dict))
        }
    }
    
    func updateUser(resource: Resource, completion: @escaping (User?) -> Void)  {
        decodeObject(resorce: resource) { dict in
            guard let dict = dict else {
                completion(nil)
                return
            }
            completion(User(dictionary: dict))
        }
    }
    
    
    
    
}
    
    
    
    
    
    
    
    

