//
//  Service.swift
//  CompanyList
//
//  Created by doug harper on 2/27/18.
//  Copyright © 2018 Doug Harper. All rights reserved.
//

import Foundation

struct Service {
  
  static let shared = Service()
  
  let urlString = "https://api.letsbuildthatapp.com/intermediate_training/companies"
  
  
  
  func downloadCompaniesFromServer() {
    guard let url = URL(string: urlString) else { return }
    
    URLSession.shared.dataTask(with: url) { (data, resp, err) in
      print("Finish Downloading")
      
      if let err = err {
        print("Failed to download JSON:", err)
      }
      // could check response here too
      let string = String(data: data!, encoding: .utf8)
      print(string)
      
      }.resume()
  }
  
  
}
