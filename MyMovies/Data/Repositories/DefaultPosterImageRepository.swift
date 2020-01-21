//
//  DefaultPosterImageRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

final class DefaultPosterImageRepository {
    
    private let dataTransferService: DataTransferService
    private let imageNotFoundData: Data?
    
    init(dataTransferService: DataTransferService, imageNotFoundData: Data?) {
        self.dataTransferService = dataTransferService
        self.imageNotFoundData = imageNotFoundData
    }
}

extension DefaultPosterImageRepository: PosterImageRepository {
    
    func image(with imagePath: String,
               type: PosterImageType,
               completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable? {
        let endPoint = getProvider(path: imagePath, type: type)
        
        let networkTask = dataTransferService.request(service: endPoint) { [weak self] (response: Result<Data, Error>) in
            guard let strongSelf = self else { return }
            
            switch response {
            case .success(let data):
                completion(.success(data))
                return
            case .failure(let error):
                if let imageNotFoundData = strongSelf.imageNotFoundData {
                    completion(.success(imageNotFoundData))
                    return
                } else {
                    completion(.failure(error))
                    return
                }
            }
        }
        
        return RepositoryTask(networkTask: networkTask)
    }
    
    private func getProvider(path: String, type: PosterImageType) -> ImagesProvider {
        switch type {
        case .poster(let posterSize):
            return ImagesProvider.getPoster(posterSize, path)
        case .backDrop(let backDropSize):
            return ImagesProvider.getBackDrop(backDropSize, path)
        }
    }
}
