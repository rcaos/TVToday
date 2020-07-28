//
//  GenreTableViewCell.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 7/28/20.
//

import UIKit
import UI

class GenreTableViewCell: UITableViewCell {
  
  @IBOutlet weak public var regularTextLabel: TVRegularLabel!
  
  public var viewModel: GenreViewModel? {
    didSet {
      setupUI()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  // MARK: - Private
  
  private func setupUI() {
    guard let viewModel = viewModel else { return }
    regularTextLabel.text = viewModel.name
  }
  
  deinit {
    print("deinit GenreTableViewCell")
  }
}
