//
//  DefaultDataTransferService.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

public final class DefaultDataTransferService {
    
    private let networkService: NetworkService
    private let errorResolver: DataTransferErrorResolver
    
    public init(with networkService: NetworkService,
                errorResolver: DataTransferErrorResolver = DefaultDataTransferErrorResolver()) {
        self.networkService = networkService
        self.errorResolver = errorResolver
    }
}

extension DefaultDataTransferService: DataTransferService {
    
    //MARK: - Public Method Request
    
    public func request<T: Decodable, E: ResponseRequestable>(with endpoint: E,
                                                              completion: @escaping CompletionHandler<T>) -> NetworkCancellable? where E.Response == T {
        
        return self.networkService.request(endpoint: endpoint) { result in
            switch result {
            case .success(let data):
                let result: Result<T, Error> = self.decode(data: data, decoder: endpoint.responseDecoder)
                DispatchQueue.main.async { return completion(result) }
            case .failure(let error):
                let error = self.resolve(networkError: error)
                DispatchQueue.main.async { return completion(.failure(error)) }
            }
        }
    }
    
    // MARK: - Private
    
    private func decode<T: Decodable>(data: Data?, decoder: ResponseDecoder) -> Result<T, Error> {
        do {
            guard let data = data else { return .failure(DataTransferError.noResponse) }
            let result: T = try decoder.decode(data)
            return .success(result)
        } catch {
            return .failure(DataTransferError.parsing(error))
        }
    }
    
    private func resolve(networkError error: NetworkError) -> DataTransferError {
        let resolvedError = self.errorResolver.resolve(error: error)
        return resolvedError is NetworkError ? .networkFailure(error) : .resolvedNetworkFailure(resolvedError)
    }
}
