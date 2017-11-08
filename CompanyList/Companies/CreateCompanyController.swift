//
//  CreateCompanyController.swift
//  CompanyList
//
//  Created by doug harper on 10/24/17.
//  Copyright © 2017 Doug Harper. All rights reserved.
//

import UIKit
import CoreData

protocol CreateCompanyControllerDelegate {
  func didAddCompany(company: Company)
  func didEditCompany(company: Company)
}

class CreateCompanyController: UIViewController {
  
  var delegate: CreateCompanyControllerDelegate?
  
  var company: Company? {
    didSet {
      nameTextField.text = company?.name
      
      if let imageData = company?.imageData {
        companyImageView.image = UIImage(data: imageData)
        setUpCircularStyle(borderWidth: 4.0)
      }
      
      guard let founded = company?.founded else { return }
      datePicker.date = founded
    }
  }
  
  func setUpCircularStyle(borderWidth: CGFloat) {
    companyImageView.layer.cornerRadius = companyImageView.frame.width / 2
    companyImageView.clipsToBounds = true
    companyImageView.layer.borderColor = ThemeColor.asphalt.cgColor
    companyImageView.layer.borderWidth = borderWidth
  }
  
  lazy var companyImageView: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
    imageView.isUserInteractionEnabled = true
    imageView.contentMode = .scaleAspectFill
    imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
    
    return imageView
  }()
  
  @objc private func handleSelectPhoto() {
    print("📸 selecting photo")
    let imagePickerController = UIImagePickerController()
    
    imagePickerController.delegate = self
    imagePickerController.allowsEditing = true
    
    present(imagePickerController, animated: true, completion: nil)
  }
  
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
  
  let datePicker: UIDatePicker = {
    let picker = UIDatePicker()
    picker.datePickerMode = .date
    picker.translatesAutoresizingMaskIntoConstraints = false
    return picker
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSaveTapped))
    
    view.backgroundColor = ThemeColor.asphalt
    setUpUI()
    setupCancelButtonInNavBar(selector: #selector(handleCancelTapped))
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // ternary operator
    navigationItem.title = company == nil ? "Create Company" : "Edit Company"
    
  }
  
  func setUpUI() {
    let khakiBackgroundView: UIView = {
      let view = UIView()
      view.backgroundColor = ThemeColor.khaki
      return view
    }()
    
    view.addSubview(khakiBackgroundView)
    khakiBackgroundView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 350)
    
    view.addSubview(companyImageView)
    companyImageView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
    companyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
    view.addSubview(nameLabel)
    nameLabel.anchor(top: companyImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 100, height: 50)
    
    view.addSubview(nameTextField)
    nameTextField.anchor(top: nameLabel.topAnchor, left: nameLabel.rightAnchor, bottom: nameLabel.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    
    view.addSubview(datePicker)
    datePicker.anchor(top: nameLabel.bottomAnchor, left: view.leftAnchor, bottom: khakiBackgroundView.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    
  }
  
  @objc private func handleSaveTapped() {
    if company == nil {
      createCompany()
    } else {
      saveCompanyChanges()
    }
  }
  
  private func saveCompanyChanges() {
    // get the context first
    let context = CoreDataManager.shared.persistentContainer.viewContext
    // get the company value
    company?.name = nameTextField.text
    company?.founded = datePicker.date
    
    if let companyImage = companyImageView.image {
      let imageData = UIImageJPEGRepresentation(companyImage, 0.8)
      company?.imageData = imageData
    }
    
    // save the context
    do {
      try context.save()
      dismiss(animated: true, completion: {
        self.delegate?.didEditCompany(company: self.company!)
      })
    } catch let saveErr {
      print("Failed to save company changes: ", saveErr)
    }
  }
  
  private func createCompany() {
    let context = CoreDataManager.shared.persistentContainer.viewContext
    
    let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context) // Entity in the datamodel
    
    company.setValue(nameTextField.text, forKey: "name") // name is the attribute in the Entity above
    company.setValue(datePicker.date, forKey: "founded")
    
    if let companyImage = companyImageView.image {
      let imageData = UIImageJPEGRepresentation(companyImage, 0.8)
      company.setValue(imageData, forKey: "imageData")
    }
    
    // perform the save
    do {
      try context.save()
      
      //success
      dismiss(animated: true, completion: {
        self.delegate?.didAddCompany(company: company as! Company)
      })
      
    } catch let saveErr {
      print("Failed to save company: ", saveErr)
    }

  }
  
  @objc func handleCancelTapped() {
    dismiss(animated: true, completion: nil)
  }
}

extension CreateCompanyController: UINavigationControllerDelegate {
  
}

extension CreateCompanyController: UIImagePickerControllerDelegate {
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
  @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
    if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
      companyImageView.image = editedImage
    }
    else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      companyImageView.image = originalImage
    }
    
    setUpCircularStyle(borderWidth: 4.0)
    
    dismiss(animated: true, completion: nil)
  }
  
}



