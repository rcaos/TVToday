//
//  NetworkServiceTests.swift
//  Networking
//
//  Created by Jeans Ruiz on 19/03/22.
//

import XCTest
import Combine
@testable import NetworkingInterface
@testable import Networking

class NetworkServiceTests: XCTestCase {

  private struct EndpointMock: Requestable {
    var path: String
    var isFullPath: Bool = false
    var method: HTTPMethodType
    var headerParameters: [String: String] = [:]
    var queryParametersEncodable: Encodable?
    var queryParameters: [String: Any] = [:]
    var bodyParametersEncodable: Encodable?
    var bodyParameters: [String: Any] = [:]
    var bodyEncoding: BodyEncoding = .stringEncodingAscii

    init(path: String, method: HTTPMethodType) {
      self.path = path
      self.method = method
    }
  }

  class NetworkErrorLoggerMock: NetworkErrorLogger {
    var loggedErrors: [Error] = []
    func log(request: URLRequest) { }
    func log(responseData data: Data?, response: URLResponse?) { }
    func log(error: Error) { loggedErrors.append(error) }
    func log(responseData data: Data, response: URLResponse) { }
  }

  private enum NetworkErrorMock: Error {
    case someError
  }

  var cancellabes = Set<AnyCancellable>()
  override func setUp() {
    cancellabes = Set<AnyCancellable>()
  }

  func test_whenMockDataPassed_shouldReturnProperResponse() {
    // given
    let config = NetworkConfigurableMock()
    let expectation = self.expectation(description: "Should return correct data")

    let expectedResponseData = "Response data".data(using: .utf8)!
    let sut = DefaultNetworkService(config: config,
                                    sessionManager: NetworkSessionManagerMock(response: HTTPURLResponse(),
                                                                              data: expectedResponseData,
                                                                              error: nil))
    // when
    let endPoint = EndpointMock(path: "http://mock.test.com", method: .get)
    sut.request(endpoint: endPoint)
      .sink(receiveCompletion: { completion in
        guard case .finished = completion else {
          XCTFail("Expected load to complete successfully")
          return
        }
      }, receiveValue: { responseData in
        XCTAssertEqual(responseData, expectedResponseData)
        expectation.fulfill()
      })
      .store(in: &cancellabes)

    // then
    wait(for: [expectation], timeout: 0.1)
  }

