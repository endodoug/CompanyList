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
  }
  
  var shortNameEmployees = [Employee]()
  var longNameEmployees = [Employee]()
  
  private func fetchEmployees() {
    guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }

    shortNameEmployees = companyEmployees.filter({ (employee) -> Bool in
      if let count = employee.name?.count {
        return count < 8
      }
      return false
    })
    
    longNameEmployees = companyEmployees.filter({ (employee) -> Bool in
      if let count = employee.name?.count {
        return count > 8
      }
      return false
    })
    print(shortNameEmployees.description)
    print (longNameEmployees.count)
    //    self.employees = companyEmployees
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let label = UILabel()
    label.backgroundColor = ThemeColor.khaki
    if section == 0 {
      label.text = "Long Names"
    } else {
      label.text = "Short Names"
    }
    label.font = UIFont.boldSystemFont(ofSize: 16)
    return label
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return employees.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    let employee = employees[indexPath.row]
    cell.textLabel?.text = employee.name
    if let birthday = employee.employeeInfo?.birthday {
      
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "MMM, dd, yyyy"
      
      cell.textLabel?.text = "\(employee.name ?? "")     \(dateFormatter.string(from: birthday))"
    }
//    if let taxId = employee.employeeInfo?.taxid {
//      cell.textLabel?.text = "\(employee.name ?? "")       \(taxId)"
//    }
    cell.backgroundColor = ThemeColor.gray
    cell.textLabel?.textColor = .white
    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    return cell
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.backgroundColor = ThemeColor.asphalt
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    setupPlusButtonInNavBar(selector: #selector(handleAdd))
    fetchEmployees()
    
  }
  
  @objc fileprivate func handleAdd() {
    print("adding employee")
    let createEmployeeController = CreateEmployeeController()
    createEmployeeController.delegate = self
    createEmployeeController.company = company
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
