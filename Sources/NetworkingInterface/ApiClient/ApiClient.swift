//
//  Created by Jeans Ruiz on 11/08/23.
//

import Foundation

public struct ApiClient {
  public var apiRequest: (URLRequestable) async throws -> (Data, URLResponse)
  public var logError: (Error) -> Void

  public init(
    apiRequest: @escaping (URLRequestable) async throws -> (Data, URLResponse),
    logError: @escaping (Error) -> Void
  ) {
    self.apiRequest = apiRequest
    self.logError = logError
  }

  public func apiRequest(
    endpoint: URLRequestable,
    file: StaticString = #file,
    line: UInt = #line
  ) async throws -> (Data, URLResponse) {
    do {
      let (data, response) = try await apiRequest(endpoint)
      return (data, response)
    } catch {
      throw ApiError(error: error, file: file, line: line)
    }
  }

  public func apiRequest<A: Decodable>(
    endpoint: URLRequestable,
    as: A.Type,
    file: StaticString = #file,
    line: UInt = #line
  ) async throws -> A {
    let (data, _) = try await apiRequest(endpoint: endpoint, file: file, line: line)

    do {
      return try endpoint.responseDecoder.decode(A.self, from: data)
    } catch {
      logError(error)
      throw ApiError(error: error, file: file, line: line)
    }
  }
}
