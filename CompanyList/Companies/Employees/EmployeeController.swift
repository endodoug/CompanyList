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
  var employees = [Employee]()
  let cellId = "cellId"
  
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
      self.employees = employees
//      employees.forEach { print("Employee name: ", $0.name ?? "") }
      
    } catch let fetchErr {
      print("☢️ Failed to fetch: ", fetchErr)
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return employees.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    let employee = employees[indexPath.row]
    cell.textLabel?.text = employee.name
    cell.backgroundColor = ThemeColor.gray
    cell.textLabel?.textColor = .white
    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    return cell
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.backgroundColor = ThemeColor.teal
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    setupPlusButtonInNavBar(selector: #selector(handleAdd))
    
  }
  
  @objc fileprivate func handleAdd() {
    print("adding employee")
    let createEmployeeController = CreateEmployeeController()
    createEmployeeController.delegate = self
    let  navController = UINavigationController(rootViewController: createEmployeeController)
    present(navController, animated: true, completion: nil)
  }
}

extension EmployeeController: CreateEmployeeControllerDelegate {
  func didAddEmployee(employee: Employee) {
    employees.append(employee)
    tableView.reloadData()
  }
  
  
}
