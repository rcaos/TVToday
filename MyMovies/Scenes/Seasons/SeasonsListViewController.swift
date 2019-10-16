//
//  SeasonsListViewController.swift
//  MyTvShows
//
//  Created by Jeans on 9/23/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class SeasonsListViewController: UIViewController {

    var seasonModel: DefaultSeasonTableViewModel?
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad SeasonsListViewController")
    }
    
    deinit {
        print("deinit parent SeasonsListViewController")
    }
    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let seasonModel = self.seasonModel else { return }
        
        if segue.identifier == "SeasonListsSegue"{
            guard let vc = segue.destination as? DefaultSeasonTableViewController else { return }
            vc.viewModel = seasonModel
        }
    }
    
}
