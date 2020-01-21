//
//  HeaderView.swift
//  MyTvShows
//
//  Created by Jeans on 9/25/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class SeasonHeaderView: UIView {

    @IBOutlet weak var showNameLabel: UILabel!
    
    var viewModel:SeasonHeaderViewModel? {
        didSet{
            setupUI()
        }
    }
    
    //MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupUI() {
        showNameLabel.text = viewModel?.showName
    }
}
