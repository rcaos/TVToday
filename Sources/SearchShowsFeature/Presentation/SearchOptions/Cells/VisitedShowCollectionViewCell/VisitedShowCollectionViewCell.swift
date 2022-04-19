//
//  VisitedShowCollectionViewCell.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 7/5/20.
//

import UIKit
import Shared

class VisitedShowCollectionViewCell: NiblessCollectionViewCell {

  private let visitedImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    return imageView
  }()

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  func setModel(imageURL: String) {
    // MARK: - TODO, add placeHolder
    visitedImageView.setImage(with: URL(string: imageURL))
  }

  private func setupUI() {
    backgroundColor = .secondarySystemBackground
    constructHierarchy()
    activateConstraints()
  }

  private func constructHierarchy() {
    contentView.addSubview(visitedImageView)
  }

  private func activateConstraints() {
    activateConstraintsForImage()
  }

  private func activateConstraintsForImage() {
    visitedImageView.translatesAutoresizingMaskIntoConstraints = false
    visitedImageView.pin(to: contentView)
  }
}
