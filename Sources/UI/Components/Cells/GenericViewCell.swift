//
//  GenreViewCell.swift
//  UI
//
//  Created by Jeans on 9/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

public class GenericViewCell: NiblessTableViewCell {

  private let label: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.adjustsFontForContentSizeCategory = true
    label.font = UIFont.app_title3()
    return label
  }()

  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  public func setTitle(with title: String?) {
    label.text = title
  }

  private func setupUI() {
    backgroundColor = .secondarySystemBackground
    constructHierarchy()
    activateConstraints()
    configureViews()
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

  private func configureViews() {
    accessoryType = .disclosureIndicator
  }
}
