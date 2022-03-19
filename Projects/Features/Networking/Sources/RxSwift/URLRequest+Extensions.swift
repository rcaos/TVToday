//
//  URLRequest+Extensions.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

extension URLRequest {
  mutating func setJSONContentType() {
    setValue("application/json; charset=utf-8",
             forHTTPHeaderField: "Content-Type")
  }
}
