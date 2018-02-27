//
//  CompaniesAutoUpdateController.swift
//  CompanyList
//
//  Created by doug harper on 2/26/18.
//  Copyright © 2018 Doug Harper. All rights reserved.
//

import UIKit
import CoreData

class CompaniesAutoUpdateController: UITableViewController, NSFetchedResultsControllerDelegate {
  
  lazy var fetchedResultsController: NSFetchedResultsController<Company> = {
    
    let context = CoreDataManager.shared.persistentContainer.viewContext
    
    let request: NSFetchRequest<Company> = Company.fetchRequest()
    request.sortDescriptors = [
    NSSortDescriptor(key: "name", ascending: true)
    ]
    
    let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    
    frc.delegate = self
    
    do {
      try frc.performFetch()
    } catch let err {
      print(err)
    }
    
    return frc
  }()
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    switch type {
    case .insert:
      tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
    case .delete:
      tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
    case .move:
      break
    case .update:
      break
    }
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .insert:
      tableView.insertRows(at: [newIndexPath!], with: .fade)
    case .delete:
      tableView.deleteRows(at: [indexPath!], with: .fade)
    case .update:
      tableView.reloadRows(at: [indexPath!], with: .fade)
    case .move:
      tableView.moveRow(at: indexPath!, to: newIndexPath!)
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
  
  @objc private func handleAdd() {
    
    print("Add a company called BMW")
    let context = CoreDataManager.shared.persistentContainer.viewContext
    let company = Company(context: context)
    company.name = "zzz"
    
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
