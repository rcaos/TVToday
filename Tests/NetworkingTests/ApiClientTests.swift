//
//  Created by Jeans Ruiz on 13/08/23.
//

import Foundation
import Networking
import NetworkingInterface
import XCTest

class ApiClientTests: XCTestCase {

  func test_whenMockDataPassed_shouldReturnProperResponse() async throws {
    let config = NetworkConfig(baseURL: URL(string: "http://mock.com")!)

    let data = String("mock").data(using: .utf8)!
    let urlResponse = URLResponse()

    let sut = ApiClient.live(
      networkConfig: config,
      urlSession: URLSessionManager(request: { _ in
        return (data, urlResponse)
      }),
      logger: NetworkLogger(logRequest: { _ in }, logResponse: { _,_ in }, logError: { _ in })
    )

    let (expectedData, _) = try await sut.apiRequest(endpoint: Endpoint(path: "", method: .get))

    XCTAssertEqual(data, expectedData)
  }

  func test_whenReceivedValidJsonInResponse_shouldDecodeResponseToDecodableObject() async throws {
    let config = NetworkConfig(baseURL: URL(string: "http://mock.com")!)

    let data = #"{"name": "Hello"}"#.data(using: .utf8)!
    let urlResponse = URLResponse()

    let sut = ApiClient.live(
      networkConfig: config,
      urlSession: URLSessionManager(request: { _ in
        return (data, urlResponse)
      }),
      logger: NetworkLogger(logRequest: { _ in }, logResponse: { _,_ in }, logError: { _ in })
    )

    let expectedModel = try await sut.apiRequest(
      endpoint: Endpoint(path: "", method: .get),
      as: MockModel.self
    )

    XCTAssertEqual(expectedModel.name, "Hello")
  }

  func test_whenBadRequestReceived_shouldRethrowNetworkError() async throws {
    let config = NetworkConfig(baseURL: URL(string: "http://mock.com")!)

    let sut = ApiClient.live(
      networkConfig: config,
      urlSession: URLSessionManager(request: { _ in
        throw URLError(.notConnectedToInternet)
      }),
      logger: NetworkLogger(logRequest: { _ in }, logResponse: { _,_ in }, logError: { _ in })
    )

    do {
      _ = try await sut.apiRequest(
        endpoint: Endpoint(path: "", method: .get),
        as: MockModel.self
      )
      XCTFail("Shoud trow an error")
    } catch {
      if let urlError = error as? ApiError {
        XCTAssertNotNil(urlError.rawError as? URLError)
        let urlError = try XCTUnwrap(urlError.rawError as? URLError)
        XCTAssertEqual(urlError, URLError(.notConnectedToInternet))
      } else {
        XCTFail("Should throws an ApiError")
      }
    }
  }

  func test_whenInvalidResponse_shouldNotDecodeObject() async throws {
    let config = NetworkConfig(baseURL: URL(string: "http://mock.com")!)

    let data = #"{"invalidJson": "Nothing_here"}"#.data(using: .utf8)!
    let urlResponse = URLResponse()

    let sut = ApiClient.live(
      networkConfig: config,
      urlSession: URLSessionManager(request: { _ in
        return (data, urlResponse)
      }),
      logger: NetworkLogger(logRequest: { _ in }, logResponse: { _,_ in }, logError: { _ in })
    )

    do {
      _ = try await sut.apiRequest(
        endpoint: Endpoint(path: "", method: .get),
        as: MockModel.self
      )
      XCTFail("Shoud throw an error")
    } catch {
      print(error)
    }
  }
}

private struct MockModel: Decodable {
  let name: String
}
