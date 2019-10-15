//
//  DefaultSeasonTableViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/23/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class DefaultSeasonTableViewModel {
    private let showsService = ApiClient<TVShowsProvider>()
    
    private var idShow: Int!
    private var showDetailResult: TVShowDetailResult?
    
    private var seasonSelected: Int?
    
    private var episodes: [Int:[Episode]]
    private var cellModels: [Int:[SeasonListTableViewModel]]
    private var viewSeasonModel:SeasonEpisodeTableViewModel?
    
    //Bindables
    var viewState:Bindable<ViewState> = Bindable(.loading)
    
    //MARK: - Life cycle
    init(show: Int) {
        self.idShow = show
        episodes = [:]
        cellModels = [:]
    }
    
    convenience init(showDetailResult: TVShowDetailResult) {
        self.init(show: showDetailResult.id!)
        self.showDetailResult = showDetailResult
    }
    
    func getFirstSeason(){
        getEpisodesFor(season: 1)
    }
    
    func getSeason(at index: Int){
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
    
    private func isSeasonSelected(for index: Int) -> Bool{
        if let season = self.seasonSelected,
            season == index{
            print("Season ya está seleccionada: \(index)")
            return true
        }
        return false
    }
    
    private func isFetchedBefore(for season: Int) -> Bool{
        
        if let episodes = episodes[season] ,
            episodes.count > 1{
            print("Ya existen episodes, NO consultar.. Solo reload")
            return true
        }
        
        return false
    }
    
    func selectFirstSeason(){
        let firstSeason = 1
        self.seasonSelected = firstSeason

        if let model = viewSeasonModel,
            let selectedFunction = model.selectedCell{
            //print("\nSeleccionaré season desde Model: \(firstSeason)")
            selectedFunction(firstSeason)
        }
    }
    
    func getEpisode(for indexPath: Int) -> Episode?{
        if let selected = seasonSelected,
            let episodes = episodes[selected]{
            return episodes[indexPath]
        }
        return nil
    }
    
    func getModel(for indexPath: Int) -> SeasonListTableViewModel?{
        if let selected = seasonSelected,
            let models = cellModels[selected]{
            return models[indexPath]
        }
        return nil
    }
    
    func buildModelForSeasons() -> SeasonEpisodeTableViewModel{
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
    
    func buildHeaderViewModel() -> SeasonHeaderViewModel?{
        guard let show = showDetailResult else { return nil }
        return SeasonHeaderViewModel(showDetail: show)
    }
    
    //MARK: - Helper
    private func getEpisodesFor(season seasonNumber: Int){
        print("Se consulta Episodes para Season: \(seasonNumber)")
        self.viewState.value = .loading
        
        showsService.load(service: .getEpisodesFor(idShow, seasonNumber) , decodeType: SeasonResult.self, completion: { result in
            switch result{
            case .success(let response):
                self.processFetched(for: seasonNumber, response.episodes)
            case .failure(let error):
                print("error: [\(error)]")
                self.viewState.value = .error(error)
            }
        })
    }
    
    private func processFetched(for season: Int, _ fetchedEpisodes: [Episode]){
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
    
    private func createModels(for season: Int, _ episodes: [Episode]){
        let models = episodes.map({
            return SeasonListTableViewModel(episode: $0)
        })
        
        if models.count > 0{
            self.cellModels[season] = models
        }
    }
}

extension DefaultSeasonTableViewModel{
    
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
