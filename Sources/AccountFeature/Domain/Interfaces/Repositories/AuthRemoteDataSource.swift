//
//  Created by Jeans Ruiz on 7/05/22.
//

protocol AuthRemoteDataSource {
  func requestToken() async throws -> NewRequestTokenDTO
  func createSession(requestToken: String) async throws -> NewSessionDTO
}
