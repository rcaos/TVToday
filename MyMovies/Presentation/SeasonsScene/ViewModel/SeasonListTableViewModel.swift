//
//  SeasonListTableViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/23/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class SeasonListTableViewModel {
    private let imageService = ApiClient<ImagesProvider>()
    
    var episodeNumber: String?
    var episodeName: String?
    var releaseDate: String?
    var average: String?
    
    var episode: Episode!
    
    //Bindables
    var imageData: Bindable<Data?>
    
    
    init(episode: Episode) {
        self.episode = episode
        self.imageData = Bindable(nil)
        setupData()
    }
    
    private func setupData() {
        episodeNumber = String(episode.episodeNumber) + "."
        episodeName = episode.name
        releaseDate = episode.airDate
        average = episode.average
    }
    
    func downloadImage() {
        guard let episodePath = episode.episodePath else { return }
        
        imageService.load(service: .getPoster(.mediumPoster , episodePath) , completion: { result in
            switch result{
            case .success(let data):
                self.imageData.value = data
            case .failure(let error):
                print("error to Download Image: [\(error)]")
            }
        })
    }
}


