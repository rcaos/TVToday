//
//  SearchViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import RxSwift
import RxFlow
import RxRelay

final class SearchViewModel {
  
  var steps = PublishRelay<Step>()
  
  private let fetchGenresUseCase: FetchGenresUseCase
  
  private let fetchTVShowsUseCase: FetchTVShowsUseCase
  
  private let viewStateObservableSubject = BehaviorSubject<SimpleViewState<Genre>>(value: .loading)
  
  private let disposeBag = DisposeBag()
  
  var input: Input
  var output: Output
  
  // MARK: - Initializer
  
  init(fetchGenresUseCase: FetchGenresUseCase, fetchTVShowsUseCase: FetchTVShowsUseCase) {
    self.fetchGenresUseCase = fetchGenresUseCase
    self.fetchTVShowsUseCase = fetchTVShowsUseCase
    
    self.input = Input()
    self.output = Output(viewState: viewStateObservableSubject.asObservable())
  }
  
  func getGenres() {
    fetchGenresUseCase.execute(requestValue: FetchGenresUseCaseRequestValue())
      .subscribe(onNext: { [weak self] result in
        guard let strongSelf = self else { return }
        strongSelf.processFetched(for: result)
        }, onError: { [weak self] error in
          guard let strongSelf = self else { return }
          print("Error to fetch Case use \(error)")
          strongSelf.viewStateObservableSubject.onNext( .error(error.localizedDescription) )
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - Private
  
  private func processFetched(for response: GenreListResult) {
    let fetchedGenres = response.genres ?? []
    
    if fetchedGenres.isEmpty {
      viewStateObservableSubject.onNext(.empty)
      return
    }
    viewStateObservableSubject.onNext( .populated(fetchedGenres) )
  }
  
  // MARK: - Build Models
  
  public func buildResultsSearchViewModel() -> ResultsSearchViewModel {
    return ResultsSearchViewModel(fetchTVShowsUseCase: fetchTVShowsUseCase)
  }
}

// MARK: - BaseViewModel

extension SearchViewModel: BaseViewModel {
  
  public struct Input { }
  
  public struct Output {
    let viewState: Observable<SimpleViewState<Genre>>
  }
}

// MARK: - Stepper

extension SearchViewModel {
  
  public func navigateTo(step: Step) {
    steps.accept(step)
  }
}
