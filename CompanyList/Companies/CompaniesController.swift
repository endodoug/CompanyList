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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.companies = CoreDataManager.shared.fetchCompanies()
    
//    fetchCompanies()
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleResetButtonTapped))
    
    tableView.backgroundColor = ThemeColor.asphalt
    tableView.separatorColor = .white
    tableView.tableFooterView = UIView() // Blank UIView to hide separator bars
    tableView.register(CompanyCell.self, forCellReuseIdentifier: cellId)
    
    navigationItem.title = "Companies"
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddButtonTapped))
    
  }
  
  @objc private func handleResetButtonTapped() {
    print("reset Button tapped 👌")
    
    let context = CoreDataManager.shared.persistentContainer.viewContext
    
    let batchRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
    
    do {
      try context.execute(batchRequest)
      
      // upon deletion from core data succeeds
      
      var indexPathsToRemove = [IndexPath]()
      for (index, _) in companies.enumerated() {
        let indexPath = IndexPath(row: index, section: 0)
        indexPathsToRemove.append(indexPath)
      }
      companies.removeAll()
      tableView.deleteRows(at: indexPathsToRemove, with: .left)
      
    } catch let delErr {
      print("Failed to delete companies: ", delErr)
    }
  }
  
  @objc func handleAddButtonTapped() {
    print("add button tapped 👌")
    
    let createCompanyController = CreateCompanyController()
    
    let navController = CustomNavigationController(rootViewController: createCompanyController)
    
    createCompanyController.delegate = self
    
    present(navController, animated: true, completion: nil)
    
  }
  
}

