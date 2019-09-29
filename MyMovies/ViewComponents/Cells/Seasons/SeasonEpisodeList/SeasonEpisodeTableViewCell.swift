//
//  SeasonEpisodeTableViewCell.swift
//  MyTvShows
//
//  Created by Jeans on 9/24/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

protocol SeasonEpisodeTableViewCellDelegate: class{
    
    func didSelectedSeason(at index: Int)
}

class SeasonEpisodeTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: SeasonEpisodeTableViewModel?{
        didSet{
            setupBindables()
        }
    }
    
    weak var delegate: SeasonEpisodeTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        
        let nibName = UINib(nibName: "SeasonEpisodeCollectionViewCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "SeasonEpisodeCollectionViewCell")
        
        print("\n1.: awakeFromNib() Cell: Config collectionView")
    }
    
    func setupBindables(){
        print("1.: Se configuran Bindables")
        
        viewModel?.selectedCell = { index in
            DispatchQueue.main.async {
                self.selectedSeason(at: index)
            }
        }
        
        
        
        print("1.: Está Seleccionada: \(viewModel?.seasonSelected)")
        if let season = viewModel?.seasonSelected{
            if collectionView.indexPathsForVisibleItems.count > 0{
                print("Seleccionar season: \(season)\n")
                selectedSeason(at: season)
            }
        }
        
        //collectionView.reloadData()
        //printCells()
    }
    
    func selectedSeason(at index: Int){
        print("1.: Se seleccionará Season en CollectionView: ... \(index)")
        //print( collectionView.indexPathsForVisibleItems )
        let indexPath = IndexPath(row: index - 1, section: 0)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
        
        printCells()
    }
    
    private func printCells(){
        collectionView.indexPathsForVisibleItems.sorted().map({
            print("\($0), \(collectionView.cellForItem(at: $0)?.isSelected)")
        })
    }
}

extension SeasonEpisodeTableViewCell: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        print("1.: Numero de Seasons: \(viewModel.getNumberOfSeasons())")
        return viewModel.getNumberOfSeasons()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeasonEpisodeCollectionViewCell", for: indexPath) as! SeasonEpisodeCollectionViewCell
        cell.viewModel = viewModel?.getModelFor(indexPath.row)
        return cell
    }
}

extension SeasonEpisodeTableViewCell: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Se selecciono la cell: \(indexPath)")
        self.printCells()
        delegate?.didSelectedSeason(at: indexPath.row)
    }
}

extension SeasonEpisodeTableViewCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let height = collectionView.layer.frame.height
        let insetTop = (height - 50) / 2
        
        return UIEdgeInsets(top: insetTop, left: 8, bottom: insetTop, right: 0)
    }
}
