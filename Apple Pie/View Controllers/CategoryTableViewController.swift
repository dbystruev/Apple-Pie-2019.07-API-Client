//
//  CategoryTableViewController.swift
//  Apple Pie
//
//  Created by Denis Bystruev on 13/08/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    let networkManager = NetworkManager()
    
    var categories = [Category]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.loadCategories { categories in
            guard let categories = categories else {
                return
            }
            
            self.categories = categories
        }
    }
}


// MARK: - UITableViewDataSource
extension CategoryTableViewController /*: UITableViewDataSource */ {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        configure(cell, with: category)
        return cell
    }
}

// MARK: - Cell Configurator
extension CategoryTableViewController {
    func configure(_ cell: UITableViewCell, with category: Category) {
        cell.textLabel?.text = category.name
    }
}
