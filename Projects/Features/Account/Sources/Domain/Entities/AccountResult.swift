//
//  AccountResult.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

public struct AccountResult: Equatable {
  let avatar: Avatar?
  let id: Int?
  let userName: String?
}

public struct Avatar: Equatable {
  let gravatar: Gravatar?
}

public struct Gravatar: Equatable {
  let hash: String?

}
