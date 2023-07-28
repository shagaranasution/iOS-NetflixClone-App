//
//  NCSearchViewController.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 11/07/23.
//

import UIKit

final class NCSearchViewController: UIViewController {
    
    
    private let primaryView = NCSearchView()
    private let viewModel = NCSearchViewViewModel()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: NCSearchResultsViewController())
        searchController.searchBar.placeholder = "Search for a Movie"
        searchController.searchBar.searchBarStyle = .minimal
        return searchController
    }()
    
    // MARK: UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Discover"
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.searchController = searchController
        view.addSubview(primaryView)
        viewModel.delegate = self
        viewModel.fetchDiscoverMovies()
        primaryView.delegate = self
        
        searchController.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        primaryView.frame = view.bounds
    }
    
}

// MARK: - Extension ViewModel Delegate

extension NCSearchViewController: NCSearchViewViewModelDelegate {
    
    func didFecthDiscoverMovies() {
        primaryView.configure(with: viewModel)
    }
    
}

// MARK: - Extension SearchResultUpdating

extension NCSearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let searchResultsController = searchController.searchResultsController as? NCSearchResultsViewController,
              let searchText = searchBar.text else {
            return
        }
        
        searchResultsController.configure(with: NCSearchResultsViewViewModel(query: searchText))
        searchResultsController.delegate = self
    }
    
}

// MARK: - Extension View Delegate

extension NCSearchViewController: NCSearchViewDelegate {
    
    func ncSearchView(_ view: NCSearchView, didSelect title: NCTitle) {
        let vc = NCTitlePreviewViewController(title: title)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension NCSearchViewController: NCSearchResultsViewControllerDelegate {
    
    func nCSearchResultsViewController(_ view: NCSearchResultsViewController, didSelect title: NCTitle) {
        let vc = NCTitlePreviewViewController(title: title)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
