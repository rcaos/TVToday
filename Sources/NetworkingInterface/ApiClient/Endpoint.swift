//
//  Created by Jeans Ruiz on 13/08/23.
//

import Foundation

public enum BodyEncoding {
  case jsonSerializationData
  case stringEncodingAscii
}

public enum HTTPMethodType: String {
  case get     = "GET"
  case head    = "HEAD"
  case post    = "POST"
  case put     = "PUT"
  case patch   = "PATCH"
  case delete  = "DELETE"
}

public enum RequestGenerationError: Error {
  case components
}

public struct Endpoint: URLRequestable {
  let path: String
  let isFullPath: Bool
  let method: HTTPMethodType
  let headerParamaters: [String: String]
  let queryParametersEncodable: Encodable?
  let queryParameters: [String: Any]
  let bodyParamatersEncodable: Encodable?
  let bodyParamaters: [String: Any]
  let bodyEncoding: BodyEncoding
  public let responseDecoder: ResponseDecoder

  public init(
    path: String,
    isFullPath: Bool = false,
    method: HTTPMethodType,
    headerParamaters: [String: String] = [:],
    queryParametersEncodable: Encodable? = nil,
    queryParameters: [String: Any] = [:],
    bodyParamatersEncodable: Encodable? = nil,
    bodyParamaters: [String: Any] = [:],
    bodyEncoding: BodyEncoding = .jsonSerializationData,
    responseDecoder: ResponseDecoder = JSONResponseDecoder()
  ) {
    self.path = path
    self.isFullPath = isFullPath
    self.method = method
    self.headerParamaters = headerParamaters
    self.queryParametersEncodable = queryParametersEncodable
    self.queryParameters = queryParameters
    self.bodyParamatersEncodable = bodyParamatersEncodable
    self.bodyParamaters = bodyParamaters
    self.bodyEncoding = bodyEncoding
    self.responseDecoder = responseDecoder
  }

  public func urlRequest(with networkConfig: NetworkConfig) throws -> URLRequest {
    return try buildURLRequest(endpoint: self, with: networkConfig)
  }

  // MARK: - Private
  private func buildURLRequest(endpoint: Endpoint, with config: NetworkConfig) throws -> URLRequest {
    let url = try url(endpoint: endpoint, with: config)
    var urlRequest = URLRequest(url: url)
    var allHeaders: [String: String] = config.headers
    endpoint.headerParamaters.forEach { allHeaders.updateValue($1, forKey: $0) }

    let bodyParamaters = try endpoint.bodyParamatersEncodable?.toDictionary() ?? endpoint.bodyParamaters
    if !bodyParamaters.isEmpty {
      urlRequest.httpBody = encodeBody(bodyParamaters: bodyParamaters, bodyEncoding: endpoint.bodyEncoding)
    }
    urlRequest.httpMethod = endpoint.method.rawValue
    urlRequest.allHTTPHeaderFields = allHeaders
    return urlRequest
  }

  private func url(endpoint: Endpoint, with config: NetworkConfig) throws -> URL {
    let baseURL = config.baseURL.absoluteString.last != "/" ? config.baseURL.absoluteString + "/" : config.baseURL.absoluteString

    let endpointRaw = endpoint.isFullPath ? endpoint.path : baseURL.appending(endpoint.path)

    guard var urlComponents = URLComponents(string: endpointRaw) else { throw RequestGenerationError.components }
    var urlQueryItems = [URLQueryItem]()

    let queryParameters = try endpoint.queryParametersEncodable?.toDictionary() ?? endpoint.queryParameters
    queryParameters.forEach {
      urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
    }
    config.queryParameters.forEach {
      urlQueryItems.append(URLQueryItem(name: $0.key, value: $0.value))
    }
    urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil

    guard let url = urlComponents.url else {
      throw RequestGenerationError.components
    }
    return url
  }

  private func encodeBody(bodyParamaters: [String: Any], bodyEncoding: BodyEncoding) -> Data? {
    switch bodyEncoding {
    case .jsonSerializationData:
      return try? JSONSerialization.data(withJSONObject: bodyParamaters)
    case .stringEncodingAscii:
      return bodyParamaters.queryString.data(using: String.Encoding.ascii, allowLossyConversion: true)
    }
  }
}

private extension Dictionary {
  var queryString: String {
    return self.map { "\($0.key)=\($0.value)" }
      .joined(separator: "&")
      .addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
  }
}

private extension Encodable {
  func toDictionary() throws -> [String: Any]? {
    let data = try JSONEncoder().encode(self)
    let josnData = try JSONSerialization.jsonObject(with: data)
    return josnData as? [String : Any]
  }
}
