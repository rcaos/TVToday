//
//  ApiClient.swift
//  TVToday
//
//  Created by Jeans on 10/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

class ApiClient<T: EndPoint> {
    var urlSession = URLSession.shared
    
    init() { }
    
    func load(service: T, completion: @escaping (Result<Data, APIError>) -> Void) {
        call(service.urlRequest, completion: completion)
    }
    
    func load<U>(service: T, decodeType: U.Type, completion: @escaping (Result<U, APIError>) -> Void) where U: Decodable {
        call(service.urlRequest) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let resp = try decoder.decode(decodeType, from: data)
                    completion(.success(resp))
                }
                catch {
                    print("error here?")
                    completion(.failure( .requestFailed ))
                }
            case .failure(let error):
                print("error here? 2")
                completion(.failure(error))
            }
        }
    }
}

extension ApiClient {
    private func call(_ request: URLRequest, deliverQueue: DispatchQueue = DispatchQueue.main, completion: @escaping (Result<Data, APIError>) -> Void) {
        print( "url request: [\(request)]\n" )
        let task = urlSession.dataTask(with: request) { (data, response, _) in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                deliverQueue.async {
                    completion( .failure(.requestFailed) )
                }
                return
            }
            
            if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                if let data = data {
                    deliverQueue.async {
                        completion( .success( data ))
                    }
                } else {
                    deliverQueue.async {
                        completion( .failure(  .invalidData ))
                    }
                }
            } else {
                deliverQueue.async {
                    completion( .failure( APIError(response: httpResponse) ))
                }
            }
        }
        task.resume()
    }
}
