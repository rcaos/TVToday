//
//  TVShowDetailRootView.swift
//  ShowDetails
//
//  Created by Jeans Ruiz on 8/21/20.
//

import UIKit
import Shared
import UI
import RxSwift

class TVShowDetailRootView: NiblessView {

  let viewModel: TVShowDetailViewModelProtocol

  let scrollView: UIScrollView = UIScrollView()

  lazy var mainStackView: UIStackView = {
    
    let firstSeparatorView = TVShowDetailRootView.buildSeparatorView()
    let secondSeparatorView = TVShowDetailRootView.buildSeparatorView()
    let thirdSeparatorView = TVShowDetailRootView.buildSeparatorView()
    let fourthSeparatorView = TVShowDetailRootView.buildSeparatorView()
    
    let stack = UIStackView(arrangedSubviews:
                              [backDropImageView,
                               titleContainerView,
                               firstSeparatorView,
                               guideContainerView,
                               secondSeparatorView,
                               overViewContainer,
                               //thirdSeparatorView,
                               //       votesViewContainer,
                               //       fourthSeparatorView
                              ])
    stack.axis = .vertical
    stack.alignment = .fill
    stack.distribution = .fill
    stack.spacing = 10.0
    return stack
  }()

  // MARK: - BackDrop Image
  private lazy var backDropImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  // MARK: - Title Stack
  lazy var titleContainerView: UIView = {
    let view = UIView()
    view.addSubview(titleStackView)
    titleStackView.translatesAutoresizingMaskIntoConstraints = false
    titleStackView.pin(to: view, insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0) )
    return view
  }()

  lazy var titleStackView: UIStackView = {
    let stack = UIStackView(arrangedSubviews:
      [nameLabel, releaseContainerView, genreLabel])
    stack.axis = .vertical
    stack.alignment = .fill
    stack.distribution = .fillProportionally
    stack.spacing = 8.0
    return stack
  }()

  private lazy var nameLabel: TVBoldLabel = {
    let label = TVBoldLabel()
    label.tvSize = .custom(24)
    label.setContentCompressionResistancePriority(.required, for: .vertical)
    return label
  }()

  private lazy var releaseContainerView: UIView = {
    let view = UIView()
    view.addSubview(yearsReleaseLabel)
    view.addSubview(durationLabel)

    yearsReleaseLabel.translatesAutoresizingMaskIntoConstraints = false
    let leading = yearsReleaseLabel.leadingAnchor
      .constraint(equalTo: view.leadingAnchor)
    let trailing = yearsReleaseLabel.trailingAnchor
      .constraint(equalTo: durationLabel.leadingAnchor, constant: -40)
    let top = yearsReleaseLabel.topAnchor
      .constraint(equalTo: view.topAnchor)
    let bottom = yearsReleaseLabel.bottomAnchor
      .constraint(equalTo: view.bottomAnchor)
    NSLayoutConstraint.activate(
      [leading, trailing, top, bottom])

    durationLabel.translatesAutoresizingMaskIntoConstraints = false
    let topDuration = durationLabel.topAnchor
      .constraint(equalTo: view.topAnchor)
    let bottomDuration = durationLabel.bottomAnchor
      .constraint(equalTo: view.bottomAnchor)
    NSLayoutConstraint.activate(
      [topDuration, bottomDuration])

    return view
  }()

  private lazy var yearsReleaseLabel: TVRegularLabel = {
    let label = TVRegularLabel()
    label.text = "1997 - 2002"
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.adjustsFontForContentSizeCategory = true
    label.setContentCompressionResistancePriority(.required, for: .vertical)
    return label
  }()

  private lazy var durationLabel: TVRegularLabel = {
    let label = TVRegularLabel()
    label.text = "23 min"
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.adjustsFontForContentSizeCategory = true
    label.setContentCompressionResistancePriority(.required, for: .vertical)
    return label
  }()

  private lazy var genreLabel: TVRegularLabel = {
    let label = TVRegularLabel()
    label.text = "Drama"
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.adjustsFontForContentSizeCategory = true
    label.setContentCompressionResistancePriority(.required, for: .vertical)
    return label
  }()

  // MARK: - Episode Guide
  private lazy var guideContainerView: UIView = {
    let view = UIView()
    view.addSubview(episodeLabel)
    view.addSubview(numberEpisodesLabel)

    episodeLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(
      [episodeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
       episodeLabel.topAnchor.constraint(equalTo: view.topAnchor),
       episodeLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ])

    numberEpisodesLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(
      [numberEpisodesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
       numberEpisodesLabel.topAnchor.constraint(equalTo: view.topAnchor),
       numberEpisodesLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ])

    return view
  }()

  private lazy var episodeLabel: TVRegularLabel = {
    let label = TVRegularLabel()
    label.text = "Episode Guide"
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.adjustsFontForContentSizeCategory = true
    label.setContentCompressionResistancePriority(.required, for: .vertical)
    return label
  }()

  private lazy var numberEpisodesLabel: TVRegularLabel = {
    let label = TVRegularLabel()
    label.text = "1123"
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.adjustsFontForContentSizeCategory = true
    label.setContentCompressionResistancePriority(.required, for: .vertical)
    return label
  }()

  // MARK: - Overview
  private lazy var overViewContainer: UIView = {
    let view = UIView()

    view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(posterImageView)
    view.addSubview(overViewText)

    posterImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      posterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
      posterImageView.trailingAnchor.constraint(equalTo: overViewText.leadingAnchor, constant: -10),
      posterImageView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 0),
      posterImageView.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: 0),
      posterImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
      posterImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])

    overViewText.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      overViewText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
      overViewText.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 0),
      overViewText.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: 0),
      overViewText.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])

    return view
  }()

  private lazy var posterImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  private lazy var overViewText: UITextView = {
    let overViewText = UITextView()
    overViewText.textAlignment = NSTextAlignment.justified
    overViewText.isSelectable = true
    overViewText.isEditable = false
    overViewText.textColor = Colors.electricBlue.color
    overViewText.font = Font.sanFrancisco.of(type: .regular, with: .custom(16))
    return overViewText
  }()

  // MARK: - Votes Container
  private lazy var votesViewContainer: UIView = {
    let view = UIView()
    view.addSubview(voteContainerStackView)
    view.addSubview(criticLabel)

    voteContainerStackView.translatesAutoresizingMaskIntoConstraints = false
    let leading = voteContainerStackView.leadingAnchor
      .constraint(equalTo: view.leadingAnchor, constant: 10)
    let withProportional = voteContainerStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4)

    let top = voteContainerStackView.topAnchor
      .constraint(equalTo: view.topAnchor)
    let bottom = voteContainerStackView.bottomAnchor
      .constraint(equalTo: view.bottomAnchor)
    NSLayoutConstraint.activate(
      [withProportional, leading, top, bottom])

    criticLabel.translatesAutoresizingMaskIntoConstraints = false
    let trailing2 = criticLabel.trailingAnchor
      .constraint(equalTo: view.trailingAnchor, constant: -10)
    let centerY = criticLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)

    NSLayoutConstraint.activate(
      [trailing2, centerY])

    return view
  }()

  private lazy var voteContainerStackView: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [starImageView, voteMaxStackView, countVoteLabel])
    stack.axis = .vertical
    stack.alignment = .center
    stack.distribution = .fill
    stack.spacing = 0
    return stack
  }()

  private lazy var starImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(name: "star") )
    imageView.contentMode = .scaleToFill
    imageView.setContentCompressionResistancePriority(.required, for: .vertical)
    return imageView
  }()

  private lazy var voteMaxStackView: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [scoreLabel, maxScoreLabel])
    stack.axis = .horizontal
    stack.alignment = .fill
    stack.distribution = .fill
    stack.spacing = 0
    return stack
  }()

  private lazy var scoreLabel: TVBoldLabel = {
    let label = TVBoldLabel()
    label.tvSize = .custom(20)
    label.text = "7.8/"
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.adjustsFontForContentSizeCategory = true
    label.setContentCompressionResistancePriority(.required, for: .vertical)
    return label
  }()

  private lazy var maxScoreLabel: TVRegularLabel = {
    let label = TVRegularLabel()
    label.tvSize = .custom(22)
    label.text = "10"
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.adjustsFontForContentSizeCategory = true
    label.setContentCompressionResistancePriority(.required, for: .vertical)
    return label
  }()

  private lazy var countVoteLabel: TVRegularLabel = {
    let label = TVRegularLabel()
    label.text = "3054"
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.adjustsFontForContentSizeCategory = true
    label.setContentCompressionResistancePriority(.required, for: .vertical)
    return label
  }()

  private lazy var criticLabel: TVRegularLabel = {
    let label = TVRegularLabel()
    label.text = "Critic Reviews"
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.adjustsFontForContentSizeCategory = true
    label.setContentCompressionResistancePriority(.required, for: .vertical)
    return label
  }()

  // MARK: - Initializer
  init(frame: CGRect = .zero, viewModel: TVShowDetailViewModelProtocol) {
    self.viewModel = viewModel
    super.init(frame: frame)

    setupUI()
  }

  // MARK: - Public
  func setupView(with show: TVShowDetailInfo) {
    nameLabel.text = show.nameShow
    yearsReleaseLabel.text = show.yearsRelease
    durationLabel.text = show.duration
    genreLabel.text = show.genre
    numberEpisodesLabel.text = show.numberOfEpisodes
    overViewText.text = show.overView
    scoreLabel.text = show.score
    countVoteLabel.text = show.countVote
    maxScoreLabel.text = show.maxScore

    backDropImageView.setImage(with: show.backDropPath)
    posterImageView.setImage(with: show.posterPath)
  }

  // MARK: - Private
  fileprivate func setupUI() {
    backgroundColor = .white
    constructHierarchy()
    activateConstraints()
    setupGestures()
  }

  fileprivate func constructHierarchy() {
    scrollView.addSubview(mainStackView)
    addSubview(scrollView)
  }

  fileprivate func activateConstraints() {
    activateConstraintsScrollView()
    activateConstraintsMainStackView()

    // MARk: TODO, move
    overViewContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4).isActive = true
    backDropImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25).isActive = true
  }

  func activateConstraintsScrollView() {
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    let leading = scrollView.leadingAnchor
      .constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
    let trailing = scrollView.trailingAnchor
      .constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
    let top = scrollView.topAnchor
      .constraint(equalTo: safeAreaLayoutGuide.topAnchor)
    let bottom = scrollView.bottomAnchor
      .constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
    NSLayoutConstraint.activate(
      [leading, trailing, top, bottom])
  }

  func activateConstraintsMainStackView() {
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    let equalWidth = mainStackView.widthAnchor
      .constraint(equalTo: scrollView.widthAnchor)
    let leading = mainStackView.leadingAnchor
      .constraint(equalTo: scrollView.leadingAnchor)
    let trailing = mainStackView.trailingAnchor
      .constraint(equalTo: scrollView.trailingAnchor)
    let top = mainStackView.topAnchor
      .constraint(equalTo: scrollView.topAnchor)
    let bottom = mainStackView.bottomAnchor
      .constraint(equalTo: scrollView.bottomAnchor)
    NSLayoutConstraint.activate(
      [equalWidth, leading, trailing, top, bottom])
  }

  static func buildSeparatorView() -> UIView {
    let view = UIView()
    view.heightAnchor.constraint(equalToConstant: 1).isActive = true

    let lineView = UIView()
    lineView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)

    view.addSubview(lineView)

    lineView.translatesAutoresizingMaskIntoConstraints = false
    let leading = lineView.leadingAnchor
      .constraint(equalTo: view.leadingAnchor, constant: 10)
    let trailing = lineView.trailingAnchor
      .constraint(equalTo: view.trailingAnchor)
    let top = lineView.topAnchor
      .constraint(equalTo: view.topAnchor)
    let bottom = lineView.bottomAnchor
      .constraint(equalTo: view.bottomAnchor)
    NSLayoutConstraint.activate(
      [leading, trailing, top, bottom])

    return view
  }

  // MARK: - Gestures
  private func setupGestures() {
    guideContainerView.isUserInteractionEnabled = true
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleEpisodesGesture))
    guideContainerView.addGestureRecognizer(tapGesture)
  }

  @objc func handleEpisodesGesture(_ sender: UITapGestureRecognizer) {
    viewModel.navigateToSeasons()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
