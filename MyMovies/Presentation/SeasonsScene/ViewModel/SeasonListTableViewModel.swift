//
//  SeasonListTableViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/23/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class SeasonListTableViewModel {
    
    private let posterImagesRepository: PosterImageRepository
    
    private var imageLoadTask: Cancellable? {
        willSet {
            imageLoadTask?.cancel()
        }
    }
    
    var episodeNumber: String?
    var episodeName: String?
    var releaseDate: String?
    var average: String?
    
    var episode: Episode!
    
    var imageData: Observable<Data?>
    
    var imageNotFound: Data?
    
    init(episode: Episode, posterImagesRepository: PosterImageRepository) {
        self.episode = episode
        self.imageData = Observable(nil)
        self.posterImagesRepository = posterImagesRepository
        setupData()
    }
    
    private func setupData() {
        episodeNumber = String(episode.episodeNumber) + "."
        episodeName = episode.name
        releaseDate = episode.airDate
        average = episode.average
        
        imageNotFound = posterImagesRepository.imageNotFound
        imageData.value = posterImagesRepository.imageNotFound
    }
    
    func downloadImage() {
        guard let episodePath = episode.episodePath else { return }
        
        let posterType = PosterImageType.poster(posterSize: .mediumPoster)
        
        imageLoadTask = posterImagesRepository.image(with: episodePath, type: posterType) { [weak self] result in
            guard self?.episode.episodePath == episodePath else { return }
            
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


