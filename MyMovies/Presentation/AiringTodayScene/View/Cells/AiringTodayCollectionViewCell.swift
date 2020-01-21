//
//  AiringTodayCollectionViewCell.swift
//  MyTvShows
//
//  Created by Jeans on 10/2/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class AiringTodayCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var showNameLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    
    var viewModel: AiringTodayCollectionViewModel? {
        didSet{
            setupUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupUI(){
        guard let viewModel = viewModel else { return }
        
        showNameLabel.text = viewModel.showName
        averageLabel.text = viewModel.average
        
        if let data = viewModel.imageData.value {
            backImageView.image = UIImage(data: data)
        } else {
            print("Se descargará imagen solo para : \(showNameLabel.text)")
            viewModel.downloadImage()
        }
        
        viewModel.imageData.observe(on: self) { [weak self] data in
            if let data = data {
                self?.backImageView.image = UIImage(data: data)
            }
        }
        
        containerView.layer.cornerRadius = 14
        containerView.clipsToBounds = true
        
        backImageView.contentMode = .scaleToFill
    }
    
    override func prepareForReuse() {
        viewModel?.imageData.remove(observer: self)
        backImageView.image = nil
    }

}
