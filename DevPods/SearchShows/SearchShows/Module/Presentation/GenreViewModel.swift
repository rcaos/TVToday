//
//  GenreViewModel.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 7/28/20.
//

import Shared

final class GenreViewModel {
  
  let id: Int
  
  let name: String
  
  private let genre: Genre
  
  public init(genre: Genre) {
    self.genre = genre
    
    id = genre.id
    name = genre.name
  }
}

extension GenreViewModel: Equatable {
  
  public static func == (lhs: GenreViewModel, rhs: GenreViewModel) -> Bool {
    return lhs.genre.id == rhs.genre.id
  }
}
