//
//  EmployeeTableViewCell.swift
//  EmployeeDirectory
//
//  Created by Sagar Unagar on 04/06/19.
//  Copyright © 2019 Sagar's Lab. All rights reserved.
//

import UIKit

protocol EmployeeTableViewCellDelegate {
    func didTapEmployeeContactCard(cell: EmployeeTableViewCell)
}

class EmployeeTableViewCell: UITableViewCell {

    // MARK:- Interface Builder
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var employeeNameLabel: UILabel!
    @IBOutlet weak var employeeEmailLabel: UILabel!
    @IBOutlet weak var employeeContactCardButton: UIButton!
    
    //MARK:- Propeties
    var delegate: EmployeeTableViewCellDelegate?
    
    override func awakeFromNib() {
        self.bgView.layer.cornerRadius = 5.0
    }
    
    func loadData(employee: Employee, indexPath: IndexPath) {
        if let firstName = employee.firstName, let lastName = employee.lastName, let email = employee.contactDetail?.email {
            self.employeeNameLabel.text = "\(firstName) \(lastName)"
            self.employeeEmailLabel.text = email
        } else {
            self.employeeNameLabel.text = "N/A"
            self.employeeNameLabel.text = "N/A"
        }
        
        if employee.contactCard != nil {
            self.employeeContactCardButton.isHidden = false
        } else {
            self.employeeContactCardButton.isHidden = true
        }
    }
}

//MARK:- Button Actions
extension EmployeeTableViewCell {
    @IBAction func employeeContactCardButtonPressed() {
        self.delegate?.didTapEmployeeContactCard(cell: self)
    }
}
