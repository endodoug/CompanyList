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
  
  func downloadCompaniesFromServer() {
    print("Downloading JSON Data from Server")
  }
  
  
}
