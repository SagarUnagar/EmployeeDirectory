//
//  EmployeeViewModel.swift
//  EmployeeDirectory
//
//  Created by Sagar Unagar on 06/06/19.
//  Copyright © 2019 Sagar's Lab. All rights reserved.
//

import Foundation
import Contacts
import ContactsUI

class EmployeeViewModel {
    
    //MARK:- Properties
    var backupEmployeeList = [Employee]()
    var employeeDatasource = [String: [Employee]]()
    var positions = [String]()
    
    //MARK:- Methods
    /**
     This method fetches all the employees from the server.
     */
    func fetchAllEmployee(completion: @escaping ResponseBlock) {
        NetworkServices.fetchEmployees { (employeeInfo, error) in
            if error != nil {
                print(error!)
                let customError = ErrorResult.custom(string: "Error while fetching data from the server. Please pull to refresh it again.")
                completion(nil, customError)
            } else {
                let employeeInformation = employeeInfo as! EmployeeInfo
                self.backupEmployeeList = self.linkContactCardWithEmployee(employees: employeeInformation.employees!)
                let employeeList = self.grabUniqueEmployees(from: self.backupEmployeeList)
                self.employeeDatasource = self.groupByPositions(employees: employeeList)
                completion(self.employeeDatasource, nil)
            }
        }
    }
    
    /**
     This method generate list of unique employee(first name and last name) from the employee list.
     
     - Parameter employees: List of employee fetched from server.
     - Returns: List of unique employees.
     */
    func grabUniqueEmployees(from employees: [Employee]) -> [Employee] {
        var employeeList = [Employee]()
        for employee in employees {
            if employeeList.count == 0 {
                employeeList.append(employee)
            } else {
                for emp in employees {
                    if !(emp.firstName! == employee.firstName! && emp.lastName! == employee.lastName!) {
                        employeeList.append(employee)
                        break
                    }
                }
            }
        }
        return employeeList
    }
    
    /**
     This method generate list of unique employee position from the employee list.
     
     - Parameter employees: List of employee fetched from server.
     */
    func groupByPositions(employees: [Employee]) -> [String: [Employee]] {
        for employee in employees {
            if !self.positions.contains(employee.position!) {
                self.positions.append(employee.position!)
            }
        }
        self.positions = self.positions.sorted { $0 < $1 }
        return self.fillDatasource(employees: employees)
    }
    
    /**
     This method fill the data into dictionary([String: [Employee]]).Employee list are sorted by its last name. This dictionary will be used as datasource of employeeTableView.
     
     - Parameter employees: List of employee fetched from server.
     */
    func fillDatasource(employees: [Employee]) -> [String: [Employee]] {
        var datasource =  [String: [Employee]]()
        for position in positions {
            var employeeArray = [Employee]()
            for employee in employees {
                if position == employee.position! {
                    employeeArray.append(employee)
                }
            }
            employeeArray =  employeeArray.sorted { $0.lastName! < $1.lastName! }
            datasource[position] = employeeArray
        }
        return datasource
    }
    
    
    /**
     This method fetches all the unified contacts from phone.
     */
    func fetchAllContactsFromPhone() -> [CNContact] {
        var contacts = [CNContact]()
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactViewController.descriptorForRequiredKeys()] as [Any]
        
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch let error {
            print(error)
        }
        
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                contacts.append(contentsOf: containerResults)
            } catch let error{
                print(error)
            }
        }
        return contacts
    }
    
    /**
     This method loop through the employees and link each employee with contact from phonebook if employee's full name and contacts full name are matched.
     
     - Parameter employees: List of employee fetched from server.
     - Returns: List of employees.
     */
    func linkContactCardWithEmployee(employees : [Employee]) -> [Employee]{
        let contacts = self.fetchAllContactsFromPhone()
        var employeeList = employees
        for (index, employee) in employeeList.enumerated() {
            let fullName = "\(employee.firstName!) \(employee.lastName!)".lowercased()
            for contact in contacts {
                let contactFullName = CNContactFormatter.string(from: contact, style: .fullName)?.lowercased()
                if fullName == contactFullName {
                    employeeList[index].contactCard = contact
                }
            }
        }
        return employeeList
    }
}
