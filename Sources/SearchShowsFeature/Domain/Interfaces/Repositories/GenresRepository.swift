//
//  Created by Jeans Ruiz on 1/16/20.
//

import NetworkingInterface

protocol GenresRepository {
  func genresList() async throws -> GenreList
}
