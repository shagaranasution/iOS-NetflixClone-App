//
//  NCYoutubeSearchResponse.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 21/07/23.
//

import Foundation

struct NCYoutubeSearchResponse: Codable {
    let items: [NCVideoElement]
}

struct NCVideoElement: Codable {
    let id: NCIdVideoElement
}

struct NCIdVideoElement: Codable {
    let kind: String
    let videoId: String
}
