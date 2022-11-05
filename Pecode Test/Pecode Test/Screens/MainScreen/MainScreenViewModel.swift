//
//  MainScreenViewModel.swift
//  Pecode Test
//
//  Created by Kito on 11/3/22.
//

import UIKit

final class MainScreenViewModel {
    
    var onUpdate: (() ->Void)?
    var articles = [ArticlesResponceModel]()
    
    private var totalArticles = 0
    private var currentPage = 1
    private var searchFor = ""
    
    private let imageCash = NSCache<NSString, UIImage>()
    
    func onNextPageTapped() {
        
        if articles.count >= totalArticles { return }
        
        currentPage += 1
        
        let url = ArticlesAPIEndpoint(page: String(currentPage),
                                      searchFor: searchFor).url
        
        let nm = NetworkManager()
        
        nm.sendRequest(with: url, objectType: NewsResponseModel.self) { result in
            
            switch result {
            case .success(let news):
                guard let articles = news.articles else { return }
                guard let total = news.totalResults else { return }
                self.articles += articles
                self.totalArticles = total
                
                print(articles)
                self.onUpdate?()
                
            case .failure:
                print("failure")
            }
        }
        
        
    }
    
    func onFavouriteButtonTapped(At index: Int) {
        
    }
    
    func onSearchButtonTapped(searchText: String) {
        searchFor = searchText
        onRefresh()
    }
    
    func onRefresh() {
        
        currentPage = 1
        
        let url = ArticlesAPIEndpoint(page: String(currentPage),
                                      searchFor: searchFor).url
        
        let nm = NetworkManager()
        
        nm.sendRequest(with: url, objectType: NewsResponseModel.self) { result in
            
            switch result {
            case .success(let news):
                guard let articles = news.articles else { return }
                guard let total = news.totalResults else { return }
                
                self.articles = articles
                self.totalArticles = total
                self.imageCash.removeAllObjects()
                
                print(articles)
                self.onUpdate?()
                
            case .failure:
                print("failure")
            }
        }
    }
    
    func loadImageByIndex(index: Int) -> UIImage? {
        let indexString = String(index)
        
        if let cashedImage = imageCash.object(forKey: NSString(string: indexString as NSString)) {
            return cashedImage
            
        } else {
            
            // load image by url and save in cache
            
            guard let adress = articles[index].urlToImage else { return nil }
            guard let url = URL(string: adress ) else {return nil }
            
            guard let data = try? Data(contentsOf: url) else { return nil }
            guard let image: UIImage = UIImage(data: data) else { return nil}
            
            DispatchQueue.main.async {
                self.imageCash.setObject(image, forKey: NSString(string: indexString as NSString))
            }
            
            return image
        }
    }
}
