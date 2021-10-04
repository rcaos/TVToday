//
//  ProfileViewModelTests.swift
//  AccountTV-Unit-Tests
//
//  Created by Jeans Ruiz on 8/8/20.
//

import Quick
import Nimble
import RxSwift
import RxBlocking
import RxTest

@testable import Account
@testable import Shared

class ProfileViewModelTests: QuickSpec {

  override func spec() {
    describe("ProfileViewModel") {
      var scheduler: TestScheduler!
      var disposeBag: DisposeBag!

      beforeEach {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
      }

      context("When call createSectionModel with AccountResult") {
        it("Should ViewModel contanins Sections in DataSource") {
          // given
          let dataSourceObserver = scheduler.createObserver([ProfileSectionModel].self)

          let accountResult = AccountResult.stub(hash: "", id: 1, userName: "UserName")
          let viewModel: ProfileViewModelProtocol = ProfileViewModel(account: accountResult)

          // when
          viewModel.dataSource
            .bind(to: dataSourceObserver)
            .disposed(by: disposeBag)

          // then
          let sectionExpected = ProfileViewModelTests.createSectionModel(with: accountResult)
          let expected: [Recorded<Event<[ProfileSectionModel]>>] = [.next(0, sectionExpected)]

          expect(dataSourceObserver.events).toEventually(equal(expected))
        }
      }
    }
  }

  static func createSectionModel(with account: AccountResult) -> [ProfileSectionModel] {
    let items: [ProfilesSectionItem] = [
      .userLists(items: .favorites),
      .userLists(items: .watchList)]

    let sectionProfile: [ProfileSectionModel] = [
      .userInfo(header: "", items: [.userInfo(number: account)]),
      .userLists(header: "", items: items),
      .logout(header: "", items: [.logout(items: "Log Out")])
    ]
    return sectionProfile
  }
}
