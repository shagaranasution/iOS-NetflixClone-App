//
//  NCSearchResultsViewViewModel.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 20/07/23.
//

import UIKit

protocol NCSearchResultsViewViewModelDelegate: AnyObject {
    func didFetchSearch()
    func didSelectTitle(title: NCTitle)
}

final class NCSearchResultsViewViewModel: NSObject {
    
    weak var delegate: NCSearchResultsViewViewModelDelegate?
    
    private let query: String
    
    private var titles: [NCTitle] = [] {
        didSet {
            for title in titles {
                let cellViewModel = NCTitleCollectionViewCellViewModel(title: title)
                cellViewModels.append(cellViewModel)
            }
        }
    }
    
    public private(set) var cellViewModels: [NCTitleCollectionViewCellViewModel] = []
    
    init(query: String ) {
        self.query = query
    }
    
    public func executeSearch() {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3 else {
            return
        }
        
        let queryParamaters = [
            URLQueryItem(name: "query",
                         value: query),
            URLQueryItem(name: "api_key",
                         value: NCRequest.Constants.API_KEY),
        ]
        let request = NCRequest(endpoint: .searchMovies, queryParamaters: queryParamaters)
        
        NCService.shared.execute(
            request,
            expecting: NCTGetListTitlesResponse.self) { [weak self] result in
                switch result {
                case .success(let model):
                    self?.titles.append(contentsOf: model.results)
                    DispatchQueue.main.async { [weak self] in
                        self?.delegate?.didFetchSearch()
                    }
                case .failure(let error):
                    print("Error: \(String(describing: error))")
                }
            }
    }
    
}

// MARK: Extension CollectionView Delegate

extension NCSearchResultsViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard indexPath.row < cellViewModels.count else {
            return
        }
        delegate?.didSelectTitle(title: titles[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3 - 16,
                      height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let padding: CGFloat = 16
        return UIEdgeInsets(top: padding,
                            left: padding,
                            bottom: padding,
                            right: padding)
    }
    
}
