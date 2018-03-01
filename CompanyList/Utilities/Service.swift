//
//  Service.swift
//  CompanyList
//
//  Created by doug harper on 2/27/18.
//  Copyright © 2018 Doug Harper. All rights reserved.
//

import Foundation
import CoreData

struct Service {
  
  static let shared = Service()
  
  let urlString = "https://api.letsbuildthatapp.com/intermediate_training/companies"
 
  func downloadCompaniesFromServer() {
    guard let url = URL(string: urlString) else { return }
    
    URLSession.shared.dataTask(with: url) { (data, resp, err) in
      
      if let err = err {
        print("Failed to load JSON: ", err)
        return
      }
      // could leave a response message here
      
      guard let data = data else { return }
      
      let jsonDecoder = JSONDecoder()
      
      do {
        let jsonCompanies = try jsonDecoder.decode([JSONCompany].self, from: data)
        
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
        
        jsonCompanies.forEach({ (jsonCompany) in
          print(jsonCompany.name)
          
          let company = Company(context: privateContext)
          company.name = jsonCompany.name
          
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "MM/dd/yyyy"
          let foundedDate = dateFormatter.date(from: jsonCompany.founded)
          
          company.founded = foundedDate
          
          do {
            try privateContext.save()
            try privateContext.parent?.save()
          } catch let saveErr {
            print("Failed to save companies: ", saveErr)
          }
          
          jsonCompany.employees?.forEach({ (jsonEmployee) in
            print("   \(jsonEmployee.name)")
          })
          
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
  let photoUrl: String
  var employees: [JSONEmployee]?
}

struct JSONEmployee: Decodable {
  let name: String
  let birthday: String
  let type: String
}

















