//
//  Created by Jeans Ruiz on 11/05/22.
//

import Shared

// it will throws ErrorEnvelope
public protocol SearchLocalDataSource {
  func saveSearch(query: String, userId: Int) async throws
  func fetchRecentSearches(userId: Int) async throws -> [SearchDLO]
}
