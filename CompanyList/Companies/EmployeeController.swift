//
//  EmployeeController.swift
//  CompanyList
//
//  Created by doug harper on 11/7/17.
//  Copyright © 2017 Doug Harper. All rights reserved.
//

import UIKit

class EmployeeController: UITableViewController {
  
  var company: Company?
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationItem.title = company?.name
    fetchEmployees()
  }
  
  private func fetchEmployees() {
    print("trying to fetch employees")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.backgroundColor = ThemeColor.teal
    
    setupPlusButtonInNavBar(selector: #selector(handleAdd))
    
  }
  
  @objc fileprivate func handleAdd() {
    print("adding employee")
    let createEmployeeController = CreateEmployeeController()
    let  navController = UINavigationController(rootViewController: createEmployeeController)
    present(navController, animated: true, completion: nil)
  }
}
