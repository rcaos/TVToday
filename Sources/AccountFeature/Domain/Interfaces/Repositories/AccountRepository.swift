//
//  Created by Jeans Ruiz on 6/21/20.
//

import Foundation

public protocol AccountRepository {
  func getAccountDetails() async -> Account?
}
