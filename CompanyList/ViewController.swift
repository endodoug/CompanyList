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
    
    setUpNavControllerStyle()
    
    
  }
  
  func setUpNavControllerStyle() {
    navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.barTintColor = .red
    navigationController?.navigationBar.prefersLargeTitles = true
  }


}

