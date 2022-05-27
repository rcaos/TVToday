//
//  GenreTableViewCell.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 7/28/20.
//

import UIKit
import Shared
import UI

class GenreTableViewCell: NiblessTableViewCell {

  private let label: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.adjustsFontForContentSizeCategory = true
    label.font = UIFont.app_title3()
    return label
  }()

  public var viewModel: GenreViewModelProtocol?

  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  func setViewModel(_ viewModel: GenreViewModelProtocol) {
    self.viewModel = viewModel
    label.text = viewModel.name
  }

  private func setupUI() {
    backgroundColor = .secondarySystemBackground
    constructHierarchy()
    activateConstraints()
  }

  private func constructHierarchy() {
    contentView.addSubview(label)
  }

  private func activateConstraints() {
    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
      label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
    ])
  }
}
