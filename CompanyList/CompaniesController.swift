//
//  ViewController.swift
//  CompanyList
//
//  Created by doug harper on 10/21/17.
//  Copyright © 2017 Doug Harper. All rights reserved.
//

import UIKit

class CompaniesController: UITableViewController {
  
  let cellId = "cellId"
  let companies = [
    Company(name: "Apple", founded: Date()),
    Company(name: "Roku", founded: Date()),
    Company(name: "Toyota", founded: Date()),
    Company(name: "Mazda", founded: Date())
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.backgroundColor = ThemeColor.asphalt
    tableView.separatorColor = .white
    tableView.tableFooterView = UIView() // Blank UIView to hide separator bars
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    
    navigationItem.title = "Companies"
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddButtonTapped))
    
    setUpNavControllerStyle()
    
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    
    cell.backgroundColor = ThemeColor.gray
    
    let company = companies[indexPath.row]
    
    cell.textLabel?.text = company.name
    cell.textLabel?.textColor = .white
    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return companies.count
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView()
    view.backgroundColor = ThemeColor.khaki
    return view
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50
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

