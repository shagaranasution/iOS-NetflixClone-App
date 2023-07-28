//
//  NCTitleTableViewCellViewModel.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 18/07/23.
//

import Foundation

struct NCTitleTableViewCellViewModel {
    
    let title: NCTitle
    
    public var titleString: String {
        return title.originalTitle ?? title.originalName ?? ""
    }
    
    public var posterPath: String {
        return "https://image.tmdb.org/t/p/w500/\(title.posterPath ?? "")"
    }
    
}
