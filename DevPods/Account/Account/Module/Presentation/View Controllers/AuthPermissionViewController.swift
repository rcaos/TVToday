//
//  AuthPermissionViewController.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import WebKit
import Shared

class AuthPermissionViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet weak var webView: WKWebView!
  
  private var viewModel: AuthPermissionViewModel!
  
  static func create(with viewModel: AuthPermissionViewModel) -> AuthPermissionViewController {
    let controller = AuthPermissionViewController.instantiateViewController(fromStoryBoard: "AccountViewController")
    controller.viewModel = viewModel
    return controller
  }
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.presentationController?.delegate = self
    setupUI()
  }
  
  deinit {
    print("deinit AuthPermissionViewController")
  }
  
  // MARK: - Setup UI
  
  private func setupUI() {
    setupWebView()
    loadURL()
  }
  
  private func setupWebView() {
    webView.navigationDelegate = self
    webView.allowsBackForwardNavigationGestures = true
  }
  
  private func loadURL() {
    let request = URLRequest(url: viewModel.output.authPermissionURL)
    webView.load(request)
  }
}

// MARK: - WKNavigationDelegate

extension AuthPermissionViewController: WKNavigationDelegate {
  
  func webView(_ webView: WKWebView,
               decidePolicyFor navigationResponse: WKNavigationResponse,
               decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
    if let response = navigationResponse.response as? HTTPURLResponse,
      let headers = response.allHeaderFields as? [String: Any],
      let _ = headers["authentication-callback"] as? String {
      viewModel?.input.didSignIn.onNext(true)
    }
    decisionHandler(.allow)
  }
}

 // MARK: - UIAdaptivePresentationControllerDelegate

extension AuthPermissionViewController: UIAdaptivePresentationControllerDelegate {
  
  func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    viewModel?.input.didSignIn.onNext(true)
  }
}
