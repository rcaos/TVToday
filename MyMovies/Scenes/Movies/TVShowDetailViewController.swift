//
//  TVShowDetailViewController.swift
//  MyMovies
//
//  Created by Jeans on 8/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class TVShowDetailViewController: UITableViewController {

    public var idShow:Int!
    
    private var tvShow: TVShowDetailResult!
    
    @IBOutlet weak private var backDropImage: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var yearInitLabel: UILabel!
    @IBOutlet weak private var yearEndLabel: UILabel!
    @IBOutlet weak private var durationLabel: UILabel!
    @IBOutlet weak private var genreLabel: UILabel!
    @IBOutlet weak private var numberOfEpisodes: UILabel!
    @IBOutlet weak private var posterImage: UIImageView!
    @IBOutlet weak private var overViewLabel: UITextView!
    @IBOutlet weak private var scoreLabel: UILabel!
    @IBOutlet weak private var countVoteLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false

        if let idShow = idShow{
            TMDBClient.getTVShowDetail(id: idShow, completion: handleGetTVShowDetail(tvShow:error:))
        }
    }
  
    private func handleGetTVShowDetail(tvShow:TVShowDetailResult?, error: Error?){
        if let show = tvShow{
            self.tvShow = show
            DispatchQueue.main.async {
                self.updateLayout()
                self.downloadImages()
            }
        }
    }
    
    private func updateLayout(){
        nameLabel.text = tvShow.name
        yearInitLabel.text = getYear(from: tvShow.firstAirDate)
        yearEndLabel.text = getYear(from: tvShow.lasttAirDate)
        
        if let runtime = tvShow.episodeRunTime.first{
            durationLabel.text = "\(String(runtime)) min"
        }else{
            durationLabel.text = "--"
        }
        genreLabel.text = tvShow.genreIds.first?.name
       
        numberOfEpisodes.text = (tvShow.numberOfEpisodes != nil) ? String(tvShow.numberOfEpisodes!) : ""
        
        overViewLabel.text = tvShow.overview
        scoreLabel.text = (tvShow.voteAverage != nil) ? String(tvShow.voteAverage) : ""
        countVoteLabel.text = (tvShow.voteCount != nil) ? String(tvShow.voteCount) : ""
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
    
    private func downloadImages(){
        if let backDropPath = tvShow.backDropPath{
            TMDBClient.getImage(size: .mediumBackDrop, path: backDropPath, completion: {
                data, error in
                if let data = data{
                    DispatchQueue.main.async {
                        self.backDropImage.image = UIImage(data: data)
                    }
                }
            })
        }
        
        if let posterPath = tvShow.posterPath{
            TMDBClient.getImage(size: .mediumPoster, path: posterPath, completion: {
                data, error in
                if let data = data{
                    DispatchQueue.main.async {
                        self.posterImage.image = UIImage(data: data)
                    }
                }
            })
        }
    }
}

extension TVShowDetailViewController{
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 1{
            return true
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row == 1{
            print("Only Episode Guide Selected: [\(indexPath.row)]")
            return indexPath
        }else{
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let percentFirstRow = CGFloat(0.45)
        let fixedSecondRow = CGFloat(50.0)
        
        let totalHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let restOfHeight = (totalHeight * (1-percentFirstRow) ) - fixedSecondRow
        
        var heightrow = CGFloat(0.0)
        
        if indexPath.row == 0{
            heightrow =  totalHeight * ( percentFirstRow )
        }else if indexPath.row == 1{
            heightrow = fixedSecondRow
        }else if indexPath.row == 2{
            heightrow = restOfHeight * 0.65
        }else if indexPath.row == 3{
            heightrow = restOfHeight * 0.35
        }else{
            heightrow = 0
        }
        return CGFloat(heightrow)
    }
}
