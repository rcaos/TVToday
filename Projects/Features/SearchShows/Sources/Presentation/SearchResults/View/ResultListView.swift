//
//  ResultListView.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/17/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

class ResultListView: UIView {

  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.translatesAutoresizingMaskIntoConstraints = false

    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 150
    tableView.backgroundColor = .clear
    return tableView
  }()

  // MARK: - Life Cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupUI()
  }

  // MARK: - Private
  private func setupUI() {
    backgroundColor = .white
    setupTableView()
  }

  private func setupTableView() {
    tableView.keyboardDismissMode = .onDrag
    tableView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(tableView)

    NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: topAnchor),
                                 tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                 tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
                                 tableView.bottomAnchor.constraint(equalTo: bottomAnchor)])
  }
}
