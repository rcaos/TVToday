//
//  Created by Jeans Ruiz on 7/5/20.
//

import UIKit
import Combine
import UI
import Persistence

class VisitedShowTableViewCell: NiblessTableViewCell {

  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.isScrollEnabled = true
    collectionView.allowsMultipleSelection = false
    collectionView.backgroundColor = .secondarySystemBackground
    return collectionView
  }()

  var viewModel: VisitedShowViewModelProtocol?

  private var disposeBag = Set<AnyCancellable>()

  private let preferredWidth: CGFloat = 100.0
  private let preferredHeight: CGFloat = 170.0

  typealias DataSource = UICollectionViewDiffableDataSource<HeaderModel, ShowVisited>
  typealias Snapshot = NSDiffableDataSourceSnapshot<HeaderModel, ShowVisited>
  private var dataSource: DataSource?

  // MARK: - Life Cycle
  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  override func systemLayoutSizeFitting(_ targetSize: CGSize,
                                        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
                                        verticalFittingPriority: UILayoutPriority) -> CGSize {
    collectionView.layoutIfNeeded()
    collectionView.frame = CGRect(x: 0, y: 0, width: targetSize.width, height: preferredHeight)
    return collectionView.collectionViewLayout.collectionViewContentSize
  }

  func setupCell(with viewModel: VisitedShowViewModelProtocol) {
    self.viewModel = viewModel
    disposeBag = Set<AnyCancellable>()

    collectionView.delegate = self

    dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,
                                                    cellProvider: { collectionView, indexPath, model in
      let cell = collectionView.dequeueReusableCell(with: VisitedShowCollectionViewCell.self, for: indexPath)
      cell.setModel(imageURL: model.pathImage)
      return cell
    })

    viewModel.shows
      .map { shows -> Snapshot in
        var snapShot = Snapshot()
        snapShot.appendSections([.header])
        snapShot.appendItems(shows, toSection: .header)
        return snapShot
      }
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] snapshot in
        self?.dataSource?.apply(snapshot)
      })
      .store(in: &disposeBag)
  }

  private func setupUI() {
    constructHierarchy()
    activateConstraints()
    configureViews()
  }

  private func configureViews() {
    collectionView.registerCell(cellType: VisitedShowCollectionViewCell.self)
  }

  private func constructHierarchy() {
    contentView.addSubview(collectionView)
  }

  private func activateConstraints() {
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.pin(to: contentView)
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension VisitedShowTableViewCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: preferredWidth, height: preferredHeight)
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let item = dataSource?.itemIdentifier(for: indexPath) {
      viewModel?.showDidSelected(id: item.id)
    }
  }
}
