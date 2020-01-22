//
//  SearchedImageModel.swift
//  PersistenceLab
//
//  Created by Tanya Burke on 1/22/20.
//  Copyright © 2020 Tanya Burke. All rights reserved.
//

import Foundation

struct PhotoData: Codable {
    let totalHits: Int
    let hits: [Photo]
}

struct Photo: Codable {
    let largeImageURL: String
    let webformatHeight: Int
    let webformatWidth: Int
    let likes: Int
    let id:Int
    let views: Int
    let comments: Int
    let webformatURL: String
    let tags: String
    let downloads: Int
    let user: String
    let previewURL: String
    var favorited: Bool?
}
