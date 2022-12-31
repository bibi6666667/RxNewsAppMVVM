//
//  NewsTableViewController.swift
//  NewsAppMVVM
//
//  Created by Bibi on 2022/12/30.
//

import Foundation
import UIKit
import RxSwift

class NewsTableViewController: UITableViewController {
    
    let disposeBag = DisposeBag()
    private var articleListViewModel: ArticleListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        populateNews()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articleListViewModel == nil ? 0 : self.articleListViewModel.articlesViewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as? ArticleTableViewCell else {
            fatalError("ArticleTableViewCell is not found.")
        }
        
        let articleViewModel = self.articleListViewModel.articleAt(indexPath.row)
        
        // bind 함수나 driver를 통해 뷰모델과 뷰를 바인딩할 수 있다. (여기서는 driver사용)
        articleViewModel.title.asDriver(onErrorJustReturn: "")
            .drive(cell.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        articleViewModel.description.asDriver(onErrorJustReturn: "")
            .drive(cell.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        return cell
    }
    
    private func populateNews() {
        let resource = Resource<ArticleResponse>(url: URL(string: "https://newsapi.org/v2/top-headlines?country=kr&apiKey=APIKEY")!)
        
        URLRequest.load(resource: resource)
            .subscribe(onNext: { [weak self] articleResponse in
                let articles = articleResponse.articles
                self?.articleListViewModel = ArticleListViewModel(articles)
                
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
                
            }).disposed(by: disposeBag)
    }
}
