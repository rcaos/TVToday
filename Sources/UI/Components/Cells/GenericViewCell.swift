//
//  GenreViewCell.swift
//  MyTvShows
//
//  Created by Jeans on 9/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

public class GenericViewCell: NiblessTableViewCell {

  private let regularTextLabel = UILabel(frame: .zero)

  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  public func setTitle(with title: String?) {
    regularTextLabel.text = title
  }

  private func setupUI() {
    backgroundColor = .secondarySystemBackground
    constructHierarchy()
    activateConstraints()
    configureViews()
  }

  private func configureViews() {
    accessoryType = .disclosureIndicator
  }

  private func constructHierarchy() {
    addSubview(regularTextLabel)
  }

  private func activateConstraints() {
    activateConstraintsForLabel()
  }

  private func activateConstraintsForLabel() {
    regularTextLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      regularTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      regularTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
      regularTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }

  deinit {
    print("deinit \(Self.self)")
  }
}
