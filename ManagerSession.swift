//
//  DataManager.swift
//  Hello World
//
//  Created by eloysn on 20/9/17.
//  Copyright © 2017 eloysn. All rights reserved.
//

import Foundation


enum errorSession: Error {
    case errorFromServer(err: Error)
    case errorInvalidStatusCode
    case errorDecodeJSON
    case errorResponse(err: Error)
    
}
final class ManagerSession {
    
    private let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
    
    private func data( resorce: Resource, completion: @escaping (Data?, Error?) -> Void)  {
        
        let task = session.dataTask(with: resorce.requestWithBaseURL()) { data, response, error in
            
            if let err = error  {
                print("error: \(err)")
                completion(nil, errorSession.errorResponse(err: err))
                
                
            }else {
                if let response  = (response as? HTTPURLResponse)?.statusCode, 200...300 ~= response     {
                    
                    if let data = data {
                     completion(data, nil)
                        
                    }
                    
                }else {
                     completion(nil, errorSession.errorInvalidStatusCode)
                }
            }
            
        }
        
        task.resume()
    }
    
    
    private func decodeObject(resorce: Resource, completion: @escaping (JSONDictionary?, Error?)  -> Void)   {
        
        data(resorce: resorce)  { (data, err) in
            if let err = err {
                completion(nil, err)
                return
                
            }
            
            guard let data = data, let JSONObject =  try? JSONSerialization.jsonObject(with: data, options:[]), let dict = JSONObject as? JSONDictionary else {
                
                completion(nil, err)
                return
            }
            
            completion(dict, nil)
        }
        
        
    }
    
    
    private func decodeObjects(resorce: Resource, completions: @escaping ([JSONDictionary], Error?) -> Void)  {
        
        data(resorce: resorce) { (data, err) in
            
            if let err = err {
                completions([JSONDictionary](), errorSession.errorFromServer(err: err))
            }
            guard let data = data, let JSONObject =  try? JSONSerialization.jsonObject(with: data, options:[]), let dict = JSONObject as? [JSONDictionary] else {
                completions([JSONDictionary](), errorSession.errorDecodeJSON)
                return
            }
            completions(dict, nil)
        }
        
        
    }
    
    
    func getUser(id: Int, result: @escaping (User?) -> Void ) {

        decodeObject(resorce: Session.getUserId(id: id)) { dict, err in
            if let _ = err  {
                result(nil)
            }
            if let dict = dict {
                result(User(dictionary: dict))
            }else{
                result(nil)
            }
            
        }
    }
    
    
    func getAllUsers(result: @escaping ([User]?) -> Void)  {
        var users = [User]()
        decodeObjects(resorce: Session.getAllUser) { dict, err in
            if let _ = err {
                result(nil)
            }else{
                users = dict.flatMap({ return User(dictionary: $0)  })
                result(users)
            }
        }
    }
    
    func removeUser(id: Int, completion: @escaping () -> Void)  {
        data(resorce: Session.remove(id: id)) { _, _ in
            completion()
        }
    }
    
    
    func createUser(user: User, completion: @escaping (User?) -> Void)  {
        decodeObject(resorce: Session.create(user: user)) { dict, err in
            guard let dict = dict else {
                completion(nil)
                return
            }
            completion(User(dictionary: dict))
        }
    }
    
    
    
    func updateUser(user: User, completion: @escaping (User?) -> Void)  {
        decodeObject(resorce: Session.update(user: user)) { dict, err in
            guard let dict = dict else {
                completion(nil)
                return
            }
            completion(User(dictionary: dict))
        }
    }
    
    
}
    
    
    
    
    
    
    
    

