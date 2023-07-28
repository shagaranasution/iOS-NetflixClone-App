//
//  NCTitlePreviewViewController.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 24/07/23.
//

import UIKit

final class NCTitlePreviewViewController: UIViewController {
    
    private let viewModel: NCTitlePreviewViewViewModel
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemBackground
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        return scrollView
    }()

    private let primaryView: NCTitlePreviewView
    
    init(title: NCTitle) {
        self.viewModel = NCTitlePreviewViewViewModel(title: title)
        self.primaryView = NCTitlePreviewView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Preview"
        navigationController?.navigationBar.tintColor = .label
        view.addSubview(scrollView)
        primaryView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(primaryView)
        primaryView.delegate = self
        addConstraints()
        viewModel.fetchTitlePreview()
        setupHandler()
    }

    private func addConstraints() {
        let primaryHeightConstraint = primaryView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        primaryHeightConstraint.isActive = true
        primaryHeightConstraint.priority = UILayoutPriority(50)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            primaryView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            primaryView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            primaryView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            primaryView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            primaryView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
    
    private func setupHandler() {
        viewModel.registerDidFetchTitlePreviewHandler { [weak self] (titleText, overviewText, videoPreviewURL) in
            self?.primaryView.configure(titleText: titleText, overviewText: overviewText, videoPreviewURL: videoPreviewURL)
        }
    }
    
}

extension NCTitlePreviewViewController: NCTitlePreviewViewDelegate {
    
    func ncTitlePreviewView(_ view: NCTitlePreviewView, didDownloadTitleResult result: (Result<Void, Error>)) {
        let message: String
        switch result {
        case .success:
            message = "Download success."
        case .failure:
            message = "Download fail."
        }
        
        let alertContoller = UIAlertController(
            title: "Download",
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertContoller.addAction(okAction)
        
        present(alertContoller, animated: true)
    }
    
}
