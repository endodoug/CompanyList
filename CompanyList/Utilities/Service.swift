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
        print("Failed to load JSON: ", err)
        return
      }
      // could leave a response message here
      
      guard let data = data else { return }
      
      let jsonDecoder = JSONDecoder()
      
      do {
        let jsonCompanies = try jsonDecoder.decode([JSONCompany].self, from: data)
        jsonCompanies.forEach({ (jsonCompany) in
          print(jsonCompany.name)
        })
        
      } catch let jsonDecodeErr {
        print("Failed to decode JSON:", jsonDecodeErr)
      }

      }.resume()
  }
  
}

struct JSONCompany: Decodable {
  let name: String
  let founded: String
}
