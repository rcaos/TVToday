//
//  AiringTodayViewController.swift
//  MyMovies
//
//  Created by Jeans on 8/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class AiringTodayViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel: AiringTodayViewModel!
    private var airingTodayViewControllersFactory: AiringTodayViewControllersFactory!
    
    // MARK: - TODO, cambiar por protocol del ViewModel
    
    static func create(with viewModel: AiringTodayViewModel,
                       airingTodayViewControllersFactory: AiringTodayViewControllersFactory) -> AiringTodayViewController {
        let controller = AiringTodayViewController.instantiateViewController()
        controller.viewModel = viewModel
        controller.airingTodayViewControllersFactory = airingTodayViewControllersFactory
        return controller
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //MARK: - SetupView
    func setupUI() {
        navigationItem.title = "Today on TV"
        setupCollection()
    }
    
    //MARK: - SetupTable
    func setupCollection() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let nibName = UINib(nibName: "AiringTodayCollectionViewCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "AiringTodayCollectionViewCell")
        
        collectionView.register(FooterReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter , withReuseIdentifier: "FooterReusableView")
        
        collectionView.backgroundColor = UIColor.groupTableViewBackground
    }
    
    //MARK: - SetupViewModel
    func setupViewModel() {
        //Binding
        viewModel.viewState.bindAndFire({ state in
            DispatchQueue.main.async {
                self.configView(with: state)
            }
        })
        
        viewModel.getShows(for: 1)
    }
    
    func configView(with state: SimpleViewState<TVShow>) {
        
        switch state {
        case .populated(_):
            self.collectionView.reloadData()
        case .paging(_, _):
            self.collectionView.reloadData()
        default:
            print("Default state.")
        }
    }
}

//MARK: - DataSource, Delegate

extension AiringTodayViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.viewState.value.currentEntities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "AiringTodayCollectionViewCell", for: indexPath) as! AiringTodayCollectionViewCell
        item.viewModel = viewModel.getModelFor(indexPath.row)
        
        if case .paging(_, let nextPage) = viewModel.viewState.value,
            indexPath.row == viewModel.viewState.value.currentEntities.count - 1 {
            print("get next Page: \(nextPage)")
            viewModel.getShows(for: nextPage)
        }
        
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterReusableView", for: indexPath) as! FooterReusableView
        return footer
    }
}

extension AiringTodayViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let idSelected = viewModel.viewState.value.currentEntities[indexPath.row].id
        handle( idSelected )
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 275)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let state = viewModel.viewState.value
        switch state {
        case .loading, .paging(_, _):
            return CGSize(width: collectionView.frame.width, height: 100)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
}

extension AiringTodayViewController {
    
    //MARK: - Navigation
    
    //MARK: - TODO AiringTodayViewModelRoute
    func handle(_ route: Int?) {
        guard let identifier = route else { return }
        let detailController = airingTodayViewControllersFactory.makeTVShowDetailsViewController(with: identifier)
        navigationController?.pushViewController(detailController, animated: true)
    }
}

// MARK: - AiringTodayViewControllersFactory

protocol AiringTodayViewControllersFactory {
    
    func makeTVShowDetailsViewController(with identifier: Int) -> UIViewController
}
