//
//  GenreViewCell.swift
//  MyTvShows
//
//  Created by Jeans on 9/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class GenreViewCell: UITableViewCell {

    var genre:Genre?{
        didSet{
            setupUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupUI(){
        guard let genre = genre else {
            return
        }
        
        textLabel?.text = genre.name
    }
    
}
