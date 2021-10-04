//
//  GenresRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

protocol GenresRepository {
  func genresList() -> Observable<GenreListResult>
}
