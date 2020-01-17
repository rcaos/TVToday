//
//  TVShowDetailViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class TVShowDetailViewModel {
    
    private let fetchDetailShowUseCase: FetchTVShowDetailsUseCase?
    
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
    
    init(_ idShow: Int, fetchDetailShowUseCase: FetchTVShowDetailsUseCase?) {
        self.fetchDetailShowUseCase = fetchDetailShowUseCase
        id = idShow
    }
    
    private func setupTVShow(_ show: TVShowDetailResult) {
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
    
    func getShowDetails() {
        self.viewState.value = .loading
        
        let request = FetchTVShowDetailsUseCaseRequestValue(identifier: id)
        
        fetchDetailShowUseCase?.execute(requestValue: request) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                strongSelf.processFetched(for: response)
            case .failure(let error):
                // MARK: - TODO // Handle error at View
                print("Error to fetch Case use \(error)")
            }
        }
    }
    
    private func processFetched(for response: TVShowDetailResult) {
        self.setupTVShow(response)
        self.viewState.value = .populated
        self.downloadImages(for: response)
    }
    
    //MARK: - Download Images
    
    private func downloadImages(for show: TVShowDetailResult) {
        
        if let backDropPath = show.backDropPath {
            imagesService.load(service: .getBackDrop(.mediumBackDrop, backDropPath), completion: { result in
                switch result{
                case .success(let data):
                    self.dropData.value = data
                case .failure(let error):
                    print("error to download Image: [\(error)]")
                }
                
            })
        }
        
        if let posterPath = show.posterPath {
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
    
    //MARK: View Model Building
    func buildSeasonViewModel() -> DefaultSeasonTableViewModel {
        return DefaultSeasonTableViewModel(showDetailResult: showDetail!)
    }
    
}

extension TVShowDetailViewModel {
    
    enum ViewState {
        
        case loading
        case populated
        case empty
        case error(Error)
    }
}
