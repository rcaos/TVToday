//
//  SearchViewController.swift
//  MyMovies
//
//  Created by Jeans on 8/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Shared

class SearchViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet weak var containerView: UIView!
  
  private var viewModel: SearchViewModel!
  private var searchController: UISearchController!
  private var searchOptionsViewController: UIViewController!
  
  private let disposeBag = DisposeBag()
  
  static func create(with viewModel: SearchViewModel,
                     searchController: UISearchController,
                     searchOptionsViewController: UIViewController) -> SearchViewController {
    let controller = SearchViewController.instantiateViewController(fromStoryBoard: "SearchViewController")
    controller.viewModel = viewModel
    controller.searchController = searchController
    controller.searchOptionsViewController = searchOptionsViewController
    return controller
  }
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  // MARK: - SetupView
  
  private func setupUI() {
    navigationController?.navigationBar.prefersLargeTitles = false
    navigationItem.title = "Search TV Shows"
    
    setupContainerView()
    setupSearchBar()
    bindSearchBarText()
  }
  
  private func setupContainerView() {
    add(asChildViewController: searchOptionsViewController,
        containerView: containerView)
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
    viewModel.output.searchBarText
      .bind(to: searchController.searchBar.rx.text)
      .disposed(by: disposeBag)
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
