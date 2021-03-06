//
//  CompaniesController+CreateCompany.swift
//  CompanyList
//
//  Created by doug harper on 11/4/17.
//  Copyright © 2017 Doug Harper. All rights reserved.
//

import UIKit

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
