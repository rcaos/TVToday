//
//  LogoutTableViewCell.swift
//  AccountFeature
//
//  Created by Jeans Ruiz on 6/22/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import UI

class LogoutTableViewCell: NiblessTableViewCell {

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  private func setupUI() {
    backgroundColor = .secondarySystemBackground
    textLabel?.text = "Sign out"
    textLabel?.textAlignment = .center
    textLabel?.textColor = .red
  }
}
