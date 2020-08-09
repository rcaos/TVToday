//
//  ProfileViewModel.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift
import RxDataSources

class ProfileViewModel: ProfileViewModelProtocol {
  
  weak var delegate: ProfileViewModelDelegate?
  
  private let sectionsSubject = BehaviorSubject<[ProfileSectionModel]>(value: [])
  
  private let presentSignOutAlertSubject = PublishSubject<Bool>()
  
  private let tapLogoutAction = PublishSubject<Void>()
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Public Api
  
  let tapCellAction = PublishSubject<ProfilesSectionItem>()
  
  let dataSource: Observable<[ProfileSectionModel]>
  
  let presentSignOutAlert: Observable<Bool>
  
  // MARK: - Initializer
  
  init() {
    dataSource = sectionsSubject.asObservable()
    presentSignOutAlert = presentSignOutAlertSubject.asObservable()
    
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
  
  func didTapLogoutButton() {
    tapLogoutAction.onNext(())
  }
  
  fileprivate func subscribe() {
    tapLogoutAction.asObserver()
      .subscribe(onNext: { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.delegate?.profileViewModel(didTapLogoutButton: true)
      })
      .disposed(by: disposeBag)
    
    tapCellAction.asObserver()
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
