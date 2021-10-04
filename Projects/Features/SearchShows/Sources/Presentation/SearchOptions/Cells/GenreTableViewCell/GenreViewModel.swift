//
//  GenreViewModel.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 7/28/20.
//

import Shared

protocol GenreViewModelProtocol {
  var id: Int { get }
  var name: String { get }
}

final class GenreViewModel: GenreViewModelProtocol {
  let id: Int
  let name: String
  private let genre: Genre

  public init(genre: Genre) {
    self.genre = genre
    id = genre.id
    name = genre.name
  }
}
