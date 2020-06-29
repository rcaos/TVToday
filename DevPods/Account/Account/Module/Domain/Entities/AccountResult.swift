//
//  AccountResult.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

public struct AccountResult {
  
  let avatar: Avatar?
  
  let id: Int?
  
  let userName: String?
}

public struct Avatar {
  
  let gravatar: Gravatar?
}

public struct Gravatar {
  
  let hash: String?
  
}
