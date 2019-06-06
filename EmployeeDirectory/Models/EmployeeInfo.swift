//
//  Employee.swift
//  EmployeeDirectory
//
//  Created by Sagar Unagar on 03/06/19.
//  Copyright © 2019 Sagar's Lab. All rights reserved.
//

import Foundation
import Contacts

struct EmployeeInfo: Codable {
    var employees : [Employee]?
    enum CodingKeys: String, CodingKey {
        case employees = "employees"
    }
}

struct Employee : Codable {
    var firstName : String?
    var lastName : String?
    var position : String?
    var projects: [String]?
    var contactDetail: ContactDetails?
    var contactCard: CNContact?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "fname"
        case lastName = "lname"
        case position = "position"
        case projects = "projects"
        case contactDetail = "contact_details"
    }
}

extension Employee {
    struct ContactDetails : Codable {
        let email : String?
        let phone : String?
        
        enum CodingKeys: String, CodingKey {
            case email = "email"
            case phone = "phone"
        }
    }
}

