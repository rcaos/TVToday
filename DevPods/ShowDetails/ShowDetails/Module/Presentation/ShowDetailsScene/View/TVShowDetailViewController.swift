//
//  TVShowDetailViewController.swift
//  ShowDetails
//
//  Created by Jeans Ruiz on 8/4/20.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Shared
import UI

class TVShowDetailViewController: UIViewController, StoryboardInstantiable, Loadable, Retryable, Emptiable {
  
  var viewModel: TVShowDetailViewModelProtocol!
  
  @IBOutlet weak private var backDropImage: UIImageView!
  @IBOutlet weak private var nameLabel: TVBoldLabel!
  @IBOutlet weak private var yearsRelease: TVRegularLabel!
  @IBOutlet weak private var durationLabel: TVRegularLabel!
  @IBOutlet weak private var genreLabel: TVRegularLabel!
  @IBOutlet weak private var episodesView: UIView!
  @IBOutlet weak private var episodeGuide: TVRegularLabel!
  @IBOutlet weak private var numberOfEpisodes: TVRegularLabel!
  @IBOutlet weak private var posterImage: UIImageView!
  @IBOutlet weak private var overViewText: UITextView!
  @IBOutlet weak private var starImageView: UIImageView!
  @IBOutlet weak private var scoreLabel: TVBoldLabel!
  @IBOutlet weak private var maxScoreLabel: TVRegularLabel!
  @IBOutlet weak private var countVoteLabel: TVRegularLabel!
  @IBOutlet weak private var criticReviews: TVRegularLabel!
  
  static func create(with viewModel: TVShowDetailViewModelProtocol) -> TVShowDetailViewController {
    let controller = TVShowDetailViewController.instantiateViewController()
    controller.viewModel = viewModel
    return controller
  }
  
  let disposeBag = DisposeBag()
  
  lazy var favoriteButton: UIBarButtonItem = {
    let barButtonItem = UIBarButtonItem(image: UIImage(name: "favorite"),
                                        style: .plain, target: nil, action: nil)
    barButtonItem.tintColor = .gray
    return barButtonItem
  }()
  
  lazy var watchListButton: UIBarButtonItem = {
    let bookmarkButton = UIBarButtonItem(image: UIImage(name: "bookmark"),
                                         style: .plain, target: nil, action: nil)
    bookmarkButton.tintColor = .gray
    return bookmarkButton
  }()
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.navigationBar.prefersLargeTitles = false
    setupUIAttributes()
    setupGestures()
    setupNavigationBar()
    setupViewModel()
    viewModel.viewDidLoad()
  }
  
  deinit {
    viewModel.viewDidFinish()
    print("deinit \(Self.self)")
  }
  
  private func setupNavigationBar() {
    if viewModel.isUserLogged() {
      navigationItem.rightBarButtonItems = [favoriteButton, watchListButton]
    } else {
      navigationItem.rightBarButtonItems = []
    }
  }
  
  private func setupUIAttributes() {
    nameLabel.tvSize = .custom(24)
    scoreLabel.tvSize = .custom(20)
    maxScoreLabel.tvSize = .custom(22)
    overViewText.textColor = Colors.electricBlue.color
    overViewText.font = Font.sanFrancisco.of(type: .regular, with: .normal)
    starImageView.image = UIImage(name: "star")
  }
  
  private func setupGestures() {
    episodesView.isUserInteractionEnabled = true
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleEpisodesGesture))
    episodesView.addGestureRecognizer(tapGesture)
  }
  
  @objc func handleEpisodesGesture(_ sender: UITapGestureRecognizer) {
    viewModel.navigateToSeasons()
  }
  
  private func setupViewModel() {
    setupBindables()
  }
  
  private func setupBindables() {
    if viewModel.isUserLogged() {
      setupBindablesForUserLogged()
    }
    
    viewModel?.viewState
      .subscribe(onNext: { [weak self] state in
        guard let strongSelf = self else { return }
        strongSelf.configView(with: state)
      })
      .disposed(by: disposeBag)
  }
  
  private func setupBindablesForUserLogged() {
    favoriteButton.rx
      .tap
      .bind(to: viewModel.tapFavoriteButton)
      .disposed(by: disposeBag)
    
    watchListButton.rx
      .tap
      .bind(to: viewModel.tapWatchedButton)
      .disposed(by: disposeBag)
    
    viewModel
      .isFavorite
      .subscribe(onNext: { [weak self] isFavorite in
        self?.favoriteButton.tintColor = isFavorite ? .red : .gray
      })
      .disposed(by: disposeBag)
    
    viewModel
      .isWatchList
      .subscribe(onNext: { [weak self] isWatchList in
        self?.watchListButton.tintColor = isWatchList ? Colors.customGreen.color : .gray
      })
      .disposed(by: disposeBag)
  }
  
  private func configView(with state: TVShowDetailViewModel.ViewState) {
    switch state {
    case .loading:
      showLoadingView()
      hideMessageView()
      
    case .populated(let tvShowDetail):
      hideLoadingView()
      hideMessageView()
      
      setupUI(with: tvShowDetail)
      
    case .error(let message):
      hideLoadingView()
      showMessageView(with: message,
                      errorHandler: { [weak self] in
                        self?.viewModel.refreshView()
      })
    }
  }
  
  private func setupUI(with show: TVShowDetailInfo) {
    nameLabel.text = show.nameShow
    yearsRelease.text = show.yearsRelease
    
    durationLabel.text = show.duration
    genreLabel.text = show.genre
    
    numberOfEpisodes.text = show.numberOfEpisodes
    overViewText.text = show.overView
    scoreLabel.text = show.score
    countVoteLabel.text = show.countVote
    maxScoreLabel.text = show.maxScore
    
    backDropImage.setImage(with: show.backDropPath)
    posterImage.setImage(with: show.posterPath)
  }
}
