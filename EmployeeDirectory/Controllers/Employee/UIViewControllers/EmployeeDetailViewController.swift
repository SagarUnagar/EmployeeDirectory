//
//  EmployeeDetailViewController.swift
//  EmployeeDirectory
//
//  Created by Sagar Unagar on 05/06/19.
//  Copyright © 2019 Sagar's Lab. All rights reserved.
//

import UIKit

class EmployeeDetailViewController: UIViewController {
    
    //MARK:- Interface Builder
    @IBOutlet weak var employeeDetailTableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!

    //MARK:- Propetries
    var selectedEmployee = Employee()
    
    //MARK:- ViewController's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    //MARK:- Custom Methods
    /**
     This is UI configuration method that will set ui component properties at run time.
     */
    func configureUI() {
        self.addTitle(title: "Employee Detail")
        self.loadEmployeeData()
    }
    
    /**
     This method fills the employee data to outlets.
     */
    func loadEmployeeData() {
        self.nameLabel.text = "\(self.selectedEmployee.firstName!) \(self.selectedEmployee.lastName!)"
    }

}

//MARK:- TableView Delegate and Datasource Methods
extension EmployeeDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            if let count = self.selectedEmployee.projects?.count {
                return count
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        } else {
            if let headerView = Bundle.main.loadNibNamed("EmployeeTableViewHeader", owner: self, options: nil)?[0] {
                let view = headerView as! EmployeeTableViewHeader
                view.headerLabel.text = "Projects (\(self.selectedEmployee.projects?.count ?? 0))"
                return view
            } else {
                return nil
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0
        } else {
            return 28.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeDetailTableViewCell", for: indexPath) as! EmployeeDetailTableViewCell
            if indexPath.row == 0 {
                cell.loadData(headerText: "postion", detailText: self.selectedEmployee.position ?? "N/A")
            } else if indexPath.row == 1 {
                cell.loadData(headerText: "email", detailText: self.selectedEmployee.contactDetail!.email ?? "N/A")
            } else {
                cell.loadData(headerText: "phone", detailText: self.selectedEmployee.contactDetail!.phone ?? "N/A")
            }
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeProjectTableViewCell", for: indexPath) as! EmployeeProjectTableViewCell
            cell.loadData(titleText: self.selectedEmployee.projects![indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
}

