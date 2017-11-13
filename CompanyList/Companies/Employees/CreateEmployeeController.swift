//
//  CreateEmployeeController.swift
//  CompanyList
//
//  Created by doug harper on 11/7/17.
//  Copyright © 2017 Doug Harper. All rights reserved.
//

import UIKit

protocol CreateEmployeeControllerDelegate {
  func didAddEmployee(employee: Employee)
}

class CreateEmployeeController: UIViewController {
  
  var delegate: CreateEmployeeControllerDelegate?
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.text = "Name"
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.textColor = ThemeColor.asphalt
    
    return label
  }()
  
  let nameTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Enter Company Name"
    return textField
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = ThemeColor.asphalt
    navigationItem.title = "Create Employee"
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSaveTapped))
    setupCancelButtonInNavBar(selector: #selector(handleCancelTapped))
    _ = setupKhakiBackgroudView(height: 50)
    setupUI()
  }
  
  @objc fileprivate func handleSaveTapped() {
    print("trying to save")
    guard let employeeName = nameTextField.text else { return }
    let tuple = CoreDataManager.shared.createEmployee(employeeName: employeeName)
    
    if let error = tuple.1 {
      // present an error modal
      // perhaps a UIAlertController to show error message
      print(error)
      
    } else {
      // creation success!
      dismiss(animated: true, completion: {
        // call the delegate somehow
        self.delegate?.didAddEmployee(employee: tuple.0!)
        
      })
    }
 
  }
  
  @objc fileprivate func handleCancelTapped() {
    dismiss(animated: true, completion: nil)
  }
  
  private func setupUI() {
    
    
    view.addSubview(nameLabel)
    nameLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 100, height: 50)
    
    view.addSubview(nameTextField)
    nameTextField.anchor(top: nameLabel.topAnchor, left: nameLabel.rightAnchor, bottom: nameLabel.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

  }
  
  
}


