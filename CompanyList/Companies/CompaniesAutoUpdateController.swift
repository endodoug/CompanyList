//
//  CompaniesAutoUpdateController.swift
//  CompanyList
//
//  Created by doug harper on 2/26/18.
//  Copyright © 2018 Doug Harper. All rights reserved.
//

import UIKit
import CoreData

class CompaniesAutoUpdateController: UITableViewController {
  
  let fetchedResultsController: NSFetchedResultsController<Company> = {
    
    let context = CoreDataManager.shared.persistentContainer.viewContext
    
    let request: NSFetchRequest<Company> = Company.fetchRequest()
    request.sortDescriptors = [
    NSSortDescriptor(key: "name", ascending: true)
    ]
    
    let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    
    do {
      try frc.performFetch()
    } catch let err {
      print(err)
    }
    
    return frc
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = "company auto updates"
    
    tableView.backgroundColor = UIColor.darkGray
    
    fetchedResultsController.fetchedObjects?.forEach({ (company) in
      print(company.name ?? "")
    })
  }
}
