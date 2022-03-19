//
//  DefaultNetworkErrorLogger.swift
//  Networking
//
//  Created by Jeans Ruiz on 19/03/22.
//

import Foundation
import NetworkingInterface

public final class DefaultNetworkErrorLogger: NetworkErrorLogger {

  public init() { }

  public func log(request: URLRequest) {
    print("-------------")
    print("request: \(request.url!)")
    print("headers: \(request.allHTTPHeaderFields!)")
    print("method: \(request.httpMethod!)")
    if let httpBody = request.httpBody,
       let result = ((try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]) as [String: AnyObject]??) {
      printIfDebug("body: \(String(describing: result))")
    } else if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
      printIfDebug("body: \(String(describing: resultString))")
    }
  }

  public func log(responseData data: Data?, response: URLResponse?) {
    guard let data = data else { return }
    if let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
      printIfDebug("responseData: \(String(describing: dataDict))")
    }
  }

  public func log(responseData data: Data, response: URLResponse) {
    // MARK: - TODO
  }

  public func log(error: Error) {
    printIfDebug("\(error)")
  }
}
