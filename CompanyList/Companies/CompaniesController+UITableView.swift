//
//  CompaniesController+UITableView.swift
//  CompanyList
//
//  Created by doug harper on 11/4/17.
//  Copyright © 2017 Doug Harper. All rights reserved.
//

import UIKit

extension CompaniesController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return companies.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CompanyCell
    let company = companies[indexPath.row]
    cell.company = company
    return cell
  }
  
  override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    
    let deleteAction =  UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
      let company = self.companies[indexPath.row]
      print("💨 attempting to delete \(company.name ?? "")")
      
      // Remove company from TableView Row
      self.companies.remove(at: indexPath.row) // needs to remove from array first, because tableView needs the correct amount in companies.count
      self.tableView.deleteRows(at: [indexPath], with: .automatic)
      
      // Remove company from Core Data
      let context = CoreDataManager.shared.persistentContainer.viewContext
      context.delete(company)
      
      do {
        try context.save()
      } catch let saveErr {
        print("☢️ Failed to delete company: ", saveErr)
      }
    }
    
    deleteAction.backgroundColor = ThemeColor.asphalt
    
    let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editHandlerFunction)
    editAction.backgroundColor = ThemeColor.red
    
    return [deleteAction, editAction]
    
  }
  
  private func editHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath) {
    print("Editing Company Info in separate function")
    
    let editCompanyController = CreateCompanyController()
    editCompanyController.delegate = self
    editCompanyController.company = companies[indexPath.row]
    let navController = CustomNavigationController(rootViewController: editCompanyController)
    present(navController, animated: true, completion: nil)
    
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50
  }
  
  override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let label = UILabel()
    label.text = "No Companies Available..."
    label.textColor = .white
    label.textAlignment = .center
    label.font = UIFont.boldSystemFont(ofSize: 16)
    return label
  }
  
  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return companies.count == 0 ? 150 : 0
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView()
    view.backgroundColor = ThemeColor.khaki
    return view
  }
  
}
