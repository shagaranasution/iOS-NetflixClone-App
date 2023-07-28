//
//  NCUpcomingViewController.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 11/07/23.
//

import UIKit

final class NCUpcomingViewController: UIViewController {
    
    private let primaryView = NCUpcomingView()
    private let viewModel = NCUpcomingViewViewModel()
    
    // MARK: UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        view.addSubview(primaryView)
        viewModel.delegate = self
        primaryView.delegate = self
        viewModel.fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        primaryView.frame = view.bounds
    }

}

// MARK: - Extension view model delgate

extension NCUpcomingViewController: NCUpcomingViewViewModelDelegate {
    
    func didFecthInitialData() {
        primaryView.configure(with: viewModel)
    }
    
}

// MARK: - Extension view delegate

extension NCUpcomingViewController: NCUpcomingViewDelegate {
    
    func ncUpcomingView(_ view: NCUpcomingView, didSelect title: NCTitle) {
        let vc = NCTitlePreviewViewController(title: title)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
