//
//  SavedArticlesScreenViewModel.swift
//  Pecode Test
//
//  Created by Kito on 11/6/22.
//

import UIKit

final class SavedArticlesScreenViewModel {
    
    var onUpdate: (() ->Void)?
    var articles = [ArticlesModel]()

    func onAppear() {
        let dbManager = ArticlesDatabaseManager()
        
        guard let fetchedArticles = dbManager.fetchArticlesFromCoreData() else { return }
        
        articles = fetchedArticles
        
        onUpdate?()
    }
    
    func searchByTitle(searchBy text: String?) {
        guard let text = text else {
            return
        }
        
        let searchedArticles = articles.compactMap {
            if $0.title.contains(text) {
                return $0
            }
            
            return nil
        }
        
        articles = searchedArticles
        onUpdate?()
    }
    
    func deleteAllArticles() {
        let dbManager = ArticlesDatabaseManager()
        dbManager.deleteAllFromCoreData()
        articles = []
        onUpdate?()
    }
    
    func onFavouriteButtonTapped(At index: Int) {
        let dbManager = ArticlesDatabaseManager()
        
        
        dbManager.deleteEntityFromCoreData(title: articles[index].title)
        articles.remove(at: index)
        onUpdate?()
    }
    
}
