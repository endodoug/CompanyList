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
    
//    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Test Add", style: .plain, target: self, action: #selector(addCompany))
    
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
  
}

