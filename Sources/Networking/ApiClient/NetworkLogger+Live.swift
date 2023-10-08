//
//  Created by Jeans Ruiz on 13/08/23.
//

import Foundation

extension NetworkLogger {
  public static var live: NetworkLogger {
    return NetworkLogger(
      logRequest: { request in
        print("-------------")
        print("request: \(request.url!)")
        print("headers: \(request.allHTTPHeaderFields!)")
        print("method: \(request.httpMethod!)")
        if let httpBody = request.httpBody, let result = ((try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]) as [String: AnyObject]??) {
          printIfDebug("body: \(String(describing: result))")
        } else if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
          printIfDebug("body: \(String(describing: resultString))")
        }
      },
      logResponse: { data, _ in
        if let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
          printIfDebug("responseData: \(String(describing: dataDict))")
        }
      },
      logError: { error in
        printIfDebug("\(error)")
      }
    )
  }
}

func printIfDebug(_ string: String) {
#if DEBUG
  print(string)
#endif
}
