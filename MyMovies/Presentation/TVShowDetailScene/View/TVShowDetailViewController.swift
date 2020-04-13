//
//  TVShowDetailViewController.swift
//  MyMovies
//
//  Created by Jeans on 8/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class TVShowDetailViewController: UITableViewController, StoryboardInstantiable {
  
  var viewModel: TVShowDetailViewModel!
  
  @IBOutlet weak private var backDropImage: UIImageView!
  @IBOutlet weak private var nameLabel: UILabel!
  @IBOutlet weak private var yearsRelease: UILabel!
  @IBOutlet weak private var durationLabel: UILabel!
  @IBOutlet weak private var genreLabel: UILabel!
  @IBOutlet weak private var numberOfEpisodes: UILabel!
  @IBOutlet weak private var posterImage: UIImageView!
  @IBOutlet weak private var overViewLabel: UITextView!
  @IBOutlet weak private var scoreLabel: UILabel!
  @IBOutlet weak private var countVoteLabel: UILabel!
  
  private let loadingView = LoadingView(frame: .zero)
  private let messageView = MessageView(frame: .zero)
  
  private let disposeBag = DisposeBag()
  
  static func create(with viewModel: TVShowDetailViewModel) -> TVShowDetailViewController {
    let controller = TVShowDetailViewController.instantiateViewController()
    controller.viewModel = viewModel
    return controller
  }
  
  // MARK: - Life Cycle
  
  override func loadView() {
    super.loadView()
    loadingView.frame = view.frame
    messageView.frame = view.frame
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.prefersLargeTitles = false
    
    setupViewModel()
  }
  
  deinit {
    print("deinit TVShowDetailViewController")
  }
  
  private func setupViewModel() {
    setupBindables()
    viewModel?.getShowDetails()
  }
  
  private func setupBindables() {
    
    viewModel?.output.viewState
      .subscribe(onNext: { [weak self] state in
        guard let strongSelf = self else { return }
        strongSelf.configView(with: state)
      })
      .disposed(by: disposeBag)
  }
  
  func configView(with state: TVShowDetailViewModel.ViewState) {
    loadingView.removeFromSuperview()
    messageView.removeFromSuperview()
    
    switch state {
    case .populated(let tvShowDetail) :
      setupUI(with: tvShowDetail)
    case .loading :
      view.addSubview(loadingView)
    case .error(let message) :
      messageView.messageLabel.text = message
      view.addSubview(messageView)
    default:
      break
    }
  }
  
  private func setupUI(with show: TVShowDetailViewModel.TVShowDetailInfo) {
    nameLabel.text = show.nameShow
    yearsRelease.text = show.yearsRelease
    
    durationLabel.text = show.duration
    genreLabel.text = show.genre
    
    numberOfEpisodes.text = show.numberOfEpisodes
    overViewLabel.text = show.overView
    scoreLabel.text = show.score
    countVoteLabel.text = show.countVote
    
    backDropImage.setImage(with: show.backDropPath)
    posterImage.setImage(with: show.posterPath)
  }
}

extension TVShowDetailViewController {
  
  override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    return indexPath.row == 1
  }
  
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if indexPath.row == 1 {
      viewModel?.navigateToSeasons()
      return indexPath
    } else {
      return nil
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    let percentFirstRow = CGFloat(0.45)
    let fixedSecondRow = CGFloat(50.0)
    
    let totalHeight = view.safeAreaLayoutGuide.layoutFrame.height
    let restOfHeight = (totalHeight * (1-percentFirstRow) ) - fixedSecondRow
    
    var heightrow = CGFloat(0.0)
    
    if indexPath.row == 0 {
      heightrow =  totalHeight * ( percentFirstRow )
    } else if indexPath.row == 1 {
      heightrow = fixedSecondRow
    } else if indexPath.row == 2 {
      heightrow = restOfHeight * 0.65
    } else if indexPath.row == 3 {
      heightrow = restOfHeight * 0.35
    } else {
      heightrow = 0
    }
    return CGFloat(heightrow)
  }
}
