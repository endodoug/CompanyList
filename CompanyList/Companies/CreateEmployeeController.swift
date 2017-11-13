//
//  CreateEmployeeController.swift
//  CompanyList
//
//  Created by doug harper on 11/7/17.
//  Copyright © 2017 Doug Harper. All rights reserved.
//

import UIKit

class CreateEmployeeController: UIViewController {
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = ThemeColor.asphalt
    navigationItem.title = "Create Employee"
    setupCancelButtonInNavBar(selector: #selector(handleCancelTapped))
    _ = setupKhakiBackgroudView(height: 50)
  }
  
  @objc fileprivate func handleCancelTapped() {
    dismiss(animated: true, completion: nil)
  }
  
}


