//
//  AuthPermissionRootView.swift
//  AccountTV
//
//  Created by Jeans Ruiz on 8/21/20.
//

import Shared
import WebKit

class AuthPermissionRootView: NiblessView {

  private let viewModel: AuthPermissionViewModelProtocol

  let webView: WKWebView = {
    let webView = WKWebView(frame: .zero)
    return webView
  }()

  // MARK: - Initializer
  init(frame: CGRect = .zero, viewModel: AuthPermissionViewModelProtocol) {
    self.viewModel = viewModel
    super.init(frame: frame)

    addSubview(webView)
    setupView()
  }

  // MARK: - Public
  func loadURL() {
    let request = URLRequest(url: viewModel.authPermissionURL)
    webView.load(request)
  }

  // MARK: - Private
  fileprivate func setupView() {
    setupWebView()
  }

  fileprivate func setupWebView() {
    webView.navigationDelegate = self
    webView.allowsBackForwardNavigationGestures = true
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    webView.frame = bounds
  }
}

// MARK: - WKNavigationDelegate
extension AuthPermissionRootView: WKNavigationDelegate {

  func webView(_ webView: WKWebView,
               decidePolicyFor navigationResponse: WKNavigationResponse,
               decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
    if let response = navigationResponse.response as? HTTPURLResponse,
      let headers = response.allHeaderFields as? [String: Any],
      (headers["authentication-callback"] as? String) != nil {
      viewModel.signIn()
    }
    decisionHandler(.allow)
  }
}
