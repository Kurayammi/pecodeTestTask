//
//  NetworkManager.swift
//  Pecode Test
//
//  Created by Kito on 11/3/22.
//

import Foundation

enum ResponceResult<T> {
    case success(T)
    case failure
}

final class NetworkManager {
    
    func sendRequest<T: Decodable>(with url: URL, objectType: T.Type, completion: @escaping (ResponceResult<T>)->Void) {
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            guard error == nil else {
                completion(ResponceResult.failure)
                return
            }
            guard let data = data else {
                completion(ResponceResult.failure)
                return
            }
            do {
                //create decodable object from data
                let decodedObject = try JSONDecoder().decode(objectType.self, from: data)
                completion(ResponceResult.success(decodedObject))
                
            } catch let error {
                print(error)
                completion(ResponceResult.failure)
            }
        })
        task.resume()
    }
}
