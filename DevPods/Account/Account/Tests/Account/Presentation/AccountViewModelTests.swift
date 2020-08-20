//
//  AccountViewModelTests.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Quick
import Nimble
import RxSwift
import RxBlocking

@testable import AccountTV
@testable import Shared

class AccountViewModelTests: QuickSpec {
  
  override func spec() {
    describe("AccountViewModel") {
      
      var createSessionUseCaseMock: CreateSessionUseCaseMock!
      var fetchAccountDetailsUseCaseMock: FetchAccountDetailsUseCaseMock!
      var fetchLoggedUserMock: FetchLoggedUserMock!
      var deleteLoguedUserUseCaseMock: DeleteLoguedUserUseCaseMock!
      
      beforeEach {
        createSessionUseCaseMock = CreateSessionUseCaseMock()
        fetchAccountDetailsUseCaseMock = FetchAccountDetailsUseCaseMock()
        fetchLoggedUserMock = FetchLoggedUserMock()
        deleteLoguedUserUseCaseMock = DeleteLoguedUserUseCaseMock()
      }
      
      context("When FetcLoggedUser UseCase respond nil") {
        it("Should ViewModel contanins Login State") {
          // given
          fetchLoggedUserMock.account = nil
          
          let viewModel: AccountViewModelProtocol =
            AccountViewModel(createNewSession: createSessionUseCaseMock,
                             fetchAccountDetails: fetchAccountDetailsUseCaseMock,
                             fetchLoggedUser: fetchLoggedUserMock,
                             deleteLoguedUser: deleteLoguedUserUseCaseMock)
          
          // then
          let viewState = try? viewModel.viewState.toBlocking(timeout: 1).first()
          guard let currentViewState = viewState else {
            fail("It should emit a View State")
            return
          }
          let expected = AccountViewState.login
          
          expect(currentViewState).toEventually(equal(expected))
        }
      }
      
      context("When FetcLoggedUser UseCase respond With Account") {
        it("Should ViewModel contanins Profile State") {
          // given
          fetchLoggedUserMock.account = Account(id: 1, sessionId: "1")
          fetchAccountDetailsUseCaseMock.result = AccountResult.stub()
          
          let viewModel: AccountViewModelProtocol =
            AccountViewModel(createNewSession: createSessionUseCaseMock,
                             fetchAccountDetails: fetchAccountDetailsUseCaseMock,
                             fetchLoggedUser: fetchLoggedUserMock,
                             deleteLoguedUser: deleteLoguedUserUseCaseMock)
          
          // then
          let viewState = try? viewModel.viewState.toBlocking(timeout: 1).first()
          guard let currentViewState = viewState else {
            fail("It should emit a View State")
            return
          }
          let expected = AccountViewState.profile(account: AccountResult.stub())
          
          expect(currentViewState).toEventually(equal(expected))
        }
      }
      
      context("When UseCase Create Session returns Ok") {
        it("Should ViewModel should contains Profile View State") {
          // given
          let authPermission = AuthPermissionViewModelMock()
          
          createSessionUseCaseMock.result = ()
          fetchAccountDetailsUseCaseMock.result = AccountResult.stub()
          
          let viewModel: AccountViewModelProtocol =
            AccountViewModel(createNewSession: createSessionUseCaseMock,
                             fetchAccountDetails: fetchAccountDetailsUseCaseMock,
                             fetchLoggedUser: fetchLoggedUserMock,
                             deleteLoguedUser: deleteLoguedUserUseCaseMock)
          
          authPermission.delegate = viewModel
          
          // when
          authPermission.signIn()
          
          // then
          let viewState = try? viewModel.viewState.toBlocking(timeout: 1).first()
          guard let currentViewState = viewState else {
            fail("It should emit a View State")
            return
          }
          let expected = AccountViewState.profile(account: AccountResult.stub())
          
          expect(currentViewState).toEventually(equal(expected))
        }
      }
      
      context("When UseCase Create Session returns Error") {
        it("Should ViewModel should contains Login View State") {
          // given
          let authPermission = AuthPermissionViewModelMock()
          
          createSessionUseCaseMock.error = CustomError.genericError
          fetchAccountDetailsUseCaseMock.result = AccountResult.stub()
          
          let viewModel: AccountViewModelProtocol =
            AccountViewModel(createNewSession: createSessionUseCaseMock,
                             fetchAccountDetails: fetchAccountDetailsUseCaseMock,
                             fetchLoggedUser: fetchLoggedUserMock,
                             deleteLoguedUser: deleteLoguedUserUseCaseMock)
          
          authPermission.delegate = viewModel
          
          // when
          authPermission.signIn()
          
          // then
          let viewState = try? viewModel.viewState.toBlocking(timeout: 1).first()
          guard let currentViewState = viewState else {
            fail("It should emit a View State")
            return
          }
          let expected = AccountViewState.login
          
          expect(currentViewState).toEventually(equal(expected))
        }
      }
      
    }
  }
}
