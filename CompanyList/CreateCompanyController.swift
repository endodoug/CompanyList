//
//  CreateCompanyController.swift
//  CompanyList
//
//  Created by doug harper on 10/24/17.
//  Copyright © 2017 Doug Harper. All rights reserved.
//

import UIKit

class CreateCompanyController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = "Create Company"
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelTapped))
    
    view.backgroundColor = ThemeColor.teal
    
  }
  
  @objc func handleCancelTapped() {
    print(123)
  }
}
