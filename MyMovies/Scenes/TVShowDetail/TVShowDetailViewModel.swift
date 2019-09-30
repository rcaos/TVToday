//
//  TVShowDetailViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class TVShowDetailViewModel{
    
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
    
    var dropData:Bindable<Data?> = Bindable(nil)
    var posterData:Bindable<Data?> = Bindable(nil)
    var updateUI: (()-> Void)?
    var isLoading:Bindable<Bool>?
    
    var showDetail: TVShowDetailResult?
    
    init(_ idShow: Int){
        id = idShow
        isLoading = Bindable(true)
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
        self.isLoading?.value = true
        
        TMDBClient.getTVShowDetail(id: show, completion: { result, error in
            if let showDetail = result{
                self.isLoading?.value = false
                
                self.setupTVShow(showDetail)
                self.updateUI?()
                self.downloadImages(for: showDetail)
                
                self.showDetail = showDetail
            }
        })
    }
    
    //MARK: - Download Images
    private func downloadImages(for show: TVShowDetailResult){
        if let backDropPath = show.backDropPath{
            TMDBClient.getImage(size: .mediumBackDrop, path: backDropPath, completion: {
                data, error in
                if let data = data{
                    self.dropData.value = data
                }
            })
        }
        
        if let posterPath = show.posterPath{
            TMDBClient.getImage(size: .mediumPoster, path: posterPath, completion: {
                data, error in
                if let data = data{
                    self.posterData.value = data
                }
            })
        }
    }
    
}
