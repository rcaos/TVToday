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
    
    var viewModel:SeasonHeaderViewModel?{
        didSet{
            setupUI()
        }
    }
    
    //MARK: - Life Cycle
    override func awakeFromNib() {
        //print("--NIB: Se cargo Header View..")
        super.awakeFromNib()
    }
    
    func setupUI(){
        //print("Se Setean las variables...")
        showNameLabel.text = viewModel?.showName
    }
}
