//
//  PosterImageRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

protocol PosterImageRepository {
    
    var imageNotFound: Data? { get }
    
    func image(with imagePath: String,
               type: PosterImageType,
               completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable?
}

enum PosterImageType {
    
    case poster(posterSize: PosterSize)
    
    case backDrop(backDropSize: BackDropSize)
}

enum PosterSize: String {
    //w92, w154, w185, w300, w500, original
    case smallPoster = "w92"
    case mediumPoster = "w342"
    case bigPoster = "w500"
}

enum BackDropSize: String {
    //w300, w780, w1280, original
    case smallBackDrop = "w300"
    case mediumBackDrop = "w780"
    case bigBackDrop = "w1280"
}
