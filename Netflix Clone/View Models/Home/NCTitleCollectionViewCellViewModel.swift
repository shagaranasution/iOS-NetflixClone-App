//
//  NCTitleCollectionViewCellViewModel.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 17/07/23.
//

import Foundation

final class NCTitleCollectionViewCellViewModel {
    
    private let title: NCTitle
    
    init(title: NCTitle) {
        self.title = title
    }
    
    public var posterUrl: URL? {
        let string = "https://image.tmdb.org/t/p/w500\(title.posterPath ?? "")"
        return URL(string: string)
    }
    
}
