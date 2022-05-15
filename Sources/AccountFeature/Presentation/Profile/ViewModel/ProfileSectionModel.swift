//
//  ProfileSectionModel.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/22/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

enum ProfileSectionModel: Equatable {
  case userInfo(items: [ProfilesSectionItem])
  case userLists(items: [ProfilesSectionItem])
  case logout(items: [ProfilesSectionItem])

  var sectionView: ProfileSectionView {
    switch self {
    case .userInfo:
      return .userInfo
    case .userLists:
      return .userLists
    case .logout:
      return .logout
    }
  }

  var items: [ProfilesSectionItem] {
    switch self {
    case let .userInfo(items):
      return items
    case let .userLists(items):
      return items
    case let .logout(items):
      return items
    }
  }
}

enum ProfileSectionView: Hashable {
  case userInfo
  case userLists
  case logout
}

enum ProfilesSectionItem: Hashable {
  case userInfo(number: Account)
  case userLists(items: UserListType)
  case logout(items: String)
}

enum UserListType: String, Hashable {
  case favorites = "Favorites"
  case watchList = "Watch List"
}
