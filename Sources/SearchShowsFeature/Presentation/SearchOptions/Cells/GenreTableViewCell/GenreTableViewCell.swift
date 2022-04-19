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

  private let regularTextLabel = TVRegularLabel()

  public var viewModel: GenreViewModelProtocol?

  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  func setViewModel(_ viewModel: GenreViewModelProtocol) {
    self.viewModel = viewModel
    regularTextLabel.text = viewModel.name
  }

  private func setupUI() {
    backgroundColor = .secondarySystemBackground
    constructHierarchy()
    activateConstraints()
  }

  private func constructHierarchy() {
    contentView.addSubview(regularTextLabel)
  }

  private func activateConstraints() {
    activateConstraintsForLabel()
  }

  private func activateConstraintsForLabel() {
    regularTextLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      regularTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      regularTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 5),
      regularTextLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ])
  }
}
