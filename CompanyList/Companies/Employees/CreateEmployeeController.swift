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
      showErrorAlertController(title: "Empty Birthday", message: "Please enter a birthday.")
      return
    }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    guard let birthdayDate = dateFormatter.date(from: birthdayText) else {
      showErrorAlertController(title: "Invalid Birthday", message: "Please enter a birthday in the following format \n MM/DD/YYYY")
      return
    }
    // save the value of the segmented controller
    guard let employeeType = employeeTypeSegmentedController.titleForSegment(at: employeeTypeSegmentedController.selectedSegmentIndex) else { return }
    
    // Where does the company come from?
    let tuple = CoreDataManager.shared.createEmployee(employeeName: employeeName, employeeType: employeeType, company: company, birthday: birthdayDate)
    
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
  
  let employeeTypeSegmentedController: UISegmentedControl = {
    let types = ["Executive", "Senior Mgmt", "Staff"]
    let segmentedControl = UISegmentedControl(items: types)
    segmentedControl.tintColor = ThemeColor.red
    return segmentedControl
  }()
  
  private func setupUI() {
    
    _ = setupKhakiBackgroudView(height: 150)
    
    view.addSubview(nameLabel)
    nameLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 100, height: 50)
    
    view.addSubview(nameTextField)
    nameTextField.anchor(top: nameLabel.topAnchor, left: nameLabel.rightAnchor, bottom: nameLabel.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    
    view.addSubview(birthdayLabel)
    birthdayLabel.anchor(top: nameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
    
    view.addSubview(birthdayTextField)
    birthdayTextField.anchor(top: birthdayLabel.topAnchor, left: nameTextField.leftAnchor, bottom: birthdayLabel.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    
    view.addSubview(employeeTypeSegmentedController)
    employeeTypeSegmentedController.anchor(top: birthdayLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 34)

  }
  
  private func showErrorAlertController(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alertController, animated: true, completion: nil)
  }
}


