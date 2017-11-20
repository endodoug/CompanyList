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
  
  @objc private func doWork() {
    print("Trying to do work 🏋🏼‍♀️")
    
    // GCD
    DispatchQueue.global(qos: .background).async {
      
      CoreDataManager.shared.persistentContainer.performBackgroundTask({ (backgroudContext) in
        
        (0...20000).forEach { (value) in
          print(value)
          let company = Company(context: backgroudContext)
          company.name = String(value)
          
        }
        
        do {
          try backgroudContext.save()
        } catch let saveErr {
          print("Failed to save: ", saveErr)
        }
        
      })
      
//      let context = CoreDataManager.shared.persistentContainer.viewContext
      
      
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.companies = CoreDataManager.shared.fetchCompanies()
    
    navigationItem.leftBarButtonItems = [
      UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleResetButtonTapped)),
      UIBarButtonItem(title: "Do Work", style: .plain, target: self, action: #selector(doWork))
    ]
    
    tableView.backgroundColor = ThemeColor.asphalt
    tableView.separatorColor = .white
    tableView.tableFooterView = UIView() // Blank UIView to hide separator bars
    tableView.register(CompanyCell.self, forCellReuseIdentifier: cellId)
    
    navigationItem.title = "Companies"
    setupPlusButtonInNavBar(selector: #selector(handleAddButtonTapped))
    
  }
  
  @objc private func handleResetButtonTapped() {
    print("reset Button tapped 👌")
    
    
    
//    let context = CoreDataManager.shared.persistentContainer.viewContext
//
//    let batchRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
//
//    do {
//      try context.execute(batchRequest)
//
//      // upon deletion from core data succeeds
//
//      var indexPathsToRemove = [IndexPath]()
//      for (index, _) in companies.enumerated() {
//        let indexPath = IndexPath(row: index, section: 0)
//        indexPathsToRemove.append(indexPath)
//      }
//      companies.removeAll()
//      tableView.deleteRows(at: indexPathsToRemove, with: .left)
//
//    } catch let delErr {
//      print("Failed to delete companies: ", delErr)
//    }
    var indexPathsToRemove = [IndexPath]()
    for (index, _) in companies.enumerated() {
      let indexPath = IndexPath(row: index, section: 0)
      indexPathsToRemove.append(indexPath)
    }
    companies.removeAll()
    tableView.deleteRows(at: indexPathsToRemove, with: .left)
    
    self.companies = CoreDataManager.shared.deleteCompanies()
    
  }
  
  @objc func handleAddButtonTapped() {
    print("add button tapped 👌")
    
    let createCompanyController = CreateCompanyController()
    
    let navController = CustomNavigationController(rootViewController: createCompanyController)
    
    createCompanyController.delegate = self
    
    present(navController, animated: true, completion: nil)
    
  }
  
}

