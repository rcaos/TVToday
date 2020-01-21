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
    
    var viewModel: SeasonListTableViewModel? {
        didSet{
            setupUI()
            setupBindables()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupUI() {
        durationLabel.text = ""
        
        episodeNumberLabel.text = viewModel?.episodeNumber
        episodeNameLabel.text = viewModel?.episodeName
        releaseLabel.text = viewModel?.releaseDate
        averageLabel.text = viewModel?.average
    }
    
    func setupBindables() {
        guard let viewModel = viewModel else { return }
        
        if viewModel.imageData.value == viewModel.imageNotFound {
            print("Se descargará imagen solo para Episode : \(viewModel.episodeNumber)")
            viewModel.downloadImage()
        }
        
        if let data = viewModel.imageData.value {
            episodeImage.image = UIImage(data: data)
        }
        
        viewModel.imageData.observe(on: self) {[weak self] data in
            if let data = data {
                self?.episodeImage.image = UIImage(data: data)
            }
        }
    }
    
    override func prepareForReuse() {
        viewModel?.imageData.remove(observer: self)
    }
}
