//
//  DataManager.swift
//  Hello World
//
//  Created by eloysn on 20/9/17.
//  Copyright © 2017 eloysn. All rights reserved.
//

import Foundation
import RxSwift


enum ErrorSession: Error {
    case errorFromServer(err: Error)
    case errorInvalidStatusCode
    case errorDecodeJSON
    case other(error: Error)
    
}
//Manager utilizado para manejar la respuesta del servidor
final class ManagerSession {
    
    fileprivate let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
    
    
    //MARK: - metodos privados para manejar la sesion, en funcion de los recursos pasados, con RXSwift
    private func data (resorce: Resource) -> Observable<Data> {
        
        return Observable.create { observer in
            let task = self.session.dataTask(with: resorce.requestWithBaseURL()) { data, response, error in
                if let error = error  {
                    observer.onError(ErrorSession.other(error: error))
                }
                if let response  = (response as? HTTPURLResponse)?.statusCode, 200...300 ~= response     {
                    observer.onNext(data ?? Data())
                    observer.onCompleted()
                }else{
                     observer.onError(ErrorSession.errorInvalidStatusCode)
                }
                
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
   private func decodeObject (resorce: Resource) -> Observable<JSONDictionary>{
        
        return data(resorce: resorce).map{ data in
            guard let JSONObject =  try? JSONSerialization.jsonObject(with: data, options:[]),
                let dict = JSONObject as? JSONDictionary else {
                    throw ErrorSession.errorDecodeJSON
            }
            
            return  dict
        }
        
    }

    
     private func decodeObjects (resorce: Resource) -> Observable<[JSONDictionary]>  {
        
        return data(resorce: resorce).map{ data in
            guard let JSONObject =  try? JSONSerialization.jsonObject(with: data, options:[]),
                let dictJSON = JSONObject as? [JSONDictionary] else {
                throw ErrorSession.errorDecodeJSON
            }
            return dictJSON
        }
        
    }
    
    func updateUser  (user: User) -> Observable<User?>  {
        
        return decodeObject(resorce: Session.update(user: user)).map{ JSONDict   in
            User(dictionary: JSONDict)
        }
        
    }
    func createUser(user: User) -> Observable<User?> {
        return decodeObject(resorce: Session.create(user: user)).map{ JSONDict   in
            User(dictionary: JSONDict)
        }
    }
    
    func removeUser(id: Int, completed: @escaping ()->())   {
        let _ = decodeObject(resorce: Session.remove(id: id)).subscribe {  _ in
        completed()
        }
        
    
    }
    func getUser(id: Int) -> Observable<User?> {
        return decodeObject(resorce: Session.getUserId(id: id)).map{ JSONDict   in
            User(dictionary: JSONDict)
        }
        
    }
    
    
    func getAllUsers() -> Observable<[User?]>  {
        
          return  decodeObjects(resorce: Session.getAllUser).flatMap { JsonDict  -> Observable<[User?]> in
            var arr = [User?]()
            for i in JsonDict {
                arr.append(User(dictionary: i))
            }
            return Observable.from(optional: arr)
        }
       
    }
    
}

//MARK: - metodos privados para manejar la sesion, en funcion de los recursos pasados
extension ManagerSession {
    
    private func data( resorce: Resource, completion: @escaping (Data?, Error?) -> Void)  {
        
        let task = session.dataTask(with: resorce.requestWithBaseURL()) { data, response, error in
            
            if let err = error  {
                print("error: \(err)")
                completion(nil, ErrorSession.other(error: err))
                
                
            }else {
                if let response  = (response as? HTTPURLResponse)?.statusCode, 200...300 ~= response     {
                    
                    if let data = data {
                        completion(data, nil)
                        
                    }
                    
                }else {
                    completion(nil, ErrorSession.errorInvalidStatusCode)
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
                completions([JSONDictionary](), ErrorSession.errorFromServer(err: err))
            }
            guard let data = data, let JSONObject =  try? JSONSerialization.jsonObject(with: data, options:[]), let dict = JSONObject as? [JSONDictionary] else {
                completions([JSONDictionary](), ErrorSession.errorDecodeJSON)
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
    
    
    
    
    
    

    
    
    
    
    
    
    
    

