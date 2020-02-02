//
//  SeasonsListViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/23/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class SeasonsListViewModel {
    
    private let fetchEpisodesUseCase: FetchEpisodesUseCase
    private let posterImageRepository: PosterImageRepository
    
    private var idShow: Int!
    private var showDetailResult: TVShowDetailResult?
    
    private var seasonSelected: Int?
    
    private var episodes: [Int:[Episode]]
    private var cellModels: [Int:[SeasonListTableViewModel]]
    private var viewSeasonModel:SeasonEpisodeTableViewModel?
    
    var viewState:Observable<ViewState> = Observable(.loading)
    
    private var showsLoadTask: Cancellable? {
        willSet {
            showsLoadTask?.cancel()
        }
    }
    
    //MARK: - Initializers
    
    init(showDetailResult: TVShowDetailResult, fetchEpisodesUseCase: FetchEpisodesUseCase, posterImageRepository: PosterImageRepository) {
        self.idShow = showDetailResult.id
        self.showDetailResult = showDetailResult
        episodes = [:]
        cellModels = [:]
            
        self.fetchEpisodesUseCase = fetchEpisodesUseCase
        self.posterImageRepository = posterImageRepository
    }
    
    func getFirstSeason() {
        getEpisodesFor(season: 1)
    }
    
    func getSeason(at index: Int) {
        let numberOfSeason = index + 1
        
        if isSeasonSelected(for: numberOfSeason) {
            return
        }
        
        if isFetchedBefore(for: numberOfSeason){
            self.seasonSelected = numberOfSeason
            self.viewState.value = .populated( episodes[numberOfSeason]!  )
            return
        }
        
        getEpisodesFor(season: numberOfSeason)
    }
    
    private func isSeasonSelected(for index: Int) -> Bool {
        if let season = self.seasonSelected,
            season == index{
            print("Season ya está seleccionada: \(index)")
            return true
        }
        return false
    }
    
    private func isFetchedBefore(for season: Int) -> Bool {
        
        if let episodes = episodes[season] ,
            episodes.count > 1{
            print("Ya existen episodes, NO consultar.. Solo reload")
            return true
        }
        
        return false
    }
    
    func selectFirstSeason() {
        let firstSeason = 1
        self.seasonSelected = firstSeason

        if let model = viewSeasonModel,
            let selectedFunction = model.selectedCell {
            selectedFunction(firstSeason)
        }
    }
    
    func getEpisode(for indexPath: Int) -> Episode? {
        if let selected = seasonSelected,
            let episodes = episodes[selected]{
            return episodes[indexPath]
        }
        return nil
    }
    
    func getModel(for indexPath: Int) -> SeasonListTableViewModel? {
        if let selected = seasonSelected,
            let models = cellModels[selected]{
            return models[indexPath]
        }
        return nil
    }
    
    func buildModelForSeasons() -> SeasonEpisodeTableViewModel {
        print("Me pide el Model para el Collection View.. \(seasonSelected)")
        var seasons:[Int] = []
        
        if let numberOfSeasons = showDetailResult?.numberOfSeasons{
            for index in 1...numberOfSeasons{
                seasons.append( index )
            }
        }
        
        self.viewSeasonModel = SeasonEpisodeTableViewModel(seasons: seasons)
        return viewSeasonModel!
    }
    
    func buildHeaderViewModel() -> SeasonHeaderViewModel? {
        guard let show = showDetailResult else { return nil }
        return SeasonHeaderViewModel(showDetail: show)
    }
    
    //MARK: - Helper
    
    private func getEpisodesFor(season seasonNumber: Int) {
        print("Se consulta Episodes para Season: \(seasonNumber)")
        self.viewState.value = .loading
        
        let request = FetchEpisodesUseCaseRequestValue(showIdentifier: idShow, seasonNumber: seasonNumber)
        
        showsLoadTask = fetchEpisodesUseCase.execute(requestValue: request) { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let response):
                strongSelf.processFetched(with: response)
            case .failure(let error):
                print("error: [\(error)]")
                strongSelf.viewState.value = .error(error)
            }
        }
    }
    
    private func processFetched(with response: SeasonResult) {
        let fetchedEpisodes = response.episodes ?? []
        let season = response.seasonNumber
        
        print("Se recibieron: \(fetchedEpisodes.count) episodios para Season: \(season)")
        if fetchedEpisodes.isEmpty{
            self.viewState.value = .empty
        }
        
        let ordered = fetchedEpisodes.sorted(by: {
            $0.episodeNumber < $1.episodeNumber
        })
        
        self.episodes[season] = ordered
        self.seasonSelected = season
        self.createModels(for: season, ordered)
        self.viewState.value = .populated(ordered)
    }
    
    private func createModels(for season: Int, _ episodes: [Episode]) {
        let models = episodes.map({
            return SeasonListTableViewModel(
                episode: $0, posterImagesRepository: self.posterImageRepository)
        })
        
        if models.count > 0{
            self.cellModels[season] = models
        }
    }
}

extension SeasonsListViewModel {
    
    enum ViewState {
        
        case loading
        case populated([Episode])
        case empty
        case error(Error)
        
        var currentEpisodes : [Episode] {
            switch self{
            case .populated(let episodes):
                return episodes
            default:
                return []
            }
        }
    }
}
