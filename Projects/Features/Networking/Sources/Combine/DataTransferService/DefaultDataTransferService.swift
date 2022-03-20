//
//  DefaultDataTransferService.swift
//  Networking
//
//  Created by Jeans Ruiz on 19/03/22.
//

import Foundation
import Combine
import NetworkingInterface
import RxSwift    // Remove Soon

public final class DefaultDataTransferService {

  private let networkService: NetworkService
  private let errorResolver: DataTransferErrorResolver
  private let errorLogger: DataTransferErrorLogger
  private let apiClient: ApiClient  // remove soon

  public init(with networkService: NetworkService,
              errorResolver: DataTransferErrorResolver = DefaultDataTransferErrorResolver(),
              errorLogger: DataTransferErrorLogger = DefaultDataTransferErrorLogger(),
              apiClient: ApiClient // remove soon
  ) {
    self.networkService = networkService
    self.errorResolver = errorResolver
    self.errorLogger = errorLogger
    self.apiClient = apiClient // remove soon
  }
}

// MARK: - Renamed
extension DefaultDataTransferService: DataTransferService {

  public func request<Element>(_ router: EndPoint, _ decodingType: Element.Type) -> Observable<Element> where Element: Decodable {
    return apiClient.request(router, decodingType)
  }

  // MARK: - Private
  private func decode<T: Decodable>(data: Data, decoder: ResponseDecoder) throws -> T {
    do {
      let result: T = try decoder.decode(data)
      return result
    } catch {
      self.errorLogger.log(error: error)
      throw DataTransferError.parsing(error)
    }
  }

  private func resolve(networkError error: NetworkError) -> DataTransferError {
    let resolvedError = self.errorResolver.resolve(error: error)
    return resolvedError is NetworkError ? .networkFailure(error) : .resolvedNetworkFailure(resolvedError)
  }

  public func request<T, E>(with endpoint: E) -> AnyPublisher<T, DataTransferError> where T: Decodable, T == E.Response, E: ResponseRequestable {

    return networkService.request(endpoint: endpoint)
      .tryMap { data -> T in
        let result: T = try self.decode(data: data, decoder: endpoint.responseDecoder)
        return result
      }
      .mapError { error -> DataTransferError in
        self.errorLogger.log(error: error)

        if let networkError = error as? NetworkError {
          let transferError = self.resolve(networkError: networkError)
          return transferError
        } else if let transferError = error as? DataTransferError {
          return transferError
        } else {
          return DataTransferError.resolvedNetworkFailure(error)
        }
      }
      .eraseToAnyPublisher()
  }

  public func request<E>(with endpoint: E) -> AnyPublisher<Data, DataTransferError> where E: ResponseRequestable, E.Response == Data {
    return networkService.request(endpoint: endpoint)
      .mapError { networkError -> DataTransferError in
        self.errorLogger.log(error: networkError)
        let transferError = self.resolve(networkError: networkError)
        return transferError
      }
      .eraseToAnyPublisher()
  }
}
