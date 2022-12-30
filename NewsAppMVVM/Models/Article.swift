//
//  Article.swift
//  NewsAppMVVM
//
//  Created by Bibi on 2022/12/30.
//

import Foundation

struct ArticleResponse: Decodable {
    let articles: [Article]
}

struct Article: Decodable {
    let title: String
    let description: String? // can be null
}
