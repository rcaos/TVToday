//
//  AiringTodayViewController.swift
//  MyMovies
//
//  Created by Jeans on 8/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class AiringTodayViewController: UIViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy private var viewModel:AiringTodayViewModel = AiringTodayViewModel()
    
    var loadingView: UIView!
    
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
    func setupUI(){
        navigationItem.title = "Today on TV"
        setupCollection()
    }
    
    //MARK: - SetupTable
    func setupCollection(){
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let nibName = UINib(nibName: "AiringTodayCollectionViewCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "AiringTodayCollectionViewCell")
        
        collectionView.backgroundColor = UIColor.groupTableViewBackground
    }
    
    //MARK: - SetupViewModel
    func setupViewModel(){
        //Binding
        viewModel.viewState.bindAndFire({ state in
            DispatchQueue.main.async {
                self.configView(with: state)
            }
        })
        
        viewModel.getShows()
    }
    
    func configView(with state: AiringTodayViewModel.ViewState){
        
        if let customView = loadingView{
            customView.removeFromSuperview()
        }
        
        switch state {
        case .populated(_):
            self.collectionView.reloadData()
        default:
            buildLoadingView()
            self.view.addSubview( loadingView )
        }
    }
    
    func buildLoadingView(){
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.color = .darkGray
        activityIndicator.frame = CGRect(x: 0, y: 0, width: collectionView.frame.width, height: 100)
        
        loadingView = UIView(frame: self.view.frame)
        loadingView.backgroundColor = .white
        
        activityIndicator.center = loadingView.center
        loadingView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTVShowDetail"{
            let showID = sender as! Int
            let controller = segue.destination as! TVShowDetailViewController
            controller.idShow = showID
        }
    }
}

//MARK: - DataSource, Delegate
extension AiringTodayViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.viewState.value.currentEpisodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "AiringTodayCollectionViewCell", for: indexPath) as! AiringTodayCollectionViewCell
        item.viewModel = viewModel.getModelFor(indexPath.row)
        return item
    }
}

extension AiringTodayViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let idSelected = viewModel.viewState.value.currentEpisodes[indexPath.row].id
        performSegue(withIdentifier: "ShowTVShowDetail", sender: idSelected)
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 275)
    }
    
}
