//
//  SeasonListTableViewCell.swift
//  MyTvShows
//
//  Created by Jeans on 9/23/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class SeasonListTableViewCell: UITableViewCell {

    @IBOutlet private weak var episodeImage: UIImageView!
    @IBOutlet private weak var episodeNumberLabel: UILabel!
    @IBOutlet private weak var episodeNameLabel: UILabel!
    @IBOutlet private weak var releaseLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var averageLabel: UILabel!
    
    var viewModel: SeasonListTableViewModel?{
        didSet{
            setupUI()
            setupBindables()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupUI(){
        durationLabel.text = ""
        
        episodeNumberLabel.text = viewModel?.episodeNumber
        episodeNameLabel.text = viewModel?.episodeName
        releaseLabel.text = viewModel?.releaseDate
        //durationLabel.text = viewModel?.duration
        averageLabel.text = viewModel?.average
        
        //if viewModel?.imageData?.value == nil{
            //print("Here nil data")
        episodeImage.image = UIImage(named: "placeholder2")
        //}
    }
    
    func setupBindables(){
        guard let viewModel = viewModel else { return }
        
        if let data = viewModel.data{
            episodeImage.image = UIImage(data: data)
        }
    }
}
