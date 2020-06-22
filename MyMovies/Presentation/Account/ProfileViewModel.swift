//
//  ProfileViewModel.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

protocol ProfileViewModelDelegate: class {
  
  func profileViewModel(_ profileViewModel: ProfileViewModel, didTapLogoutButton tapped: Bool)
}

class ProfileViewModel {
  
  weak var delegate: ProfileViewModelDelegate?
  
  var input: Input
  
  var output: Output
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializers
  
  init() {
    input = Input()
    output = Output()
    
    subscribe()
  }
  
  fileprivate func subscribe() {
    input.tapLogoutAction.asObserver()
      .subscribe(onNext: { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.delegate?.profileViewModel(strongSelf, didTapLogoutButton: true)
      })
      .disposed(by: disposeBag)
  }
  
}

extension ProfileViewModel {
  
  public struct Input {
    let tapLogoutAction = PublishSubject<Void>()
  }
  
  public struct Output { }
}
