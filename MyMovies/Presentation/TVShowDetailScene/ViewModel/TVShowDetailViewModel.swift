//
//  TVShowDetailViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

enum TVShowDetailViewModelRoute {
    case initial
    case showSeasonsList(tvShowResult: TVShowDetailResult)
}

final class TVShowDetailViewModel {
    
    private let fetchDetailShowUseCase: FetchTVShowDetailsUseCase
    private let posterImagesRepository: PosterImageRepository
    
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
    
    // Routing
    var route: Bindable<TVShowDetailViewModelRoute> = Bindable(.initial)
    
    private var showsLoadTask: Cancellable? {
        willSet {
            showsLoadTask?.cancel()
        }
    }
    
    private var posterLoadTask: Cancellable? {
        willSet {
            posterLoadTask?.cancel()
        }
    }
    
    private var backDropLoadTask: Cancellable? {
        willSet {
            backDropLoadTask?.cancel()
        }
    }
    
    init(_ idShow: Int, fetchDetailShowUseCase: FetchTVShowDetailsUseCase, posterImagesRepository: PosterImageRepository) {
        self.fetchDetailShowUseCase = fetchDetailShowUseCase
        self.posterImagesRepository = posterImagesRepository
        id = idShow
    }
    
    private func setupTVShow(_ show: TVShowDetailResult) {
        id = show.id
        backDropPath = show.backDropPath
        nameShow = show.name
        yearsRelease = show.releaseYears
        duration = show.episodeDuration
        genre = show.genreIds?.first?.name
        numberOfEpisodes = (show.numberOfEpisodes != nil) ? String(show.numberOfEpisodes!) : ""
        overView = show.overview
        score = (show.voteAverage != nil) ? String(show.voteAverage!) : ""
        countVote = (show.voteCount != nil) ? String(show.voteCount!) : ""
        
        showDetail = show
    }
    
    //MARK: - Networking
    
    func getShowDetails() {
        self.viewState.value = .loading
        
        let request = FetchTVShowDetailsUseCaseRequestValue(identifier: id)
        
        showsLoadTask = fetchDetailShowUseCase.execute(requestValue: request) { [weak self] result in
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
        
        guard let backDropPath = show.backDropPath ,
            let posterPath = show.posterPath else { return }
        
        let backDropType = PosterImageType.backDrop(backDropSize: .mediumBackDrop)
        backDropLoadTask = posterImagesRepository.image(with: backDropPath, type: backDropType) { [weak self] result in
                   guard show.backDropPath == backDropPath else { return }
                   
                   switch result {
                   case .success(let data):
                       self?.dropData.value = data
                   case .failure(let error):
                        print("error to download BackDrop Image: [\(error)]")
                   }
                   self?.backDropLoadTask = nil
               }
        
        let posterType = PosterImageType.poster(posterSize: .mediumPoster)
        posterLoadTask = posterImagesRepository.image(with: posterPath, type: posterType) { [weak self] result in
            guard show.posterPath == posterPath else { return }
            
            switch result {
            case .success(let data):
                self?.posterData.value = data
            case .failure(let error):
                print("error to download Poster Image: [\(error)]")
            }
            self?.posterLoadTask = nil
        }
    }
        
    func showSeasonList() {
        guard let showDetail = showDetail else { return }
        route.value = .showSeasonsList(tvShowResult: showDetail)
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
