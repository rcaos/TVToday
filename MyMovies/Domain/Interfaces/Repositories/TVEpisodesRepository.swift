//
//  TVEpisodesRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/20/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

protocol TVEpisodesRepository {
  
  func fetchEpisodesList(for show: Int, season: Int) -> Observable<SeasonResult>
}
