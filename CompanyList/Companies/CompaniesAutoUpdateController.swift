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
  
  @objc private func handleAdd() {
    
    print("Add a company called BMW")
    let context = CoreDataManager.shared.persistentContainer.viewContext
    let company = Company(context: context)
    company.name = "BMW"
    
    do {
      try context.save()
    } catch let err {
      print(err)
    }
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = "company auto updates"
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd))
    
    tableView.backgroundColor = UIColor.darkGray
    tableView.register(CompanyCell.self, forCellReuseIdentifier: cellId)
    
    fetchedResultsController.fetchedObjects?.forEach({ (company) in
      print(company.name ?? "")
    })
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fetchedResultsController.sections![section].numberOfObjects
}

  let cellId = "cellId"
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CompanyCell
    
    let company = fetchedResultsController.object(at: indexPath)
    
//    cell.textLabel?.text = company.name
    cell.company = company
    
    return cell
  }




}
