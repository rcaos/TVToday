//
//  AccessTokenLocalDataSource.swift
//  
//
//  Created by Jeans Ruiz on 12/05/22.
//

import Foundation

public protocol AccessTokenLocalDataSource {
  func saveAccessToken(_ token: String)
  func getAccessToken() -> String
}
