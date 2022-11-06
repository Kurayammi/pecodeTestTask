//
//  MainScreenViewController.swift
//  Pecode Test
//
//  Created by Kito on 11/3/22.
//

import UIKit

//TODO: Clear code
//TODO: add load spinner
//TODO: Add filter by category, country, sources

final  class MainScreenViewController: UIViewController {
    
    @IBOutlet private var articlesTableView: UITableView!
    
    @IBOutlet private var searchTextField: UITextField!
    
    @IBAction private func searchButtonAction(_ sender: Any) {
        guard let text = searchTextField.text else { return }
        vm.onSearchButtonTapped(searchText: text)
    }
    
    private let vm = MainScreenViewModel()
    private var pushSavedArticlesScreen: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupCallbacks()
        vm.onRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        vm.syncCoreDataWithCurrentArticles()
    }
    func start(pushSavedArticlesScreen: (() -> Void)?) {
        self.pushSavedArticlesScreen = pushSavedArticlesScreen
    }
    
    private func setupUI() {
        setupTableView()
        setupSearchTextField()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.view.tintColor = UIColor.orange
        self.navigationItem.title = "News"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Saved",
                                                                                       style: .plain,
                                                                                       target: self,
                                                                                       action: #selector(savedButtonTapped))
    }
    
    private func setupTableView() {
        articlesTableView.delegate = self
        articlesTableView.dataSource = self
        
        articlesTableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil),
                                   forCellReuseIdentifier: "ArticleTableViewCell")
        
        articlesTableView.register(UINib(nibName: "LoadTableViewCell", bundle: nil),
                                   forCellReuseIdentifier: "LoadTableViewCell")
        
        articlesTableView.refreshControl = refresher
    }
    
    
    private func setupSearchTextField() {
        searchTextField.delegate = self
        searchTextField.placeholder = "Enter to search"
    }
    
    
    private func setupCallbacks() {
        vm.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.articlesTableView.reloadData()
                self?.articlesTableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    let refresher: UIRefreshControl = {
        let refreshControll = UIRefreshControl()
        refreshControll.addTarget(self,
                                  action: #selector(refresh(sender: )),
                                  for: .valueChanged)
        return refreshControll
    }()
    
    @objc private func refresh(sender: UIRefreshControl) {
        vm.onRefresh()
    }
    
    @objc private func savedButtonTapped(sender: UIRefreshControl) {
        pushSavedArticlesScreen?()
    }
}

extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm.articles.count + 1
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
        
        if indexPath.row == vm.articles.count && vm.articles.count > 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LoadTableViewCell") as? LoadTableViewCell else { return UITableViewCell() }
            
            return cell
        }
        
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if vm.articles.count == 0 { return }
        
        if indexPath.row == vm.articles.count {
            print("last tapped ")
            vm.onNextPageTapped()
            
        } else {
            
            let urlPath = vm.articles[indexPath.row].url 
            
            let vc = DetailsScreenViewController()
            
            vc.urlPath = urlPath
            //vc.start(urlPath: urlPath)
            
            self.present(vc, animated: true)
        }
    }
}

extension MainScreenViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
