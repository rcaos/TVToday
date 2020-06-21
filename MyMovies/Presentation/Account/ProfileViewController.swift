//
//  ProfileViewController.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet weak var mainLabel: UILabel!
  
  private var viewModel: ProfileViewModel!
  
  static func create(with viewModel: ProfileViewModel) -> ProfileViewController {
    let controller = ProfileViewController.instantiateViewController(fromStoryBoard: "AccountViewController")
    controller.viewModel = viewModel
    return controller
  }
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
}
