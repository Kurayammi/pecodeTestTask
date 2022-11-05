//
//  MainScreenViewController.swift
//  Pecode Test
//
//  Created by Kito on 11/3/22.
//

import UIKit

//TODO: Add search
//TODO: Add filter by category, country, sources

final  class MainScreenViewController: UIViewController {
    
    @IBOutlet private var articlesTableView: UITableView!
    
    private let vm = MainScreenViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupCallbacks()
        vm.onRefresh()
    }
    
    private func setupUI() {
        setupTableView()
        
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.view.tintColor = UIColor.orange
        self.navigationItem.title = "News"
        
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
                       source: articles[indexPath.row].source?.name,
                       author: articles[indexPath.row].author,
                       iconURL: articles[indexPath.row].urlToImage,
                       isSaved: false) { [weak self] cell in
                guard let indexPath = tableView.indexPath(for: cell) else { return }
                print("cell tapped at \(indexPath.row)")
            }
            
            return cell
            
        }
        
        if indexPath.row == vm.articles.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LoadTableViewCell") as? LoadTableViewCell else { return UITableViewCell() }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    @objc func didTapCellButton(sender: UIButton) {
        print("Button tapped")
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("button")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.row == vm.articles.count {
            print("last tapped ")
            vm.onNextPageTapped()
            
        } else {
            
            guard let urlPath = vm.articles[indexPath.row].url else { return }
            
            let vc = DetailsScreenViewController()
            
            vc.urlPath = urlPath
            //vc.start(urlPath: urlPath)
            
            self.present(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Mark as favourite") {
            
            [weak self] (action, view, completionHandler) in
            self?.vm.onFavouriteButtonTapped(At: indexPath.row)
            completionHandler(true)
        }
        action.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}

extension UIImageView {
    func loadImageBy(URLAdress adress: String?) {
        guard let url = URL(string: adress ?? "") else {return}
        
        DispatchQueue.main.async {
            [weak self] in
            
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                    self?.image = loadedImage
                }
            }
        }
    }
}
