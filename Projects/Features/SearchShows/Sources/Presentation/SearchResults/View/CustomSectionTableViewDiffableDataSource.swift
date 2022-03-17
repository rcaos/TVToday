//
//  CustomSectionTableViewDiffableDataSource.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 17/03/22.
//

import UIKit

class CustomSectionTableViewDiffableDataSource: UITableViewDiffableDataSource<ResultSearchSectionView, ResultSearchSectionItem> {

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let index = IndexPath(row: 0, section: section)

    if let model = itemIdentifier(for: index), let section = snapshot().sectionIdentifier(containingItem: model) {
        return section.header
    }
    return nil
  }
}
