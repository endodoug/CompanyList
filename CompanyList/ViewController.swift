//
//  ViewController.swift
//  CompanyList
//
//  Created by doug harper on 10/21/17.
//  Copyright © 2017 Doug Harper. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
   
    view.backgroundColor = .yellow
    
    navigationItem.title = "Companies"
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddButtonTapped))
    
    setUpNavControllerStyle()
    
  }
  
  @objc func handleAddButtonTapped() {
    print("add button tapped 👌")
  }
  
  func setUpNavControllerStyle() {
    navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.barTintColor = .red
    navigationController?.navigationBar.prefersLargeTitles = true
  }


}

