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
  
  
}
