//
//  DataTransferServiceTests.swift
//  Networking
//
//  Created by Jeans Ruiz on 8/4/20.
//

import XCTest
import Combine
@testable import Networking
@testable import NetworkingInterface

private struct MockModel: Decodable {
  let name: String
}

class DataTransferServiceTests: XCTestCase {

  var cancellabes = Set<AnyCancellable>()
  override func setUp() {
    cancellabes = Set<AnyCancellable>()
  }

  func test_whenReceivedValidJsonInResponse_shouldDecodeResponseToDecodableObject() {
    // given
    let config = NetworkConfigurableMock()
    let expectation = self.expectation(description: "Should decode mock object")

    let responseData = #"{"name": "Hello"}"#.data(using: .utf8)
    let networkService = DefaultNetworkService(config: config, sessionManager: NetworkSessionManagerMock(response: HTTPURLResponse(),
                                                                                                         data: responseData,
                                                                                                         error: nil))

    let sut = DefaultDataTransferService(with: networkService)

    // when
    sut.request(with: Endpoint<MockModel>(path: "http://mock.endpoint.com", method: .get))
      .sink(receiveCompletion: { completion in
        guard case .finished = completion else {
          XCTFail("Should load to completed successfully")
          return
        }
      }, receiveValue: { responseModel in
        XCTAssertEqual(responseModel.name, "Hello")
        expectation.fulfill()
      })
      .store(in: &cancellabes)
    // then
    wait(for: [expectation], timeout: 5)
  }

  func test_whenInvalidResponse_shouldNotDecodeObject() {
    // given
    let config = NetworkConfigurableMock()
    let expectation = self.expectation(description: "Should not decode mock object")

    let responseData = #"{"age": 20}"#.data(using: .utf8)
    let response = HTTPURLResponse(url: URL(string: "test_url")!,
                                   statusCode: 300,
                                   httpVersion: "1.1",
                                   headerFields: [:])
    let networkService = DefaultNetworkService(config: config, sessionManager: NetworkSessionManagerMock(response: response,
                                                                                                         data: responseData,
                                                                                                         error: nil))

    let sut = DefaultDataTransferService(with: networkService)
    // when
    sut.request(with: Endpoint<MockModel>(path: "http://mock.endpoint.com", method: .get))
      .sink(receiveCompletion: { completion in
        switch completion {
        case .failure:
          expectation.fulfill()
        default:
          XCTFail("Should not happen")
        }
      }, receiveValue: { _ in
        XCTFail("Should not happen")
      })
      .store(in: &cancellabes)

    // then
    wait(for: [expectation], timeout: 0.1)
  }

  func test_whenBadRequestReceived_shouldRethrowNetworkError() {
    // given
    let config = NetworkConfigurableMock()
    let expectation = self.expectation(description: "Should throw network error")

    let responseData = #"{"invalidStructure": "Nothing"}"#.data(using: .utf8)!
    let response = HTTPURLResponse(url: URL(string: "test_url")!,
                                   statusCode: 500,
                                   httpVersion: "1.1",
                                   headerFields: nil)
    let networkService = DefaultNetworkService(config: config, sessionManager: NetworkSessionManagerMock(response: response,
                                                                                                         data: responseData,
                                                                                                         error: nil))

    let sut = DefaultDataTransferService(with: networkService)
    // when
    sut.request(with: Endpoint<MockModel>(path: "http://mock.endpoint.com", method: .get))
      .sink(receiveCompletion: { completion in
        switch completion {
        case .failure(let error):
          if case DataTransferError.networkFailure(NetworkError.error(statusCode: 500, data: _)) = error {
            expectation.fulfill()
          } else {
            XCTFail("Wrong error")
          }
        default:
          XCTFail("Should not happen")
        }
      }, receiveValue: { _ in
        XCTFail("Should not happen")
      })
      .store(in: &cancellabes)

    // then
    wait(for: [expectation], timeout: 0.1)
  }

  func test_whenDataCanNoBeParsed_shouldThrowDataParsingError() {
    // given
    let config = NetworkConfigurableMock()
    let expectation = self.expectation(description: "Should throw no data error")

    let responseData = #"{"invalidStructure": "Nothing"}"#.data(using: .utf8)!
    let response = HTTPURLResponse(url: URL(string: "test_url")!,
                                   statusCode: 200,
                                   httpVersion: "1.1",
                                   headerFields: [:])
    let networkService = DefaultNetworkService(config: config, sessionManager: NetworkSessionManagerMock(response: response,
                                                                                                         data: responseData,
                                                                                                         error: nil))

    let sut = DefaultDataTransferService(with: networkService)
    // when
    sut.request(with: Endpoint<MockModel>(path: "http://mock.endpoint.com", method: .get))
      .sink(receiveCompletion: { completion in
        switch completion {
        case .failure(let error):
          if case DataTransferError.parsing = error {
            expectation.fulfill()
            return
          }
          XCTFail("Wrong error")
        default:
          XCTFail("Should not happen")
        }
      }, receiveValue: { _ in
        XCTFail("Should not happen")
      })
      .store(in: &cancellabes)

    // then
    wait(for: [expectation], timeout: 0.1)
  }
}
