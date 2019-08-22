//
//  TVShowDetailViewController.swift
//  MyMovies
//
//  Created by Jeans on 8/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class TVShowDetailViewController: UITableViewController {

    var idShow: Int?
    var tvShow: TVShowDetail!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearInitLabel: UILabel!
    @IBOutlet weak var yearEndLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var numberOfEpisodes: UILabel!
    @IBOutlet weak var overViewLabel: UITextView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var countVoteLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let idShow = idShow{
            TMDBClient.getTVShowDetail(id: idShow, completion: handleGetTVShowDetail(tvShow:error:))
        }
    }
    
    func updateLayout(){
        nameLabel.text = tvShow.name
        yearInitLabel.text = getYear(from: tvShow.firstAirDate)
        yearEndLabel.text = getYear(from: tvShow.lasttAirDate)
        if let runtime = tvShow.episodeRunTime.first{
            durationLabel.text = "\(String(runtime)) min"
        }else{
            durationLabel.text = "--"
        }
        genreLabel.text = tvShow.genreIds.first?.name
        numberOfEpisodes.text = String(tvShow.numbeOfEpisodes)
        overViewLabel.text = tvShow.overview
        
        scoreLabel.text = String(tvShow.voteAverage)
        countVoteLabel.text = String(tvShow.voteCount)
    }
    
    private func getYear(from dateString: String?) -> String{
        guard let dateString = dateString else{
            return "-"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: dateString){
            formatter.dateFormat = "yyyy"
            let yearString = formatter.string(from: date)
            return yearString
        }else{
            return "-"
        }
    }
    
    func handleGetTVShowDetail(tvShow:TVShowDetail?, error: Error?){
        if let show = tvShow{
            
            self.tvShow = show
            DispatchQueue.main.async {
                self.updateLayout()
            }
        }
    }
    
}
