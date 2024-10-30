//
//  Created by Jeans Ruiz on 6/05/22.
//

public protocol GenreRemoteDataSource {
  func fetchGenres() async throws -> GenreListDTO
}
