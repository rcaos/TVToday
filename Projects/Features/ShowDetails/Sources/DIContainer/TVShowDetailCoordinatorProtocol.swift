//
//  TVShowDetailCoordinatorProtocol.swift
//  ShowDetails
//
//  Created by Jeans Ruiz on 8/12/20.
//

import UIKit
import Shared
import ShowDetailsInterface

protocol TVShowDetailCoordinatorDependencies {
  func buildShowDetailsViewController(with showId: Int,
                                      coordinator: TVShowDetailCoordinatorProtocol?,
                                      closures: TVShowDetailViewModelClosures?) -> UIViewController

  func buildEpisodesViewController(with showId: Int) -> UIViewController
}
