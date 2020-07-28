//
//  ProfileViewModel.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift
import RxDataSources

protocol ProfileViewModelDelegate: class {
  
  func profileViewModel(didTapLogoutButton tapped: Bool)
  
  func profileViewModel(didUserList tapped: UserListType)
}

class ProfileViewModel {
  
  weak var delegate: ProfileViewModelDelegate?
  
  private var sectionsSubject = BehaviorSubject<[ProfileSectionModel]>(value: [])
  
  private var presentSignOutAlertSubject = PublishSubject<Bool>()
  
  var input: Input
  
  var output: Output
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializers
  
  init() {
    input = Input()
    output = Output(sections: sectionsSubject.asObservable(),
                    presentSignOutAlert: presentSignOutAlertSubject.asObservable())
    
    subscribe()
  }
  
  // MARK: - Public
  
  func createSectionModel(account: AccountResult) {
    
    let items: [ProfilesSectionItem] = [
      .userLists(items: .favorites),
      .userLists(items: .watchList)]
    
    let sectionProfile: [ProfileSectionModel] = [
      .userInfo(header: "", items: [.userInfo(number: account)]),
      .userLists(header: "", items: items),
      .logout(header: "", items: [.logout(items: "Log Out")])
    ]
    
    sectionsSubject.onNext(sectionProfile)
  }
  
  fileprivate func subscribe() {
    input.tapLogoutAction.asObserver()
      .subscribe(onNext: { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.delegate?.profileViewModel(didTapLogoutButton: true)
      })
      .disposed(by: disposeBag)
    
    input.tapCellAction.asObserver()
      .subscribe(onNext: { [weak self] model in
        self?.didSelectedCell(model)
      })
      .disposed(by: disposeBag)
  }
  
  fileprivate func didSelectedCell(_ model: ProfilesSectionItem) {
    switch model {
    case .userLists(items: let cellType):
      delegate?.profileViewModel(didUserList: cellType)
    case .logout:
      presentSignOutAlertSubject.onNext(true)
    default:
      break
    }
  }
}

extension ProfileViewModel {
  
  public struct Input {
    let tapLogoutAction = PublishSubject<Void>()
    let tapCellAction = PublishSubject<ProfilesSectionItem>()
  }
  
  public struct Output {
    let sections: Observable<[ProfileSectionModel]>
    let presentSignOutAlert: Observable<Bool>
  }
}
