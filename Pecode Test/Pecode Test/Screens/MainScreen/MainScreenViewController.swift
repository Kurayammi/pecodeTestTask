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
    }
    
    private func setupCallbacks() {
        vm.onUpdate = { [weak self] in
            self?.articlesTableView.reloadData()
        }
    }
}

extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}
