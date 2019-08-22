//
//  AiringTodayTableViewCell.swift
//  MyMovies
//
//  Created by Jeans on 8/20/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class PopularShowsCell: UITableViewCell {

    //let show:TVShow?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var averageLabel: UILabel!
    
    var tvShow:TVShow? {
        didSet {
            if let tvShow = tvShow{
                self.titleLabel.text = tvShow.name
                self.averageLabel.text = String(tvShow.voteAverage)
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
