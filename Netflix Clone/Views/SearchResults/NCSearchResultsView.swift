//
//  NCSearchResultsView.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 20/07/23.
//

import UIKit

protocol NCSearchResultsViewDelegate: AnyObject {
    func didSelectTitle(title: NCTitle)
}

final class NCSearchResultsView: UIView {
    
    public weak var delegate: NCSearchResultsViewDelegate?
    
    private var viewModel: NCSearchResultsViewViewModel? {
        didSet {
            guard let viewModel else {
                return
            }
            collectionView.delegate = viewModel
            collectionView.dataSource = viewModel
            
            viewModel.delegate = self
            viewModel.executeSearch()
        }
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(NCTitleCollectionViewCell.self,
                                forCellWithReuseIdentifier: NCTitleCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
    
    public func configure(with viewModel: NCSearchResultsViewViewModel) {
        self.viewModel = viewModel
    }
    
}

extension NCSearchResultsView: NCSearchResultsViewViewModelDelegate {
    
    func didFetchSearch() {
        collectionView.reloadData()
    }
    
    func didSelectTitle(title: NCTitle) {
        delegate?.didSelectTitle(title: title)
    }
    
}
