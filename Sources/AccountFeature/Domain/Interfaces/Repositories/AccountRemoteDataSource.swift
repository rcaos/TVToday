//
//  Created by Jeans Ruiz on 7/05/22.
//

public protocol AccountRemoteDataSource {
  func getAccountDetails(session: String) async throws ->  AccountDTO
}
