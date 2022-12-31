//
//  ArticleViewModel.swift
//  NewsAppMVVM
//
//  Created by Bibi on 2022/12/30.
//

import Foundation
import RxSwift
import RxCocoa

// root view model : 모든 뷰모델 요소를 감싸는 모델??
struct ArticleListViewModel {
    let articlesViewModel: [ArticleViewModel]
}

extension ArticleListViewModel {
    init(_ articles: [Article]) {
        self.articlesViewModel = articles.compactMap(ArticleViewModel.init)// ??
    }
    
    func articleAt(_ index: Int) -> ArticleViewModel {
        return self.articlesViewModel[index]
    }
}

struct ArticleViewModel { // Article 하나하나를 나타낸다
    let article: Article
    
    init(_ article: Article) { // ArticleViewModel을 만드려면 반드시 Article을 전달하도록 함
        self.article = article
    }
    
}

extension ArticleViewModel { // Article은 아니지만 Article을 나타낼 때 쓰이는 연관된 요소들?
    
    var title: Observable<String> { // String대신 옵저버블 반환
        return Observable<String>.just(article.title)
    }
    
    var description: Observable<String> {
        return Observable<String>.just(article.description ?? "")
    }
}
