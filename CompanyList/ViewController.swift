//
//  ViewController.swift
//  CompanyList
//
//  Created by doug harper on 10/21/17.
//  Copyright © 2017 Doug Harper. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
  
  let cellId = "cellId"

  override func viewDidLoad() {
    super.viewDidLoad()
   
    view.backgroundColor = ThemeColor.asphalt
    
    tableView.backgroundColor = ThemeColor.asphalt
//    tableView.separatorStyle = .none
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    
    navigationItem.title = "Companies"
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddButtonTapped))
    
    setUpNavControllerStyle()
    
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    
    return cell
  }
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 8
  }
  
  @objc func handleAddButtonTapped() {
    print("add button tapped 👌")
  }
  
  func setUpNavControllerStyle() {
    navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.barTintColor = ThemeColor.red
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    navigationController?.navigationBar.prefersLargeTitles = true
  }


}

