//
//  NCCollectionViewTableViewCell.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 11/07/23.
//

import UIKit

protocol NCCollectionViewTableViewCellProtocol: AnyObject {
    func ncCollectionViewTableViewCell(_ cell: UITableViewCell, didTapTitle title: NCTitle)
}

final class NCCollectionViewTableViewCell: UITableViewCell {
    
    static let identifier = "NCCollectionViewTableViewCell"
    
    weak var delegate: NCCollectionViewTableViewCellProtocol?
    
    private var viewModel: NCCollectionViewTableViewCellViewModel? {
        didSet {
            guard let viewModel else {
                return
            }
            
            collectionView.delegate = viewModel
            collectionView.dataSource = viewModel
            viewModel.delegate = self
            viewModel.fetchListTitles()
            
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(NCTitleCollectionViewCell.self,
                                forCellWithReuseIdentifier: NCTitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with viewModel: NCCollectionViewTableViewCellViewModel) {
        self.viewModel = viewModel
    }
    
}

extension NCCollectionViewTableViewCell: NCCollectionViewTableViewCellViewModelDelegate {
        
    func didFetchTitle() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func didSelectTitle(title: NCTitle) {
        delegate?.ncCollectionViewTableViewCell(self, didTapTitle: title)
    }
    
}
