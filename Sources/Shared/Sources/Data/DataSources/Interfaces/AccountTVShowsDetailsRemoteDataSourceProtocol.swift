//
//  Created by Jeans Ruiz on 13/05/22.
//

import Combine
import NetworkingInterface

public protocol AccountTVShowsDetailsRemoteDataSourceProtocol {
  func markAsFavorite(tvShowId: Int, userId: String,session: String,  favorite: Bool) async throws->  TVShowActionStatusDTO

  func saveToWatchList(tvShowId: Int, userId: String, session: String, watchedList: Bool) async throws -> TVShowActionStatusDTO
  
  func fetchTVShowStatus(tvShowId: Int, sessionId: String) async throws -> TVShowAccountStatusDTO
}
