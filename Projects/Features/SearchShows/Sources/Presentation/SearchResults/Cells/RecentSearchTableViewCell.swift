//
//  RecentSearchTableViewCell.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 7/7/20.
//

import UIKit
import Shared

class RecentSearchTableViewCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var accesoryImageView: UIImageView!
  
  public var title: String? {
    didSet {
      setupCell()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }
  
  private func setupUI() {
    accesoryImageView.image = UIImage(name: "up-left")
  }
  
  private func setupCell() {
    titleLabel.text = title
  }
}
