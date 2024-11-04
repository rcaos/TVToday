//
//  Created by Jeans Ruiz on 13/05/22.
//

import Combine
import NetworkingInterface

public protocol TVShowsDetailsRemoteDataSourceProtocol {
  func fetchTVShowDetails(with showId: Int) async throws -> TVShowDetailDTO
}
