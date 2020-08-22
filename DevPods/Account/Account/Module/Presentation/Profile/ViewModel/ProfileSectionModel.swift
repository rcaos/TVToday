//
//  ProfileSectionModel.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/22/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxDataSources

enum ProfileSectionModel: Equatable {
  case
  userInfo(header: String, items: [ProfilesSectionItem]),
  userLists(header: String, items: [ProfilesSectionItem]),
  logout(header: String, items: [ProfilesSectionItem])
}

extension ProfileSectionModel: SectionModelType {
  
  typealias Item = ProfilesSectionItem
  
  var items: [ProfilesSectionItem] {
    switch self {
    case .userInfo(_, items: let items):
      return items
    case .userLists(_, items: let items):
      return items
    case .logout(_, items: let items):
      return items
    }
  }
  
  init(original: Self, items: [Self.Item]) {
    switch original {
    case .userInfo(header: let header, items: _):
      self = .userInfo(header: header, items: items)
    case .userLists(header: let header, items: _):
      self = .userLists(header: header, items: items)
    case .logout(header: let header, items: _):
      self = .logout(header: header, items: items)
    }
  }
}

enum ProfilesSectionItem: Equatable {
  case
  userInfo(number: AccountResult),
  userLists(items: UserListType),
  logout(items: String)
}

enum UserListType: String {
  case favorites = "Favorites"
  case watchList = "Watch List"
}
