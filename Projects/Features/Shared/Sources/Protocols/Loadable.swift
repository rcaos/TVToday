//
//  Loadable.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/22/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

public protocol Loadable {
  func showLoadingView()
  func hideLoadingView()
}

// MARK: - UIButton
public extension Loadable where Self: UIButton {

  func showLoadingView() {
    let activityIndicator = UIActivityIndicatorView(style: .white)
    addSubview(activityIndicator)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    activityIndicator.startAnimating()
    activityIndicator.tag = ConstantsLoadable.loadingViewTag
    isUserInteractionEnabled = false
  }

  func hideLoadingView() {
    subviews.forEach { subview in
      if subview.tag == ConstantsLoadable.loadingViewTag {
        subview.removeFromSuperview()
      }
    }
    isUserInteractionEnabled = true
  }
}

// MARK: - UIView

public extension Loadable where Self: UIView {

  func showLoadingView() {
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    addSubview(activityIndicator)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    activityIndicator.startAnimating()
    activityIndicator.tag = ConstantsLoadable.loadingViewTag

    isUserInteractionEnabled = false
  }

  func hideLoadingView() {
    subviews.forEach { subview in
      if subview.tag == ConstantsLoadable.loadingViewTag {
        subview.removeFromSuperview()
      }
    }
    isUserInteractionEnabled = true
  }
}

// MARK: - UIViewController

public extension Loadable where Self: UIViewController {

  func showLoadingView() {
    let loadingView = LoadingView()

    loadingView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(loadingView)

    loadingView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    loadingView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

    loadingView.tag = ConstantsLoadable.loadingViewTag
  }

  func hideLoadingView() {
    view.subviews.forEach { subview in
      if subview.tag == ConstantsLoadable.loadingViewTag {
        subview.removeFromSuperview()
      }
    }
  }
}

// MARK: - ConstantsLoadable

private struct ConstantsLoadable {
  fileprivate static let loadingViewTag = 12345
}
