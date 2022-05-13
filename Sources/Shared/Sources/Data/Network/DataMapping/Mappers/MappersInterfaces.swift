//
//  MappersInterfaces.swift
//  
//
//  Created by Jeans Ruiz on 13/05/22.
//

import Foundation

public protocol TVShowPageMapperProtocol {
  func mapTVShowPage(_ page: TVShowPageDTO, imageBasePath: String, imageSize: ImageSize) -> TVShowPage
}

public protocol TVShowDetailsMapperProtocol {
  func mapTVShow(_ show: TVShowDetailDTO, imageBasePath: String, imageSize: ImageSize) -> TVShowDetail
}

public protocol AccountTVShowsDetailsMapperProtocol {
  func mapActionResult(result: TVShowActionStatusDTO) -> TVShowActionStatus
  func mapTVShowStatusResult(result: TVShowAccountStatusDTO) -> TVShowAccountStatus
}

public enum ImageSize: String {
  case small = "w342"
  case medium = "w780"
}
