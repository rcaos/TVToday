[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![Platforms](https://img.shields.io/badge/platform-iOS-lightgrey.svg)
[![Swift Version](https://img.shields.io/badge/Swift-5-F16D39.svg?style=flat)](https://developer.apple.com/swift)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

TVShows iOS app built with Combine, using the [TMDb API](https://www.themoviedb.org/).

## What I'm working on

June, 2022
* ✅ Localize UI and requests to endpoint

May, 2022
* ✅ Support Dynamic Type 

April, 2022

* ✅ Improve UseCases and Repositories use (Clear separation between Repositories and DataSources
* ✅ Moving from Realm to Core Data
* ✅ Add demo apps for feature modules.
* ✅ Fix testability on Schedulers

March, 2022

- ✅ Migrate from RxDataSources to UICollectionViewDiffableDataSource
- ✅ Migrate from RxSwift to Combine

 
## About modularization

In this project, I show you an approach to how you could structure your app. 

In a real big app, you will have more and big dependencies.

During development time, compiling the whole app could take quite an amount of time.

Currently, the app is divided into 22 modules with 06 feature modules. [See](https://github.com/rcaos/TVToday/blob/master/Package.swift)

Each feature module has its own demo target with a custom demo entry point.

So you need to leverage your Unit tests, Snapshot Tests and Demo targets to save your time and boost your productivity.


## Built with
- Swift 5
- Combine
- Clean + Modular Architecture
- Coordinator Pattern.
- MVVM
- Dependency Injection
- Kingfisher
- Core Data
- KeychainSwift
- Swift Package Manager
- Dark Mode support
- Dynamic Type support
- English and Spanish Localized

## Requirements
1. Xcode 15.0+

## Getting started
1. Clone this repository.
2. Open `App/TVToday.xcodeproj` and have fun.

## Testing
- I use plain tests and Snapshot tests
- Check the test Plan associated to the AppFeature to run all the test availables

## Snapshot Tests
Last snapshot tests were created using an Apple Silicon with `Xcode 15.0`, Simulator `iPhone SE (3rd generation) iOS 17.0 (21A328)`
> ⚠️ Warning: Snapshots must be compared using the exact same simulator that originally took the reference to avoid discrepancies between images.


## Project evolution
- Monolith: https://github.com/rcaos/TVToday/releases/tag/v0.3.0
- RxSwift + CocoaPods : https://github.com/rcaos/TVToday/releases/tag/v.0.4.0
- RxSwift + SPM + Tuist: https://github.com/rcaos/TVToday/releases/tag/v0.5.0
- Combine + SPM + Tuist https://github.com/rcaos/TVToday/releases/tag/v0.6.0
- Current branch: Combine + SPM

## Screenshots

### Dynamic Type
<p>
<img src="https://github.com/rcaos/TVToday/blob/master/Screenshots/dynamic-type-1.png" width="600">
<img src="https://github.com/rcaos/TVToday/blob/master/Screenshots/dynamic-type-2.png" width="600">
</p>

## Dark Mode
<p>
<img src="https://github.com/rcaos/TVToday/blob/master/Screenshots/dark/01.png" width="215" height="383">
<img src="https://github.com/rcaos/TVToday/blob/master/Screenshots/dark/02.png" width="215" height="383">
<img src="https://github.com/rcaos/TVToday/blob/master/Screenshots/dark/03.png" width="215" height="383">
<img src="https://github.com/rcaos/TVToday/blob/master/Screenshots/dark/04.png" width="215" height="383">
<img src="https://github.com/rcaos/TVToday/blob/master/Screenshots/dark/05.png" width="215" height="383">
<img src="https://github.com/rcaos/TVToday/blob/master/Screenshots/dark/06.png" width="215" height="383">
<img src="https://github.com/rcaos/TVToday/blob/master/Screenshots/dark/07.png" width="215" height="383">
<img src="https://github.com/rcaos/TVToday/blob/master/Screenshots/dark/08.png" width="215" height="383">
</p>

## Light Mode
<p>
<img src="https://github.com/rcaos/TVToday/blob/master/Screenshots/light/01.png" width="215" height="383">
<img src="https://github.com/rcaos/TVToday/blob/master/Screenshots/light/02.png" width="215" height="383">
<img src="https://github.com/rcaos/TVToday/blob/master/Screenshots/light/03.png" width="215" height="383">
<img src="https://github.com/rcaos/TVToday/blob/master/Screenshots/light/04.png" width="215" height="383">
<img src="https://github.com/rcaos/TVToday/blob/master/Screenshots/light/05.png" width="215" height="383">
<img src="https://github.com/rcaos/TVToday/blob/master/Screenshots/light/06.png" width="215" height="383">
<img src="https://github.com/rcaos/TVToday/blob/master/Screenshots/light/07.png" width="215" height="383">
<img src="https://github.com/rcaos/TVToday/blob/master/Screenshots/light/08.png" width="215" height="383">
</p>

# Author
Jeans Ruiz, jeansruiz.c@gmail.com
