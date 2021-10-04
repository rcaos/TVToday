//
//  VisitedShowCollectionViewCell.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 7/5/20.
//

import UIKit

class VisitedShowCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var visitedImageView: UIImageView!

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  func setupCell(with imageURL: String) {
    visitedImageView.setImage(with: URL(string: imageURL))
  }
}
