//
//  AiringTodayCollectionViewCell.swift
//  MyTvShows
//
//  Created by Jeans on 10/2/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class AiringTodayCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var showNameLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    
    var viewModel: AiringTodayCollectionViewModel?{
        didSet{
            setupUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupUI(){
        showNameLabel.text = viewModel?.showName
        averageLabel.text = viewModel?.average
        
        viewModel?.imageData.bindAndFire({ data in
            if let data = data{
                self.backImageView.image = UIImage(data: data)
            }
        })
    }
    
    override func prepareForReuse() {
        backImageView.image = nil
    }

}
