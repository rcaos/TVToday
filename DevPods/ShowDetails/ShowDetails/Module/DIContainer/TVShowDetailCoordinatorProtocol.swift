//
//  TVShowDetailCoordinatorProtocol.swift
//  ShowDetails
//
//  Created by Jeans Ruiz on 8/12/20.
//

import Shared

public protocol TVShowDetailCoordinatorProtocol: class {
  
  func navigate(to step: ShowDetailsStep)
}

public protocol TVShowDetailCoordinatorDelegate: class {
  
  func tvShowDetailCoordinatorDidFinish()
}

// MARK: - Coordinator Dependencies

protocol TVShowDetailCoordinatorDependencies {
  
  func buildShowDetailsViewController(with showId: Int,
                                      coordinator: TVShowDetailCoordinatorProtocol?,
                                      closures: TVShowDetailViewModelClosures?) -> UIViewController
  
  func buildEpisodesViewController(with showId: Int) -> UIViewController
}

// MARK: - Steps

public enum ShowDetailsStep: Step {
  
  case
  
  showDetailsIsRequired(withId: Int, closures: TVShowDetailViewModelClosures? = nil),
  
  seasonsAreRequired(withId: Int),
  
  detailViewDidFinish
}
