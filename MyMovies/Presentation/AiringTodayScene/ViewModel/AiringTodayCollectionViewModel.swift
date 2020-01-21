//
//  AiringTodayCollectionViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 10/2/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class AiringTodayCollectionViewModel {
    
    private let posterImagesRepository: PosterImageRepository
    
    private var imageLoadTask: Cancellable? {
        willSet {
            imageLoadTask?.cancel()
        }
    }
    
    var show: TVShow
    var showName: String!
    var average: String!
    
    //Bindable
    var imageData:Bindable<Data?>
    
    init(show: TVShow, posterImagesRepository: PosterImageRepository) {
        self.show = show
        self.imageData = Bindable(nil)
        self.posterImagesRepository = posterImagesRepository
        
        setup()
    }
    
    func setup() {
        self.showName = show.name ?? ""
        
        if let average = show.voteAverage {
            self.average = String(average)
        }else {
            average = "0.0"
        }
    }
    
    func downloadImage() {
        guard let backDropPath = show.backDropPath else { return }
        
        let imageType = PosterImageType.backDrop(backDropSize: .mediumBackDrop)
        
        imageLoadTask = posterImagesRepository.image(with: backDropPath, type: imageType) { [weak self] result in
            guard self?.show.backDropPath == backDropPath else { return }
            
            switch result {
            case .success(let data):
                self?.imageData.value = data
            case .failure(let error):
            print("error to Download Poster Image: [\(error)]")
            }
            self?.imageLoadTask = nil
        }
    }
}
