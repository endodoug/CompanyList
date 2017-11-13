//
//  UIViewControllerHelpers.swift
//  CompanyList
//
//  Created by doug harper on 11/7/17.
//  Copyright © 2017 Doug Harper. All rights reserved.
//

import UIKit

extension UIViewController {
  
  // my extension/helper methods
  func setupPlusButtonInNavBar(selector: Selector) {
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: selector)
  }
  
  func setupCancelButtonInNavBar(selector: Selector) {
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: selector)
  }
  
  func setupKhakiBackgroudView(height: CGFloat) -> UIView {
    let khakiBackgroundView: UIView = {
      let view = UIView()
      view.backgroundColor = ThemeColor.khaki
      return view
    }()
    
    view.addSubview(khakiBackgroundView)
    khakiBackgroundView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: height)
    
    return khakiBackgroundView
  }
  
}
