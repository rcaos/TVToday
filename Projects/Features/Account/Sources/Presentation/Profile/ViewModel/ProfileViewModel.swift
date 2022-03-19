//
//  ProfileViewModel.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

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
  init(account: AccountResult) {
    dataSource = sectionsSubject.asObservable()
    presentSignOutAlert = presentSignOutAlertSubject.asObservable()

    createSectionModel(account: account)
    subscribe()
  }

  // MARK: - Public
  func didTapLogoutButton() {
    tapLogoutAction.onNext(())
  }

  // MARK: - Private
  private func createSectionModel(account: AccountResult) {
    let items: [ProfilesSectionItem] = [
      .userLists(items: .favorites),
      .userLists(items: .watchList)
    ]

    let sectionProfile: [ProfileSectionModel] = [
      .userInfo(items: [.userInfo(number: account)]),
      .userLists(items: items),
      .logout(items: [.logout(items: "Log Out")])
    ]

    sectionsSubject.onNext(sectionProfile)
  }

  private func subscribe() {
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

  private func didSelectedCell(_ model: ProfilesSectionItem) {
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
