//
//  NCSearchResultsViewController.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 19/07/23.
//

import UIKit

protocol NCSearchResultsViewControllerDelegate: AnyObject {
    func nCSearchResultsViewController(_ view: NCSearchResultsViewController, didSelect title: NCTitle)
}

final class NCSearchResultsViewController: UIViewController {
    
    public weak var delegate: NCSearchResultsViewControllerDelegate?
    
    private let searchResultsView = NCSearchResultsView()

    override func viewDidLoad() {
        super.viewDidLoad()        
        view.addSubview(searchResultsView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsView.frame = view.bounds
        searchResultsView.delegate = self
    }
    
    public func configure(with viewModel: NCSearchResultsViewViewModel) {
        searchResultsView.configure(with: viewModel)
    }

}

extension NCSearchResultsViewController: NCSearchResultsViewDelegate {
    
    func didSelectTitle(title: NCTitle) {
        delegate?.nCSearchResultsViewController(self, didSelect: title)
    }
    
}
