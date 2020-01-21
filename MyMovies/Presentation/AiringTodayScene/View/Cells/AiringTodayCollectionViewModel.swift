//
//  AiringTodayCollectionViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 10/2/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class AiringTodayCollectionViewModel{
    
    private let imageService = ApiClient<ImagesProvider>()
    
    var show: TVShow
    var showName: String!
    var average: String!
    
    //Bindable
    var imageData:Bindable<Data?>
    
    init(show: TVShow) {
        self.show = show
        self.imageData = Bindable(nil)
        setup()
    }
    
    func setup(){
        if let name = show.name{
            self.showName = name
        }else{
            self.showName = ""
        }
        
        if let average = show.voteAverage{
            self.average = String(average)
        }else{
            average = "0.0"
        }
    }
    
    func downloadImage(){
        guard let backDropPath = show.backDropPath else { return }
        
        imageService.load(service: .getBackDrop(.mediumBackDrop, backDropPath) , completion: { result in
            switch result{
            case .success(let response):
                self.imageData.value = response
            case .failure(let error):
                print("error: [\(error)]")
            }
        })
    }
}
