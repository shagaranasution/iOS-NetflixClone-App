//
//  NCHomeViewController.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 11/07/23.
//

import UIKit

final class NCHomeViewController: UIViewController {

    private let primaryView = NCHomeView()
    private let homeViewModel = NCHomeViewViewModel()
    
    // MARK: UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavbar()
        view.addSubview(primaryView)
        primaryView.delegate = self
        homeViewModel.fetchTrendingMovies()
        homeViewModel.registerDidFetchPosterPathHandler { [weak self] title in
            self?.primaryView.configureHeaderView(with: NCHeroHeaderViewViewModel(model: title))
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        primaryView.frame = view.bounds
    }
    
    private func configureNavbar() {
        var image = UIImage(named: "netflixLogo")
        image = image?.image(withWidth: 24)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -6)
        ])
        
        let logoBarButtonItem = UIBarButtonItem(customView: containerView)
        navigationItem.leftBarButtonItem = logoBarButtonItem
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"),
                            style: .done,
                            target: self,
                            action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"),
                            style: .done,
                            target: self,
                            action: nil)
        ]
        navigationController?.navigationBar.tintColor = .label
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = CGAffineTransform(translationX: 0, y: min(0, -offset))
    }
    
}

// MARK: - Extension NCHomeViewDelegate

extension NCHomeViewController: NCHomeViewDelegate {
    
    func ncHomeView(_ view: NCHomeView, didTapPlay title: NCTitle) {
        let vc = NCTitlePreviewViewController(title: title)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func ncHomeView(_ view: NCHomeView, didTapTitle title: NCTitle) {
        let vc = NCTitlePreviewViewController(title: title)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func ncHomeView(_ view: NCHomeView, didTapDownloadTitle result: Result<Void, Error>) {
        let message: String
        switch result {
        case .success:
            message = "Download success."
        case .failure:
            message = "Download fail."
        }
        
        let alertController = UIAlertController(
            title: "Download",
            message: message,
            preferredStyle: .alert
        )
        let titleAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(titleAction)
        
        present(alertController, animated: true)
    }
    
}
