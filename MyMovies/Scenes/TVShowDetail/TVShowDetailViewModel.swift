//
//  TVShowDetailViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class TVShowDetailViewModel{
    
    private let showsService = ApiClient<TVShowsProvider>()
    private let imagesService = ApiClient<ImagesProvider>()
    
    var id: Int!
    var backDropPath:String?
    var nameShow: String?
    var yearsRelease: String?
    var duration: String?
    var genre: String?
    var numberOfEpisodes: String?
    var posterPath: String?
    var overView: String?
    var score: String?
    var countVote: String?
    
    var showDetail: TVShowDetailResult?
    
    //Bindables
    var viewState:Bindable<ViewState> = Bindable(.loading)
    var dropData:Bindable<Data?> = Bindable(nil)
    var posterData:Bindable<Data?> = Bindable(nil)
    
    init(_ idShow: Int){
        id = idShow
    }
    
    private func setupTVShow(_ show: TVShowDetailResult){
        id = show.id
        backDropPath = show.backDropPath
        nameShow = show.name
        yearsRelease = show.releaseYears
        duration = show.episodeDuration
        genre = show.genreIds.first?.name
        numberOfEpisodes = (show.numberOfEpisodes != nil) ? String(show.numberOfEpisodes!) : ""
        overView = show.overview
        score = (show.voteAverage != nil) ? String(show.voteAverage) : ""
        countVote = (show.voteCount != nil) ? String(show.voteCount) : ""
        
        showDetail = show
    }
    
    //MARK: - Networking
    
    func getShowDetails(id show: Int){
        self.viewState.value = .loading
        
        showsService.load(service: .getTVShowDetail(show), decodeType: TVShowDetailResult.self, completion: { result in
            switch result{
            case .success(let showDetail):
                self.setupTVShow(showDetail)
                self.viewState.value = .populated
                self.downloadImages(for: showDetail)
            case .failure(let error):
                print("Error: [\(error)]")
            }
        })
    }
    
    //MARK: - Download Images
    private func downloadImages(for show: TVShowDetailResult){
        
        if let backDropPath = show.backDropPath{
            imagesService.load(service: .getBackDrop(.mediumBackDrop, backDropPath), completion: { result in
                switch result{
                case .success(let data):
                    self.dropData.value = data
                case .failure(let error):
                    print("error to download Image: [\(error)]")
                }
                
            })
        }
        
        if let posterPath = show.posterPath{
            imagesService.load(service: .getPoster( .mediumPoster, posterPath), completion: { result in
                switch result{
                case .success(let data):
                    self.posterData.value = data
                case .failure(let error):
                    print("error to download Image: [\(error)]")
                }
                
            })
        }
    }
    
}

extension TVShowDetailViewModel{
    
    enum ViewState {
        
        case loading
        case populated
        case empty
        case error(Error)
    }
}
