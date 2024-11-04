//
//  Created by Jeans Ruiz on 6/19/20.
//

import Foundation

protocol AuthRepository {
  func requestToken() async -> NewRequestToken?
  func createSession() async -> NewSession?
}
