//
//  AiringTodayCell.swift
//  MyMovies
//
//  Created by Jeans on 8/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class AiringTodayCell: UITableViewCell {

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var averageLabel: UILabel!
    
    var show: TVShow? {
        didSet{
            if let show = show{
                nameLabel.text = show.name
                averageLabel.text = String(show.voteAverage)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
