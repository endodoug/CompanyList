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
  var company: Company?
  
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
  
  let birthdayLabel: UILabel = {
    let label = UILabel()
    label.text = "Birthday"
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.textColor = ThemeColor.asphalt
    return label
  }()
  
  let birthdayTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "MM/DD/YYYY"
    return textField
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = ThemeColor.asphalt
    navigationItem.title = "Create Employee"
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSaveTapped))
    setupCancelButtonInNavBar(selector: #selector(handleCancelTapped))
    setupUI()
  }
  
  @objc fileprivate func handleSaveTapped() {
    guard let company = company else { return }
    guard let employeeName = nameTextField.text else { return }
    
    // convert the birthdayTextField.text into a date object
    guard let birthdayText = birthdayTextField.text else { return }
    
    // validating birthday here
    if birthdayText.isEmpty {
      let alertController = UIAlertController(title: "Empty Birthday", message: "Please enter a birthday.", preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      present(alertController, animated: true, completion: nil)
      return
    }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    guard let birthdayDate = dateFormatter.date(from: birthdayText) else {
      let alertController = UIAlertController(title: "Birthday Format invalid", message: "Please enter a birthday in the following format \n MM/DD/YYYY", preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      present(alertController, animated: true, completion: nil)
      return
    }
    
    let tuple = CoreDataManager.shared.createEmployee(employeeName: employeeName, company: company, birthday: birthdayDate)
    
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
    
    _ = setupKhakiBackgroudView(height: 100)
    
    view.addSubview(nameLabel)
    nameLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 100, height: 50)
    
    view.addSubview(nameTextField)
    nameTextField.anchor(top: nameLabel.topAnchor, left: nameLabel.rightAnchor, bottom: nameLabel.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    
    view.addSubview(birthdayLabel)
    birthdayLabel.anchor(top: nameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    
    view.addSubview(birthdayTextField)
    birthdayTextField.anchor(top: birthdayLabel.topAnchor, left: nameTextField.leftAnchor, bottom: birthdayLabel.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

  }
  
  
}


