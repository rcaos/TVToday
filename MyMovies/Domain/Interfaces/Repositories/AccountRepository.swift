//
//  AccountRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

protocol AccountRepository {
  
  // TODO, session should dont be here
  func getAccountDetails(session: String) -> Observable<Account>
}
