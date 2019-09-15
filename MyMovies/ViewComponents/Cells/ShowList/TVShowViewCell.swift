//
//  TVShowViewCell.swift
//  MyTvShows
//
//  Created by Jeans on 9/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class TVShowViewCell: UITableViewCell {

    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var averageLabel: UILabel!

    var show:TVShow?{
        didSet{
            setupUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupUI(){
        guard let show = show else {
            return
        }
        
        nameLabel.text = show.name
        if let average = show.voteAverage{
            averageLabel.text = String(average)
        }
    }
    
}
