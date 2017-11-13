//
//  EmployeeController.swift
//  CompanyList
//
//  Created by doug harper on 11/7/17.
//  Copyright © 2017 Doug Harper. All rights reserved.
//

import UIKit
import CoreData

class EmployeeController: UITableViewController {
  
  var company: Company?
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationItem.title = company?.name
    fetchEmployees()
  }
  
  private func fetchEmployees() {
    print("trying to fetch employees")
    let context = CoreDataManager.shared.persistentContainer.viewContext
    let request = NSFetchRequest<Employee>(entityName: "Employee")
    
    do {
      let employees = try context.fetch(request)
      employees.forEach { print("Employee name: ", $0.name ?? "") }
    } catch let fetchErr {
      print("☢️ Failed to fetch: ", fetchErr)
    }
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
