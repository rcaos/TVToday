//
//  TemporalDetailController.swift
//  MyMovies
//
//  Created by Jeans on 8/22/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import UIKit

class TemporalDetailController: UITableViewController{
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        navigationController?.navigationBar.prefersLargeTitles = false
        
        titleLabel.text = "La casa de Cristal es una de las ganadoras del"
        //titleLabel.text = "La casa de Cristal"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Table View Size: \(tableView.frame.size)")
        print("Table View Parent: \(tableView.superview?.frame.size )")
        
        print("Safe Area: \(view.safeAreaLayoutGuide.layoutFrame)")
        print("UIScreen Bounds:\(UIScreen.main.bounds)")

        print("Size of Label viewWIllApear: \(titleLabel.frame.size )")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("Size of Label viewDidAppear: [\(titleLabel.frame.size )]")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let totalHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let restante = totalHeight * 0.54
        
        var heightrow = CGFloat(0.0)
        
        
        if indexPath.row == 0{
            heightrow =  totalHeight * 0.4
        }else if indexPath.row == 1{
            heightrow = totalHeight * 0.06
        }else if indexPath.row == 2{
            heightrow = restante * 0.7
        }else if indexPath.row == 3{
            heightrow = restante * 0.3
        }else{
            heightrow = 0
        }
        
        //print("\(indexPath.row)-\(heightrow)")
        
        return CGFloat(heightrow)
    }
}
