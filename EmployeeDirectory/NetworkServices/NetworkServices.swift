//
//  NetworkServices.swift
//  EmployeeDirectory
//
//  Created by Sagar Unagar on 03/06/19.
//  Copyright © 2019 Sagar's Lab. All rights reserved.
//

import Foundation

class NetworkServices {
    
    enum Method: String {
        case GET
        case POST
        case PUT
        case DELETE
        case PATCH
    }
    
    static func createRequest(method: Method, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
    
    static func fetchEmployees(completion: @escaping ResponseBlock) {
        guard let url = URL(string: "https://tartu-jobapp.aw.ee/employee_list/") else {
            completion(nil, ErrorResult.custom(string: "Invalid URL"))
            return
        }
        
        let request = self.createRequest(method: .GET, url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            DispatchQueue.main.async {
                if let error = responseError {
                    completion(nil, error)
                } else if let jsonData = responseData {
                    let decoder = JSONDecoder()
                    do {
                        let employeeInfo = try decoder.decode(EmployeeInfo.self, from: jsonData)
                        completion(employeeInfo, nil)
                    } catch let error {
                        completion(nil, error)
                    }
                } else {
                    let error = ErrorResult.custom(string: "Data was not retrieved from request")
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
}
