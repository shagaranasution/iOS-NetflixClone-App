//
//  NCDownloadsViewController.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 11/07/23.
//

import UIKit

final class NCDownloadsViewController: UIViewController {
    
    private let primaryView = NCDownloadsView()
    private let viewModel = NCDownloadsViewViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        view.addSubview(primaryView)
        viewModel.delegate = self
        primaryView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        primaryView.frame = view.bounds
        viewModel.fetchDownloadedTitle()
        NotificationCenter.default.addObserver(forName: Notification.Name("downloaded"), object: nil, queue: nil) { [weak self] _ in
            self?.viewModel.fetchDownloadedTitle()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }

}

// MARK: - Extension View Model

extension NCDownloadsViewController: NCDownloadsViewViewModelDelegate {
    
    func didFetchDownloadedTitle() {
        primaryView.configure(with: viewModel)
    }
    
}

// MARK: - Extension View

extension NCDownloadsViewController: NCDownloadsViewDelegate {
    
    func ncDownloadsView(_ view: NCDownloadsView, didSelect title: NCTitle) {
        let vc = NCTitlePreviewViewController(title: title)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
