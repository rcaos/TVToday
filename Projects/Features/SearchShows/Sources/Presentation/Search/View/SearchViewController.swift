//
//  SearchViewController.swift
//  MyMovies
//
//  Created by Jeans on 8/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import Combine
import Shared

class SearchViewController: NiblessViewController {

  private let viewModel: SearchViewModel
  private let searchController: UISearchController
  private let searchControllerFactory: SearchViewControllerFactory
  private var disposeBag = Set<AnyCancellable>()

  init(viewModel: SearchViewModel,
       searchController: UISearchController,
       searchControllerFactory: SearchViewControllerFactory) {
    self.viewModel = viewModel
    self.searchController = searchController
    self.searchControllerFactory = searchControllerFactory
    super.init()
  }

  // MARK: - Life Cycle
  override func loadView() {
    view = UIView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  // MARK: - SetupView
  private func setupUI() {
    setupContainerView()
    setupSearchBar()
    bindSearchBarText()
  }

  private func setupContainerView() {
    let optionsViewController = searchControllerFactory.buildSearchOptionsController()
    add(asChildViewController: optionsViewController)
  }

  private func setupSearchBar() {
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.hidesNavigationBarDuringPresentation = false

    searchController.searchBar.placeholder = "Search TV Show"
    searchController.searchResultsUpdater = self
    searchController.searchBar.delegate = self

    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false

    definesPresentationContext = true
  }

  private func bindSearchBarText() {
    viewModel.searchBarTextSubject
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
        self?.searchController.searchBar.text = value
      })
      .store(in: &disposeBag)
  }
}

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {

  func updateSearchResults(for searchController: UISearchController) {
    searchController.searchResultsController?.view.isHidden = false
    if let isEmpty = searchController.searchBar.text?.isEmpty, isEmpty {
      viewModel.resetSearch()
    }
  }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if let query = searchBar.text {
      viewModel.startSearch(with: query)
    }
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    viewModel.resetSearch()
  }
}

// MARK: - SearchController Factory
protocol SearchViewControllerFactory {
  func buildSearchOptionsController() -> UIViewController
}
