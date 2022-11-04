//
//  MainScreenViewController.swift
//  Pecode Test
//
//  Created by Kito on 11/3/22.
//

import UIKit

//TODO: Add search
//TODO: Add pagination
//TODO: Add filter by category, country, sources

final  class MainScreenViewController: UIViewController {
    
    @IBOutlet private var articlesTableView: UITableView!
    
    private let vm = MainScreenViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupCallbacks()
        vm.getArticles()
    }
    
    private func setupUI() {
        setupTableView()
    }
    
    private func setupTableView() {
        articlesTableView.delegate = self
        articlesTableView.dataSource = self
        
        articlesTableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil),
                                   forCellReuseIdentifier: "ArticleTableViewCell")
        
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
        refreshControll.addTarget(self, action: #selector(refresh(sender: )), for: .valueChanged)
        return refreshControll
    }()
    
    @objc private func refresh(sender: UIRefreshControl) {
        vm.getArticles()
    }
}

extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm.totalArticles ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell") as? ArticleTableViewCell {
            
            guard let articles = vm.presenterArticles else { return UITableViewCell() }
            cell.setup(title: articles[indexPath.row].title,
                       description: articles[indexPath.row].description,
                       source: articles[indexPath.row].source?.name,
                       author: articles[indexPath.row].author,
                       iconURL: articles[indexPath.row].urlToImage)
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = UIView()
        footerView.backgroundColor = .blue
        footerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height:
                                    100)
        let button = UIButton()
        button.frame = CGRect(x: 20, y: 10, width: 300, height: 50)
        button.setTitle("CustomButton", for: .normal)
        //button.titleColor(for: .normal) = .cyan
        button.backgroundColor = .red
        footerView.addSubview(button)
        return footerView
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
