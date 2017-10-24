//
//  CreateCompanyController.swift
//  CompanyList
//
//  Created by doug harper on 10/24/17.
//  Copyright © 2017 Doug Harper. All rights reserved.
//

import UIKit

class CreateCompanyController: UIViewController {
  
  var companiesController: CompaniesController?
  
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
    
    navigationItem.title = "Create Company"
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelTapped))
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSaveTapped))
    
    view.backgroundColor = ThemeColor.asphalt
    setUpUI()
    
  }
  
  func setUpUI() {
    let khakiBackgroundView: UIView = {
      let view = UIView()
      view.backgroundColor = ThemeColor.khaki
      return view
    }()
    
    view.addSubview(khakiBackgroundView)
    khakiBackgroundView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
    
    view.addSubview(nameLabel)
    nameLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 100, height: 50)
    
    view.addSubview(nameTextField)
    nameTextField.anchor(top: nameLabel.topAnchor, left: nameLabel.rightAnchor, bottom: nameLabel.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
  }
  
  @objc private func handleSaveTapped() {
    
    dismiss(animated: true) {
      
      guard let name = self.nameTextField.text else { return }
      let company = Company(name: name, founded: Date())
      
      self.companiesController?.addCompany(company: company)
      
    }
  }
  
  @objc func handleCancelTapped() {
    dismiss(animated: true, completion: nil)
  }
}
