//
//  NCCollectionViewTableViewCellViewModel.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 17/07/23.
//

import UIKit

protocol NCCollectionViewTableViewCellViewModelDelegate: AnyObject {
    func didFetchTitle()
    func didSelectTitle(title: NCTitle)
}

final class NCCollectionViewTableViewCellViewModel: NSObject {
    
    weak var delegate: NCCollectionViewTableViewCellViewModelDelegate?
    
    private let section: NCHomeViewViewModel.Section
    
    private var cellViewModels: [NCTitleCollectionViewCellViewModel] = [] {
        didSet {
            delegate?.didFetchTitle()
        }
    }
    
    private var titles: [NCTitle] = [] {
        didSet {
            for title in titles {
                let viewModel = NCTitleCollectionViewCellViewModel(title: title)
                cellViewModels.append(viewModel)
            }
        }
    }
    
    init(section: NCHomeViewViewModel.Section) {
        self.section = section
    }
    
    public func fetchListTitles() {
        let request: NCRequest
        switch section {
        case .trendingMovies:
            request = NCRequest.listTrendingMoviesRequest
        case .trendingTvs:
            request = NCRequest.listTrendingTvsRequest
        case .popular:
            request = NCRequest.listTrendingPopularMoviesRequest
        case .upcoming:
            request = NCRequest.listTrendingUpcomingMoviesRequest
        case .topRated:
            request = NCRequest.listTrendingTopRatedMoviesRequest
        }
        
        NCService.shared.execute(
            request,
            expecting: NCTGetListTitlesResponse.self) { [weak self] result in
                switch result {
                case .success(let model):
                    self?.titles.append(contentsOf: model.results)
                case .failure(let error):
                    print(String(describing: error))
                }
            }
    }
    
    private func downloadTitle(at indexPath: IndexPath) {
        NCDataPersistenceManager.shared.downloadTitle(model: titles[indexPath.item]) { result in
            switch result {
            case .success:
                NotificationCenter.default.post(name: Notification.Name("downloaded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

// MARK: - UICollectionView Delegate

extension NCCollectionViewTableViewCellViewModel: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NCTitleCollectionViewCell.identifier,
            for: indexPath
        ) as? NCTitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let cellViewModel = cellViewModels[indexPath.item]
        cell.configure(with: cellViewModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: collectionView.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.didSelectTitle(title: titles[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(actionProvider: { _ in
            let downloadAction = UIAction(title: "Download") { [weak self] _ in
                self?.downloadTitle(at: indexPath)
            }
            return UIMenu(title: "", options: .displayInline, children: [downloadAction])
        })
        
        return config
    }
    
}
