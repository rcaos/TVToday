//
//  AuthRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

protocol AuthRepository {
  
  func requestToken() -> Observable<CreateTokenResult>
  
  func createSession(requestToken: String) -> Observable<CreateSessionResult>
}
