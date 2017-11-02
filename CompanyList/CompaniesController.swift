//
//  ViewController.swift
//  CompanyList
//
//  Created by doug harper on 10/21/17.
//  Copyright © 2017 Doug Harper. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {
  
  let cellId = "cellId"
  var companies = [Company]() 
  
  private func fetchCompanies() {
    // attempt to fetch core data
    let context = CoreDataManager.shared.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
    
    do {
      let companies = try context.fetch(fetchRequest)
      companies.forEach({ (company) in
        print(company.name ?? "")
      })
      
      self.companies = companies
      self.tableView.reloadData()
      
    } catch let fetchErr {
      print("failed to fetch companies: ", fetchErr)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    fetchCompanies()
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleResetButtonTapped))
    
    tableView.backgroundColor = ThemeColor.asphalt
    tableView.separatorColor = .white
    tableView.tableFooterView = UIView() // Blank UIView to hide separator bars
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    
    navigationItem.title = "Companies"
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddButtonTapped))
    
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    
    cell.backgroundColor = ThemeColor.gray
    
    let company = companies[indexPath.row]
    
    if let name = company.name, let founded = company.founded {
      
      // MMM, dd, yyyy
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "MMM, dd, yyyy"
      
      let foundedDateString = dateFormatter.string(from: founded)
      
      let dateString = "\(name) - Founded: \(foundedDateString)"
      
      cell.textLabel?.text = dateString
    } else {
      cell.textLabel?.text = company.name
    }
    
    cell.textLabel?.textColor = .white
    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    
    cell.imageView?.image = #imageLiteral(resourceName: "select_photo_empty")
    
    if let imageData = company.imageData {
      cell.imageView?.image = UIImage(data: imageData)
    }
    
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
    
    // perform an edit
    
    
  }
  
  //  func didEditCompany(company: Company) {
  //
  //  }
  
  private func editHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath) {
    print("Editing Company Info in separate function")
    
    let editCompanyController = CreateCompanyController()
    editCompanyController.delegate = self
    editCompanyController.company = companies[indexPath.row]
    let navController = CustomNavigationController(rootViewController: editCompanyController)
    present(navController, animated: true, completion: nil)
    
  }
  
  @objc private func handleResetButtonTapped() {
    print("reset Button tapped 👌")
  }
  
  @objc func handleAddButtonTapped() {
    print("add button tapped 👌")
    
    let createCompanyController = CreateCompanyController()
    
    let navController = CustomNavigationController(rootViewController: createCompanyController)
    
    createCompanyController.delegate = self
    
    present(navController, animated: true, completion: nil)
    
  }
  
}

extension CompaniesController: CreateCompanyControllerDelegate {
  
  func didAddCompany(company: Company) {
    companies.append(company)
    let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
    tableView.insertRows(at: [newIndexPath], with: .automatic)
  }
  
  func didEditCompany(company: Company) {
    //update tableview somehow
    guard let row = companies.index(of: company) else { return }
    
    let reloadIndexPath = IndexPath(row: row, section: 0)
    tableView.reloadRows(at: [reloadIndexPath], with: .left)
  }
  
}

