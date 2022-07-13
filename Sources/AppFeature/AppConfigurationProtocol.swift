//
//  File.swift
//  
//
//  Created by Jeans Ruiz on 19/04/22.
//

import Foundation

public protocol AppConfigurationProtocol {
  var apiKey: String { get set }
  var apiBaseURL: URL { get set }
  var imagesBaseURL: String { get set }
  var authenticateBaseURL: String { get set }
}
