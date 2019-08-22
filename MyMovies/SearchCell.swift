//
//  SearchCell.swift
//  MyMovies
//
//  Created by Jeans on 8/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet private var genreNameLabel: UILabel!

    var genre: Genre?{
        didSet{
            if let genre = genre{
                genreNameLabel.text = genre.name
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
