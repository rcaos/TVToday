//
//  SectionCustomData.swift
//  TVToday
//
//  Created by Jeans Ruiz on 3/26/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

struct SectionCustomData {
  var header: String
  var items: [Item]
}

extension SectionCustomData: SectionModelType {
  
  typealias Item = TVShow
  
  init(original: SectionCustomData, items: [Item]) {
    self = original
    self.items = items
  }
}
