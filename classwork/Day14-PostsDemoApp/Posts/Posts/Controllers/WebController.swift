//
//  WebController.swift
//  News
//
//  Created by Mustafa on 05/05/20.
//  Copyright © 2020 Mustafa. All rights reserved.
//

import UIKit
import WebKit

class WebController: UIViewController, Cloud {
    
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.backgroundColor = .systemBackground
        return webView
    }()
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .medium)
        activity.hidesWhenStopped = true
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.backgroundColor = .clear
        return activity
    }()
    
    let post: Post
    
    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBarButton()
        navigationItem.largeTitleDisplayMode = .never
        
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        view.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            activityIndicatorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        if let url = post.url {
            webView.load(URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30))
        } else {
            assert(true, "post must have an URL")
        }
    }
    
    func setupBarButton() {
        let image: UIImage? = post.isFavorite ?
            UIImage(systemName: "heart.fill") :
            UIImage(systemName: "heart")
        let barButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(didTapOnFavorite))
        navigationItem.setRightBarButton(barButtonItem, animated: true)
    }
    
    @objc func didTapOnFavorite() {
        post.isFavorite.toggle()
        post.isSynced = false
            
        managedObjectContext.perform { [weak self] in
            if let self = self {
                self.syncFavorites(managedObjectContext: self.managedObjectContext)
            }
        }
        setupBarButton()
    }
}

extension WebController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        activityIndicatorView.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicatorView.startAnimating()
    }
}
