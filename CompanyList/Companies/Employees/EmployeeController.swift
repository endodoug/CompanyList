//
//  EmployeeController.swift
//  CompanyList
//
//  Created by doug harper on 11/7/17.
//  Copyright © 2017 Doug Harper. All rights reserved.
//

import UIKit
import CoreData

// UILabel Subclass for custom text drawing
class IndentedLabel: UILabel {
  override func drawText(in rect: CGRect) {
    let insets = UIEdgeInsetsMake(0, 16, 0, 0)
    let customRect = UIEdgeInsetsInsetRect(rect, insets)
    super.drawText(in: customRect)
  }
}

class EmployeeController: UITableViewController {
  
  var company: Company?
  let cellId = "cellId"
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationItem.title = company?.name
  }

  var allEmployeeNames = [[Employee]]()
  
  var employeeTypes = [
    EmployeeType.Executive.rawValue,
    EmployeeType.SeniorManagement.rawValue,
    EmployeeType.Staff.rawValue,
    EmployeeType.Intern.rawValue
  ]
  
  private func fetchEmployees() {
    guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }
    
    allEmployeeNames = []
    
    // use new array and loop to perform the filter
    employeeTypes.forEach { (employeeType) in
      
      // somehow construct my allEmployeeNames Array
      allEmployeeNames.append(
        companyEmployees.filter { $0.type == employeeType }
      )
      
    }
    
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let label = IndentedLabel()
    label.backgroundColor = ThemeColor.khaki
    label.text = employeeTypes[section]
    label.font = UIFont.boldSystemFont(ofSize: 16)
    return label
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return allEmployeeNames.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return allEmployeeNames[section].count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    
    let employee = allEmployeeNames[indexPath.section][indexPath.row]

    cell.textLabel?.text = employee.name
    if let birthday = employee.employeeInfo?.birthday {
      
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "MMM, dd, yyyy"
      
      cell.textLabel?.text = "\(employee.name ?? "")     \(dateFormatter.string(from: birthday))"
    }

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
    let createEmployeeController = CreateEmployeeController()
    createEmployeeController.delegate = self
    createEmployeeController.company = company
    let  navController = UINavigationController(rootViewController: createEmployeeController)
    present(navController, animated: true, completion: nil)
  }
}
// fired off when the CreateEmployeeController is dismissed
extension EmployeeController: CreateEmployeeControllerDelegate {
  func didAddEmployee(employee: Employee) {

    // what is insertion index path
    // FIXME: Bang!
    guard let section = employeeTypes.index(of: employee.type!) else { return }
    // what is my row?
    let row = allEmployeeNames[section].count
    let insertionIndexPath = IndexPath(row: row, section: section)
    
    allEmployeeNames[section].append(employee)
    
    tableView.insertRows(at: [insertionIndexPath], with: .right)
  }
  
  
}
