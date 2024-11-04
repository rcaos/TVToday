//
//  Created by Jeans Ruiz on 7/2/20.
//

import Combine
import Shared

// todo, throws ErrorEnvelope
public protocol SearchLocalRepositoryProtocol {
  func saveSearch(query: String) async throws
  func fetchRecentSearches() async throws -> [Search]
}
