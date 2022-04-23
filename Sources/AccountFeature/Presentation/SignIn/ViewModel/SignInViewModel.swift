//
//  SignInViewModel.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import Combine
import CombineSchedulers
import Shared
import NetworkingInterface

class SignInViewModel: SignInViewModelProtocol {
  private let createTokenUseCase: CreateTokenUseCase
  private let tapButton = PassthroughSubject<Void, Never>()

  let viewState: CurrentValueSubject<SignInViewState, Never> = .init(.initial)
  weak var delegate: SignInViewModelDelegate?

  private let scheduler: AnySchedulerOf<DispatchQueue>
  private var disposeBag = Set<AnyCancellable>()

  // MARK: - Initializers
  init(createTokenUseCase: CreateTokenUseCase, scheduler: AnySchedulerOf<DispatchQueue> = .main) {
    self.createTokenUseCase = createTokenUseCase
    self.scheduler = scheduler
    subscribe()
  }

  // MARK: - Public
  func signInDidTapped() {
    tapButton.send(())
  }

  public func changeState(with state: SignInViewState) {
    viewState.send(state)
  }

  // MARK: - Private
  private func subscribe() {
    // MARK: - TODO, test handle several taps
    tapButton
      .flatMap { [viewState, createTokenUseCase] () -> AnyPublisher<URL, DataTransferError> in
        viewState.send(.loading)
        return createTokenUseCase.execute()
      }
      .receive(on: scheduler)
      .sink(receiveCompletion: { [weak self] completion in
        switch completion {
        case let .failure(error):
          print("error to request token: \(error)")
          self?.viewState.send(.loading)
        case .finished:
          break
        }
      },
            receiveValue: { [weak self] url in
        guard let strongSelf = self else { return }
        strongSelf.delegate?.signInViewModel(strongSelf, didTapSignInButton: url)
      })
      .store(in: &disposeBag)
  }
}
