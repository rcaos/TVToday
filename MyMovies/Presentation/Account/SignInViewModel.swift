//
//  SignInViewModel.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import RxSwift
import RxFlow
import RxRelay

class SignInViewModel {
  
  var steps = PublishRelay<Step>()
  
  var input: Input
  
  var output: Output
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializers
  
  init() {
    input = Input()
    output = Output()
    
    subscribe()
  }
  
  private func subscribe() {
    input.tapButton.asObserver()
      .subscribe(onNext: {
        print("Tap en Button Login")
      })
    .disposed(by: disposeBag)
  }
  
}

extension SignInViewModel: BaseViewModel {
  
  public struct Input {
    let tapButton = PublishSubject<Void>()
  }
  
  public struct Output { }
}
