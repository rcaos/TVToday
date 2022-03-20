//
//  ApiClient.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/15/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import NetworkingInterface
import RxSwift
import Combine

public protocol NetworkCancellable {
  func cancel()
}

public class ApiClient {

  private let configuration: NetworkConfigurable

  public init(with configuration: NetworkConfigurable) {
    self.configuration = configuration
  }
}

// MARK: - DataTransferService

extension ApiClient: DataTransferService {
  public func request<T, E>(with endpoint: E) -> AnyPublisher<T, DataTransferError> where T: Decodable, T == E.Response, E: ResponseRequestable {
    fatalError("unimplemented")
  }

  public func request<E>(with endpoint: E) -> AnyPublisher<Data, DataTransferError> where E: ResponseRequestable, E.Response == Data {
    fatalError("unimplemented")
  }

  public func request<Element>(_ router: EndPoint, _ decodingType: Element.Type) -> Observable<Element> where Element: Decodable {
    return Observable<Element>.create { [unowned self] (event) -> Disposable in

      let task = self.request( router.getUrlRequest(with: self.configuration)) { result in
        switch result {
        case .success(let data):
          let decoder = JSONDecoder()
          do {
            let resp = try decoder.decode(decodingType, from: data)
            event.on( .next(resp) )
          } catch {
            print("error to Decode: [\(error)]")
            event.on( .error(error))
          }
        case .failure(let error):
          print("error server: [\(error)]")
          event.on( .error(error) )
        }
        event.onCompleted()
      }

      return Disposables.create {
        task.cancel()
      }
    }
  }
}

// MARK: - Private

extension ApiClient {

  private func request(_ request: URLRequest,
                       deliverQueue: DispatchQueue = DispatchQueue.main,
                       completion: @escaping (Result<Data, APIError>) -> Void) -> URLSessionTask {
    print( "request: [\(request)]" )
    let task = URLSession.shared.dataTask(with: request) { (data, response, _) in

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
    return task
  }
}
