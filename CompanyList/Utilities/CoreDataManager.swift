//
//  CoreDataManager.swift
//  CompanyList
//
//  Created by doug harper on 10/26/17.
//  Copyright © 2017 Doug Harper. All rights reserved.
//

import CoreData

struct CoreDataManager {
  
  static let shared = CoreDataManager() // lives as long as the application is alive and it's properties too.
  
  let persistentContainer: NSPersistentContainer = {
    
    let container = NSPersistentContainer(name: "CompanyModels")
    container.loadPersistentStores { (storeDescription, err) in
      if let err = err {
        fatalError("☢️ loading of store failed: \(err)")
      }
    }
    return container
  }()
  
  func fetchCompanies() -> [Company] {
    // attempt to fetch core data
    let context = persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
    
    do {
      let companies = try context.fetch(fetchRequest)
      return companies
      
    } catch let fetchErr {
      print("failed to fetch companies: ", fetchErr)
      return []
    }
  }
  
  func deleteCompanies() -> [Company] {
    let context = persistentContainer.viewContext
    
    let batchRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
    
    do {
      try context.execute(batchRequest)
      return []
      
    } catch let delErr {
      print("Failed to delete companies: ", delErr)
      return []
    }
  }
  
  func createEmployee(employeeName: String) -> Error? {
    let context = persistentContainer.viewContext
    
    //create Employee
    let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context)
    
    employee.setValue(employeeName, forKey: "name")
    
    do {
      try context.save()
      return nil
    } catch let saveErr {
      print("☢️ Failed to save employee: ", saveErr)
      return saveErr
    }
  }
  
}
