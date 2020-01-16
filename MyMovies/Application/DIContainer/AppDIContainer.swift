//
//  AppDIContainer.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

final class AppDIContainer {
    
    lazy var appConfigurations = AppConfigurations()
    
    lazy var apiDataTransferService: DataTransferService = {
        let queryParameters = [
            "api_key": appConfigurations.apiKey,
            "language": NSLocale.preferredLanguages.first ?? "en"]
        
        let configuration = ApiDataNetworkConfig(
            baseURL: appConfigurations.apiBaseURL,
            queryParameters: queryParameters)
        
        return ApiClientNew<TVShowsProvider>(with: configuration)
    }()
    
    lazy var imageTransferService: DataTransferService = {
        let configuration = ApiDataNetworkConfig(
            baseURL: appConfigurations.imagesBaseURL)
        return ApiClientNew<ImagesProvider>(with: configuration)
    }()
}

extension AppDIContainer {
    
    // MARK : - DIContainers Airing Today
    
    func makeTodayShowsSceneDIContainer() -> TodayShowsSceneDIContainer {
        let dependencies = TodayShowsSceneDIContainer.Dependencies(
            apiDataTransferService: apiDataTransferService,
            imageDataTransferService: imageTransferService)
        return TodayShowsSceneDIContainer(dependencies: dependencies)
    }
    
    // MARK : - DIContainers Popular
    
    func makePopularsSceneDIContainer() -> PopularShowsSceneDIContainer {
        let dependencies = PopularShowsSceneDIContainer.Dependencies(
            apiDataTransferService: apiDataTransferService,
            imageDataTransferService: imageTransferService)
        return PopularShowsSceneDIContainer(dependencies: dependencies)
    }
    
    
    // MARK : - DIContainers Search
    
    func makeSearchSceneDIContainer() -> SearchSceneDIContainer {
        let dependencies = SearchSceneDIContainer.Dependencies(
            apiDataTransferService: apiDataTransferService,
            imageDataTransferService: imageTransferService)
        return SearchSceneDIContainer(dependencies: dependencies)
    }
}
