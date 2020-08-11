//
//  HeaderSeasonsTableViewCell.swift
//  ShowDetails
//
//  Created by Jeans Ruiz on 8/11/20.
//

import UIKit
import UI

class HeaderSeasonsTableViewCell: UITableViewCell {
  
  @IBOutlet weak var showNameLabel: UILabel!
  @IBOutlet weak var seasonsLabel: UILabel!
  
  var viewModel: SeasonHeaderViewModelProtocol? {
    didSet {
      setupUI()
    }
  }
  
  override func awakeFromNib() {
    setupUIElements()
  }
  
  private func setupUIElements() {
    showNameLabel.font = Font.sanFrancisco.of(type: .bold, with: .custom(22))
    showNameLabel.textColor = Colors.electricBlue.color
    
    seasonsLabel.textColor = Colors.davyGrey.color
    seasonsLabel.text = "Seasons:"
  }
  
  private func setupUI() {
    showNameLabel.text = viewModel?.showName
  }
}
