//
//  SectionAiringToday.swift
//  TVToday
//
//  Created by Jeans Ruiz on 3/26/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

struct SectionAiringToday {
  var header: String
  var items: [Item]
}

extension SectionAiringToday: SectionModelType {
  
  typealias Item = AiringTodayCollectionViewModel
  
  init(original: SectionAiringToday, items: [Item]) {
    self = original
    self.items = items
  }
}
