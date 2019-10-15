//
//  TMDBClient.swift
//  MyMovies
//
//  Created by Jeans on 8/20/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

class TMDBClient{
    
    private static let apiKey = "06e1a8c1f39b7a033e2efb972625fee2"
    
    enum ImageSize: String{
        //w92, w154, w185, w300, w500, original
        case smallPoster = "w92"
        case mediumPoster = "w342"
        case bigPoster = "w500"
        
        //w300, w780, w1280, original
        case smallBackDrop = "w300"
        case mediumBackDrop = "w780"
        case bigBackDrop = "w1280"
    }
    
    private enum EndPoints{
        static let base = "https://api.themoviedb.org/3"
        static let baseImage = "https://image.tmdb.org/t/p/"
        static let apiKeyParam = "?api_key=\(TMDBClient.apiKey)"
        
        case getPopularTVShows
        case getAiringTodayShows
        case getGenresTVShows
        case getTVShowDetail(Int)
        
        case getEpisodesFor(Int,Int)
        
        case getImage(ImageSize, String)
        
        case searchTVShow(String)
        
        case listTVShowsBy(Int)
        
        var stringValue: String{
            switch self {
            case .getPopularTVShows:
               return EndPoints.base + "/tv/popular" + EndPoints.apiKeyParam + "&language=en-US&page=1"

            case .getAiringTodayShows:
               return EndPoints.base + "/tv/airing_today" + EndPoints.apiKeyParam + "&language=en-US&page=1"
            
            case .getGenresTVShows:
                return EndPoints.base + "/genre/tv/list" + EndPoints.apiKeyParam + "&language=en-US"
                
            case .getTVShowDetail(let id) :
                return EndPoints.base + "/tv/\(id)" + EndPoints.apiKeyParam + "&language=en-US"
        
            case .getEpisodesFor(let show, let season) :
                return EndPoints.base + "/tv/\(show)/season/\(season)" + EndPoints.apiKeyParam + "&language=en-US"
                
            case .getImage(let imageSize, let imagePath):
                return EndPoints.baseImage + imageSize.rawValue + imagePath
            
            case .searchTVShow(let query):
                return EndPoints.base + "/search/tv" + EndPoints.apiKeyParam + "&language=en-US&query=\( query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" )&page=1"
           
            case .listTVShowsBy(let genre):
                return EndPoints.base + "/discover/tv" + EndPoints.apiKeyParam + "&language=en-US&sort_by=popularity.desc&page=1&timezone=America%2FNew_York&with_genres=\(String(genre))&include_null_first_air_dates=false"
            }
        }
        
        var url: URL{
            return URL(string: stringValue)!
        }
    }
    
    class func getPopularShows(completion: @escaping ([TVShow]?, Error?) -> Void ){
        let url = EndPoints.getPopularTVShows.url
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard let data = data else{
                completion(nil, error)
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else{
                    completion(nil, error)
                    return
            }
            
            do{
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(TVShowResult.self, from: data)
                completion( responseObject.results, nil )
            }catch{
                print("Error:[\(error)]")
                debugPrint(error)
                completion(nil, error)
            }
            
        })
        
        task.resume()
    }
    
    class func getAiringTodayShows(completion: @escaping ([TVShow]?, Error?) -> Void ){
        let url = EndPoints.getAiringTodayShows.url
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard let data = data else{
                completion(nil, error)
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else{
                    completion(nil, error)
                    return
            }
            
            do{
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(TVShowResult.self, from: data)
                completion( responseObject.results, nil )
            }catch{
                print("Error Localize: [\(error.localizedDescription)]")
                completion(nil, error)
            }
        })
        
        task.resume()
    }
    
    class func getGenresTVShows(completion: @escaping ([Genre]?, Error?) -> Void ){
        let url = EndPoints.getGenresTVShows.url
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard let data = data else{
                completion(nil, error)
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else{
                    completion(nil, error)
                    return
            }
            
            do{
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode( GenreListResult.self, from: data)
                completion( responseObject.genres , nil )
            }catch{
                print("Error Localize: [\(error.localizedDescription)]")
                print("Error:[\(error)]")
                completion(nil, error)
            }
        })
        
        task.resume()
    }
    
    class func getTVShowDetail(id: Int, completion: @escaping (TVShowDetailResult?, Error?) -> Void ){
        let url = EndPoints.getTVShowDetail(id).url
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) in
                        
            guard let data = data else{
                completion(nil, error)
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else{
                    completion(nil, error)
                    return
            }
            
            do{
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode( TVShowDetailResult.self, from: data)
                completion( responseObject , nil )
            }catch{
                print("Error Localize: [\(error.localizedDescription)]")
                print("Error:[\(error)]")
                completion(nil, error)
            }
        })
        
        task.resume()
    }
    
    class func getEpisodesFor(show: Int, season:Int, completion: @escaping (SeasonResult?, Error?) -> Void ){
        let url = EndPoints.getEpisodesFor(show, season).url
        print("consultando: [\(url)]")
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard let data = data else{
                completion(nil, error)
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else{
                    completion(nil, error)
                    return
            }
            
            do{
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode( SeasonResult.self, from: data)
                completion( responseObject , nil )
            }catch{
                print("Error Localize: [\(error.localizedDescription)]")
                print("Error:[\(error)]")
                completion(nil, error)
            }
        })
        
        task.resume()
    }
    
    class func getImage(size: ImageSize, path: String, completion: @escaping(Data?,Error?) -> Void ){
        let url = EndPoints.getImage(size, path).url
        
        let task = URLSession.shared.dataTask(with: url, completionHandler:{
            (data, response, error) in
            
            guard let data = data else{
                completion(nil, error)
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else{
                    completion(nil, error)
                    return
            }
            
            completion( data , nil )
        })
        
        task.resume()
    }
    
    class func search(for show: String, completion: @escaping ([TVShow]?, Error?) -> Void ){
        let url = EndPoints.searchTVShow(show).url
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard let data = data else{
                completion(nil, error)
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else{
                    completion(nil, error)
                    return
            }
            
            do{
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode( TVShowResult.self, from: data)
                completion( responseObject.results , nil )
            }catch{
                print("Error Localize: [\(error.localizedDescription)]")
                print("Error:[\(error)]")
                completion(nil, error)
            }
        })
        
        task.resume()
    }
    
    class func listTVShows(by genre: Int, completion: @escaping ([TVShow]?, Error?) -> Void ){
        let url = EndPoints.listTVShowsBy(genre).url
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard let data = data else{
                completion(nil, error)
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else{
                    completion(nil, error)
                    return
            }
            
            do{
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode( TVShowResult.self, from: data)
                completion( responseObject.results , nil )
            }catch{
                print("Error Localize: [\(error.localizedDescription)]")
                print("Error:[\(error)]")
                completion(nil, error)
            }
        })
        
        task.resume()
    }
}