  func test_whenErrorWithNSURLErrorCancelledReturned_shouldReturnCancelledError() {
    // given
    let config = NetworkConfigurableMock()
    let expectation = self.expectation(description: "Should return hasStatusCode error")

    let sessionMock = NetworkSessionManagerMock(response: nil,
                                                data: nil,
                                                error: URLError(.cancelled))
    let sut = DefaultNetworkService(config: config, sessionManager: sessionMock)

    // when
    let endPoint = EndpointMock(path: "http://mock.test.com", method: .get)
    sut.request(endpoint: endPoint)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .failure(let error) :
          guard case NetworkError.cancelled = error else {
            XCTFail("NetworkError.cancelled not found")
            return
          }
          print("rcaos=\(error.localizedDescription)")
          expectation.fulfill()
        default:
          XCTFail("Should not happen")
          return
        }
      }, receiveValue: { _ in
        XCTFail("Should not happen")
      })
      .store(in: &cancellabes)

    // then
    wait(for: [expectation], timeout: 0.1)
  }

  func test_whenMalformedUrlPassed_shouldReturnUrlGenerationError() {
    // given
    let config = NetworkConfigurableMock()
    let expectation = self.expectation(description: "Should return correct data")

    let expectedResponseData = "Response data".data(using: .utf8)!
    let sut = DefaultNetworkService(config: config, sessionManager: NetworkSessionManagerMock(response: HTTPURLResponse(),
                                                                                              data: expectedResponseData,
                                                                                              error: nil))
    // when
    let endpoint = EndpointMock(path: "-;@,?:ą", method: .get)
    sut.request(endpoint: endpoint)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .failure(let error):
          guard case NetworkError.urlGeneration = error  else {
            XCTFail("Bad error response")
            return
          }
          expectation.fulfill()
        default:
          XCTFail("Should not happen")
          return
        }

      }, receiveValue: { _ in
        XCTFail("Should not response data")
        return
      })
      .store(in: &cancellabes)

    // then
    wait(for: [expectation], timeout: 0.1)
  }

  func test_whenStatusCodeEqualOrAbove400_shouldReturnhasStatusCodeError() {
    // given
    let config = NetworkConfigurableMock()
    let expectation = self.expectation(description: "Should return hasStatusCode error")

    let response = HTTPURLResponse(url: URL(string: "test_url")!,
                                   statusCode: 500,
                                   httpVersion: "1.1",
                                   headerFields: [:])
    let sut = DefaultNetworkService(config: config, sessionManager: NetworkSessionManagerMock(response: response,
                                                                                              data: Data(),
                                                                                              error: nil))
    // when
    let endpoint = EndpointMock(path: "http://mock.test.com", method: .get)
    sut.request(endpoint: endpoint)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .failure(let error):
          if case NetworkError.error(let statusCode, _) = error {
            XCTAssertEqual(statusCode, 500)
            expectation.fulfill()
          }
        default:
          XCTFail("This should not happen")
        }
      }, receiveValue: { _ in
        XCTFail("This should not happen")
      })
      .store(in: &cancellabes)

    // then
    wait(for: [expectation], timeout: 0.1)
  }

  func test_whenErrorWithNSURLErrorNotConnectedToInternetReturned_shouldReturnNotConnectedError() {
    // given
    let config = NetworkConfigurableMock()
    let expectation = self.expectation(description: "Should return hasStatusCode error")

    let sessionMock = NetworkSessionManagerMock(response: nil,
                                                data: nil,
                                                error: URLError(.notConnectedToInternet))
    let sut = DefaultNetworkService(config: config, sessionManager: sessionMock )

    // when
    let endpoint = EndpointMock(path: "http://mock.test.com", method: .get)
    sut.request(endpoint: endpoint)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .failure(let error):
          guard case NetworkError.notConnected = error else {
            XCTFail("NetworkError.notConnected not found")
            return
          }
          expectation.fulfill()

        default:
          XCTFail("This should not happen")
          return
        }
      }, receiveValue: { _ in
        XCTFail("This should not happen")
        return
      })
      .store(in: &cancellabes)

    // then
    wait(for: [expectation], timeout: 0.1)
  }

  func test_whenhasStatusCodeUsedWithWrongError_shouldReturnFalse() {
    // when
    let sut = NetworkError.notConnected
    // then
    XCTAssertFalse(sut.hasStatusCode(200))
  }

  func test_whenhasStatusCodeUsed_shouldReturnCorrectStatusCode_() {
    // when
    let sut = NetworkError.error(statusCode: 400, data: Data())
    // then
    XCTAssertTrue(sut.hasStatusCode(400))
    XCTAssertFalse(sut.hasStatusCode(399))
    XCTAssertFalse(sut.hasStatusCode(401))
  }

  func test_whenErrorWithNSURLErrorNotConnectedToInternetReturned_shouldLogThisError() {
    // given
    let config = NetworkConfigurableMock()
    let expectation = self.expectation(description: "Should return hasStatusCode error")

    let networkErrorLogger = NetworkErrorLoggerMock()
    let sessionMock = NetworkSessionManagerMock(response: nil,
                                                data: nil,
                                                error: URLError(.notConnectedToInternet))
    let sut = DefaultNetworkService(config: config, sessionManager: sessionMock,
                                    logger: networkErrorLogger)
    // when
    sut.request(endpoint: EndpointMock(path: "http://mock.test.com", method: .get))
      .sink(receiveCompletion: { completion in
        switch completion {
        case .failure(let error):
          guard case NetworkError.notConnected = error else {
            XCTFail("NetworkError.notConnected not found")
            return
          }
          expectation.fulfill()
        default:
          XCTFail("This should not happen")
        }
      }, receiveValue: { _ in
        XCTFail("This should not happen")
        return
      })
      .store(in: &cancellabes)

    // then
    wait(for: [expectation], timeout: 0.1)
    XCTAssertTrue(networkErrorLogger.loggedErrors.contains {
      guard case NetworkError.notConnected = $0 else { return false }
      return true
    })
  }
}
