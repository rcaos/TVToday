//
//  Created by Jeans Ruiz on 6/19/20.
//

@testable import AccountFeature
import Combine
import CustomDump
import NetworkingInterface
import Shared
import XCTest

class AccountViewModelTests: XCTestCase {

  var sut: AccountViewModelProtocol!
  var createSessionUseCaseMock: CreateSessionUseCaseMock!
  var fetchAccountDetailsUseCaseMock: FetchAccountDetailsUseCaseMock!
  var fetchLoggedUserMock: FetchLoggedUserMock!
  var deleteLoggedUserUseCaseMock: DeleteLoguedUserUseCaseMock!
  private var disposeBag: Set<AnyCancellable>!

  override func setUp() {
    super.setUp()
    sut = nil
    createSessionUseCaseMock = CreateSessionUseCaseMock()
    fetchAccountDetailsUseCaseMock = FetchAccountDetailsUseCaseMock()
    fetchLoggedUserMock = FetchLoggedUserMock()
    deleteLoggedUserUseCaseMock = DeleteLoguedUserUseCaseMock()
    disposeBag = []
    sut = AccountViewModel(
      createNewSession: { self.createSessionUseCaseMock },
      fetchAccountDetails: { self.fetchAccountDetailsUseCaseMock },
      fetchLoggedUser: { self.fetchLoggedUserMock },
      deleteLoggedUser: { self.deleteLoggedUserUseCaseMock }
    )
  }

  func test_When_Session_DoesNot_Exits_Should_Be_Login_State() async {
    // given
    fetchLoggedUserMock.account = nil

    let expected = [AccountViewState.login]
    var received = [AccountViewState]()

    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    await sut.viewDidLoad()

    // then
    XCTAssertEqual(expected, received, "Should only receives one Value")
  }

  func test_When_Session_Exits_Should_Be_Profile_State() async {
    // given
    fetchLoggedUserMock.account = AccountDomain(id: 1, sessionId: "1")
    fetchAccountDetailsUseCaseMock.result = Account.stub()

    // when
    let expected = [
      AccountViewState.login,
      AccountViewState.profile(account: Account.stub())
    ]
    var received = [AccountViewState]()

    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    await sut.viewDidLoad()

    // then
    XCTAssertEqual(expected, received, "Should receives two values")
  }

  func test_when_CreateSession_Returns_OK_ViewModel_Should_contains_Profile_State() async {
    // given
    let authPermission = AuthPermissionViewModelMock()
    createSessionUseCaseMock.result = true
    fetchAccountDetailsUseCaseMock.result = Account.stub()

    authPermission.delegate = sut

    let expected = [
      AccountViewState.login,
      AccountViewState.profile(account: Account.stub())
    ]
    var received = [AccountViewState]()

    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    await sut.viewDidLoad()
    await authPermission.signIn()
    await Task.yield()

    // then
    expectNoDifference(expected, received, "Should receives two values")
  }

  func test_when_CreateSession_Returns_Error_ViewModel_Should_contains_Login_State() async {
    // given
    let authPermission = AuthPermissionViewModelMock()
    createSessionUseCaseMock.error = ApiError(error: NSError(domain: "", code: 0, userInfo: nil))
    fetchAccountDetailsUseCaseMock.result = Account.stub()

    authPermission.delegate = sut

    let expected = [AccountViewState.login]
    var received = [AccountViewState]()

    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    await sut.viewDidLoad()
    await authPermission.signIn()
    await Task.yield()

    // then
    XCTAssertEqual(expected, received, "Should receives two values")
  }
}
