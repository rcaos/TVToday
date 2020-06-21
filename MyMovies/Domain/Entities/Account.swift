//
//  Account.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

struct Account {
  
  let avatar: Avatar?
  
  let userName: String?
}

struct Avatar {
  
  let gravatar: Gravatar?
}

struct Gravatar {
  
  let hash: String?
  
}
