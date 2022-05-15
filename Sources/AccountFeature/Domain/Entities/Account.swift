//
//  Account.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

public struct Account: Hashable {
  let id: Int
  let userName: String
  let avatar: Avatar?
}

public struct Avatar: Hashable {
  let hashId: String?
}
