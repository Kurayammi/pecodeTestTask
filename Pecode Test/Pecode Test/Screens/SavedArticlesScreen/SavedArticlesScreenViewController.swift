//
//  SavedArticlesScreenViewController.swift
//  Pecode Test
//
//  Created by Kito on 11/6/22.
//

import UIKit

final class SavedArticlesScreenViewController: UIViewController {
    
    @IBOutlet private var articlesTableView: UITableView!
    @IBOutlet private var searchTextField: UITextField!
    
    private let vm = SavedArticlesScreenViewModel()
    
    @IBAction private func searchButtonAction(_ sender: Any) {
        vm.searchByTitle(searchBy: searchTextField.text)
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        vm.deleteAllArticles()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCallbacks()
        vm.onAppear()
    }
    
    private func setupUI() {
        setupTableView()
        setupTextField()
    }
    
    private func setupTextField() {
        searchTextField.delegate = self
    }
    
    private func setupTableView() {
        articlesTableView.delegate = self
        articlesTableView.dataSource = self
        
        articlesTableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil),
                                   forCellReuseIdentifier: "ArticleTableViewCell")
        
        
        articlesTableView.refreshControl = refresher
    }
    
    let refresher: UIRefreshControl = {
        let refreshControll = UIRefreshControl()
        refreshControll.addTarget(self,
                                  action: #selector(refresh(sender: )),
                                  for: .valueChanged)
        return refreshControll
    }()
    
    @objc private func refresh(sender: UIRefreshControl) {
        //vm.onRefresh()
    }
    
    private func setupCallbacks() {
        vm.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.articlesTableView.reloadData()
                self?.articlesTableView.refreshControl?.endRefreshing()
            }
        }
    }
    
}

extension SavedArticlesScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < vm.articles.count {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell") as? ArticleTableViewCell  else { return UITableViewCell() }
            
            let articles = vm.articles
            
            
            cell.setup(title: articles[indexPath.row].title,
                       description: articles[indexPath.row].description,
                       source: articles[indexPath.row].source,
                       author: articles[indexPath.row].author,
                       icon: articles[indexPath.row].image,
                       publishedAt: articles[indexPath.row].publishedAt,
                       isSaved: articles[indexPath.row].isSaved) { [weak self] cell in
                
                guard let indexPath = tableView.indexPath(for: cell) else { return }
                
                self?.vm.onFavouriteButtonTapped(At: indexPath.row)
                
                print("cell tapped at \(indexPath.row)")
            }
            
            return cell
            
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if vm.articles.count == 0 { return }
        
        let urlPath = vm.articles[indexPath.row].url
        
        let vc = DetailsScreenViewController()
        
        vc.urlPath = urlPath
        
        self.present(vc, animated: true)
        
    }
}

extension SavedArticlesScreenViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
