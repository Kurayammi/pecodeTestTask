//
//  MainScreenViewController.swift
//  Pecode Test
//
//  Created by Kito on 11/3/22.
//

import UIKit

//TODO: add load spinner
//TODO: Add filter by category, country, sources

final class MainScreenViewController: UIViewController {
    
    @IBOutlet private var articlesTableView: UITableView!
    @IBOutlet private var searchTextField: UITextField!
    @IBOutlet private var searchButton: UIButton!
    
    @IBAction private func searchButtonAction(_ sender: Any) {
        guard let text = searchTextField.text else { return }
        
        activityView?.startAnimating()
        vm.onSearchButtonTapped(searchText: text)
    }
    
    private let vm = MainScreenViewModel()
    private var pushSavedArticlesScreen: (() -> Void)?
    private var activityView: UIActivityIndicatorView?
    
    private let refresher: UIRefreshControl = {
        let refreshControll = UIRefreshControl()
        refreshControll.tintColor = .systemOrange
        refreshControll.addTarget(self,
                                  action: #selector(refresh(sender: )),
                                  for: .valueChanged)
        return refreshControll
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupCallbacks()
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
        setupActivityIndicator()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.view.backgroundColor = .white
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
        searchTextField.placeholder = "Tap to search"
        searchButton.setTitle("", for: .normal)
    }
    
    private func setupCallbacks() {
        vm.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.articlesTableView.reloadData()
                self?.articlesTableView.refreshControl?.endRefreshing()
                self?.activityView?.stopAnimating()
            }
        }
    }
    
    private func setupActivityIndicator() {
        activityView = UIActivityIndicatorView(style: .large)
        activityView?.center = self.view.center
        activityView?.color = .systemOrange
        if let activityView = activityView {
            self.view.addSubview(activityView)
        }
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        vm.loadArticles(state: .refresh)
    }
    
    @objc private func savedButtonTapped(sender: UIRefreshControl) {
        pushSavedArticlesScreen?()
    }
}

//MARK: UITableViewDelegate
extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // +1 for load cell
        if vm.articles.count > 0 { return vm.articles.count + 1 }
        return 0
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
            activityView?.startAnimating()
            vm.loadArticles(state: .loadNextPage)
        } else {
            
            let urlPath = vm.articles[indexPath.row].url
            
            let vc = DetailsScreenViewController()
            
            vc.urlPath = urlPath
            
            self.present(vc, animated: true)
        }
    }
}

//MARK: UITextFieldDelegate
extension MainScreenViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
