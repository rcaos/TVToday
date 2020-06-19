//
//  AccountViewController.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, StoryboardInstantiable {
    
    private var viewModel: AccountViewModel!
    
    static func create(with viewModel: AccountViewModel) -> AccountViewController {
        let controller = AccountViewController.instantiateViewController()
        controller.viewModel = viewModel
        return controller
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
    }
    
    // MARK: - Setup UI
    
    func setupUI() {
        
    }
    
    func setupViews() {
        
    }
}
