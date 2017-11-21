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
    
    CoreDataManager.shared.persistentContainer.performBackgroundTask({ (backgroudContext) in
      
      (0...5).forEach { (value) in
        print(value)
        let company = Company(context: backgroudContext)
        company.name = String(value)
        
      }
      
      do {
        try backgroudContext.save()
        
        DispatchQueue.main.async {
          self.companies = CoreDataManager.shared.fetchCompanies()
          self.tableView.reloadData()
        }
        
      } catch let saveErr {
        print("Failed to save: ", saveErr)
      }
      
    })
    
    // GCD
    DispatchQueue.global(qos: .background).async {
//      let context = CoreDataManager.shared.persistentContainer.viewContext
    }
  }
  
  // Tricky Core Data updates
  @objc private func doUpdates() {
    print("Trying to update Companies in a Background Thread 🏃")
    CoreDataManager.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
      
      let request: NSFetchRequest<Company> = Company.fetchRequest()
      do {
        let companies = try backgroundContext.fetch(request)
        companies.forEach({ (company) in
          print(company.name ?? "")
          company.name = "C: \(company.name ?? "")"
        })
        
        do {
          try backgroundContext.save()
          
          // update the UI after save
          DispatchQueue.main.async {
            // reset will forget all the objects I've previously fetched.
            CoreDataManager.shared.persistentContainer.viewContext.reset()
            
            // if just making a couple updates, I don't want to re-fetch everything.
            
            self.companies = CoreDataManager.shared.fetchCompanies()
            
            // is there a way to simply merge the cnanges made to the main viewContext
            
            self.tableView.reloadData()
          }
          
          
        } catch let err {
          print("failed to save on background thread: ", err)
        }
        
      } catch let err {
        print("Failed to fetch on background ☢️: ", err)
      }
      
    }

  }
  
  @objc private func doNestedUpdates() {
    print("Trying to do Nested Updates 🦅")
    DispatchQueue.global(qos: .background).async {
      // try to perform the updates
      
      // first construct a custom MOC
      let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
      
      privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
      
      // execute all updates on the private Context
      let request: NSFetchRequest<Company> = Company.fetchRequest()
      request.fetchLimit = 1
      
      do {
        let companies = try privateContext.fetch(request)
        companies.forEach({ (company) in
          print(company.name ?? "")
          company.name = "D: \(company.name ?? "")"
        })
        
        do {
          try privateContext.save()
          // after save succeeds...
          DispatchQueue.main.async {
            // save the main context to the persisten store
            do {
              try CoreDataManager.shared.persistentContainer.viewContext.save()
            } catch let saveErr {
              print("Failed to save the main context: ", saveErr)
            }
            self.tableView.reloadData()
          }
          
        } catch let saveErr {
          print("Failed to save private Context: ", saveErr)
        }
        
      } catch let err {
        print("Failed to complete private fetch in background thread: ", err)
      }
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.companies = CoreDataManager.shared.fetchCompanies()
    
    navigationItem.leftBarButtonItems = [
      UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleResetButtonTapped)),
      UIBarButtonItem(title: "Nested Updates", style: .plain, target: self, action: #selector(doNestedUpdates))
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

