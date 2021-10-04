//
//  GenreViewModel+Mock.swift
//  SearchShows-Unit-Tests
//
//  Created by Jeans Ruiz on 8/7/20.
//

@testable import SearchShows

final class GenreViewModelMock: GenreViewModelProtocol {
  let id: Int
  let name: String

  init(id: Int, name: String) {
    self.id = id
    self.name = name
  }
}
