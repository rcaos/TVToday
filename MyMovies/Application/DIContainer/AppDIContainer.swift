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
        let baseURL = URL(string: appConfigurations.apiBaseURL)!
        let queryParameters =
            ["api_key": appConfigurations.apiKey,
             "language": NSLocale.preferredLanguages.first ?? "en"]
        
        let config = ApiDataNetworkConfig(baseURL: baseURL, queryParameters: queryParameters)
        
        let apiDataNetwork = DefaultNetworkService(config: config)
        
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    
    lazy var imageTransferService: DataTransferService = {
        let baseURL = URL(string: appConfigurations.apiBaseURL)!
        
        let config = ApiDataNetworkConfig(baseURL: baseURL)
        
        let apiDataNetwork = DefaultNetworkService(config: config)
        
        return DefaultDataTransferService(with: apiDataNetwork)
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
    
    
    // MARK : - DIContainers Search
}
