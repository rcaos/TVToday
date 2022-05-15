//
//  RequestTokenRepositoryProtocol.swift
//  
//
//  Created by Jeans Ruiz on 12/05/22.
//

import Foundation

public protocol RequestTokenRepositoryProtocol {
  func saveRequestToken(_ token: String)
  func getRequestToken() -> String?
}
